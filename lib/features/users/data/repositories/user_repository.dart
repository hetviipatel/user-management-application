import '../../domain/models/user_model.dart';
import 'package:user_management_app/core/network/api_client.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  Future<Map<String, dynamic>> getUsers({
    int limit = 10,
    int skip = 0,
    String? search,
  }) async {
    try {
      final queryParams = {
        'limit': limit,
        'skip': skip,
        if (search != null && search.isNotEmpty) 'q': search,
      };

      // ✅ Use the correct endpoint for search
      final endpoint = (search != null && search.isNotEmpty)
          ? '/users/search'
          : '/users';

      final response = await _apiClient.get(endpoint, queryParameters: queryParams);

      final List<dynamic> usersJson = response.data['users'];
      final List<User> users = usersJson.map((json) => User.fromJson(json)).toList();

      return {
        'users': users,
        'total': response.data['total'],
        'skip': response.data['skip'],
        'limit': response.data['limit'],
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getUserPosts(int userId) async {
    try {
      final response = await _apiClient.get('/posts/user/$userId');
      return List<Map<String, dynamic>>.from(response.data['posts']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getUserTodos(int userId) async {
    try {
      final response = await _apiClient.get('/todos/user/$userId');
      return List<Map<String, dynamic>>.from(response.data['todos']);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getUserDetails(int userId) async {
    try {
      final response = await _apiClient.get('/users/$userId');
      return User.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
