import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/models/user_model.dart';

// Events
abstract class UserEvent extends Equatable 
{
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends UserEvent {
  final int limit;
  final int skip;
  final String? search;

  const LoadUsers({
    this.limit = 10,
    this.skip = 0,
    this.search,
  });

  @override
  List<Object?> get props => [limit, skip, search];
}

class LoadUserDetails extends UserEvent {
  final int userId;

  const LoadUserDetails(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddPost extends UserEvent {
  final int userId;
  final String title;
  final String body;

  const AddPost(this.userId, this.title, this.body);

  @override
  List<Object?> get props => [userId, title, body];
}

// States
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<User> users;
  final int total;
  final int skip;
  final int limit;
  final bool hasReachedMax;

  const UsersLoaded({
    required this.users,
    required this.total,
    required this.skip,
    required this.limit,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [users, total, skip, limit, hasReachedMax];

  UsersLoaded copyWith({
    List<User>? users,
    int? total,
    int? skip,
    int? limit,
    bool? hasReachedMax,
  }) {
    return UsersLoaded(
      users: users ?? this.users,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class UserDetailsLoaded extends UserState {
  final User user;
  final List<Map<String, dynamic>> posts;
  final List<Map<String, dynamic>> todos;

  const UserDetailsLoaded({
    required this.user,
    required this.posts,
    required this.todos,
  });

  @override
  List<Object?> get props => [user, posts, todos];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadUserDetails>(_onLoadUserDetails);
    on<AddPost>(_onAddPost);
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoading) return; // Prevent multiple simultaneous loads

    final isNewSearchOrInitialLoad = event.skip == 0;

    if (isNewSearchOrInitialLoad) {
      emit(UserLoading());
    }

    try {
      final result = await _userRepository.getUsers(
        limit: event.limit,
        skip: event.skip,
        search: event.search,
      );

      final users = result['users'] as List<User>;
      final total = result['total'] as int;
      final skip = result['skip'] as int;
      final limit = result['limit'] as int;

      final hasReachedMax = users.length < limit || (skip + limit) >= total;

      if (isNewSearchOrInitialLoad) {
        emit(UsersLoaded(
          users: users,
          total: total,
          skip: skip,
          limit: limit,
          hasReachedMax: hasReachedMax,
        ));
      } else if (state is UsersLoaded) {
        final currentState = state as UsersLoaded;
        emit(currentState.copyWith(
          users: [...currentState.users, ...users],
          skip: skip,
          hasReachedMax: hasReachedMax,
        ));
      }
    } catch (e) {
      // Revert to previous state or handle error appropriately if needed for better UX
      // For simplicity, just emit error state here
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadUserDetails(
    LoadUserDetails event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());

      // Fetch the user details directly using the userId from the event
      final user = await _userRepository.getUserDetails(event.userId);

      final posts = await _userRepository.getUserPosts(event.userId);
      final todos = await _userRepository.getUserTodos(event.userId);

      emit(UserDetailsLoaded(
        user: user,
        posts: posts,
        todos: todos,
      ));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onAddPost(
    AddPost event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserDetailsLoaded) {
      final currentState = state as UserDetailsLoaded;
      // Create a dummy post with a temporary ID. In a real app, this would come from a backend.
      // Using a simple map to match the existing post structure.
      final newPost = {
        'userId': event.userId,
        'id': DateTime.now().millisecondsSinceEpoch, // Simple unique ID
        'title': event.title,
        'body': event.body,
      };

      emit(UserDetailsLoaded(
        user: currentState.user,
        posts: List.from(currentState.posts)..insert(0, newPost), // Add new post to the beginning
        todos: currentState.todos,
      ));
    }
  }
} 