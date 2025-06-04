import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management_app/features/users/presentation/bloc/user_bloc.dart';
import 'package:user_management_app/features/users/presentation/widgets/user_list_item.dart';
import 'package:user_management_app/features/users/presentation/widgets/loading_indicator.dart';
import 'package:user_management_app/features/users/presentation/widgets/error_widget.dart';
import 'dart:async'; // Import dart:async for Timer

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<UserBloc>().add(const LoadUsers());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchTimer?.cancel(); // Cancel the timer in dispose
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<UserBloc>().state;
      if (state is UsersLoaded && !state.hasReachedMax) {
        context.read<UserBloc>().add(
              LoadUsers(
                skip: state.skip + state.limit,
                limit: state.limit,
                search: _searchController.text.isNotEmpty ? _searchController.text : null,
              ),
            );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String value) {
    _searchTimer?.cancel(); // Cancel previous timer
    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<UserBloc>().add(LoadUsers(skip: 0, search: value.isNotEmpty ? value : null));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Padding(
            padding: EdgeInsets.all(8.0.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: _searchController.text.isNotEmpty ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                ) : null,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
        ),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserDetailsLoaded) {
            Navigator.pushNamed(context, '/user-details');
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserInitial || state is UserLoading) {
              return const LoadingIndicator();
            }

            if (state is UserError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () => context.read<UserBloc>().add(LoadUsers(search: _searchController.text)),
              );
            }

            if (state is UsersLoaded) {
              if (state.users.isEmpty && _searchController.text.isNotEmpty) {
                return Center(
                  child: Text(
                    'No users found for \'$_searchController.text\'',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                );
              } else if (state.users.isEmpty) {
                return Center(
                  child: Text(
                    'No users found',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<UserBloc>().add(
                        LoadUsers(
                          search: _searchController.text.isNotEmpty ? _searchController.text : null,
                          skip: 0,
                        ),
                      );
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.users.length + (state.hasReachedMax ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index >= state.users.length) {
                      return const LoadingIndicator();
                    }

                    final user = state.users[index];
                    return UserListItem(
                      user: user,
                      onTap: () {
                        context.read<UserBloc>().add(LoadUserDetails(user.id));
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
} 