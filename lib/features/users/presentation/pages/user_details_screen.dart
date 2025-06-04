import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:user_management_app/features/users/presentation/bloc/user_bloc.dart';
import 'package:user_management_app/features/users/presentation/widgets/loading_indicator.dart';
import 'package:user_management_app/features/users/presentation/widgets/error_widget.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const LoadingIndicator();
          }

          if (state is UserError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => Navigator.pop(context),
            );
          }

          if (state is UserDetailsLoaded) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200.h,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: CachedNetworkImage(
                      imageUrl: state.user.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.user.fullName,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        _buildInfoRow(Icons.email, state.user.email),
                        _buildInfoRow(Icons.phone, state.user.phone),
                        _buildInfoRow(Icons.business, state.user.company.name),
                        _buildInfoRow(Icons.work, state.user.company.title),
                        _buildInfoRow(
                          Icons.location_on,
                          '${state.user.address.address}, ${state.user.address.city}, ${state.user.address.state}',
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'Posts',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        ...state.posts.map((post) => _buildPostCard(post)).toList(),
                        SizedBox(height: 24.h),
                        Text(
                          'Todos',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        ...state.todos.map((todo) => _buildTodoCard(todo)).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserDetailsLoaded) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/create-post',
                  arguments: state.user.id,
                );
              },
              child: const Icon(Icons.add),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 20.w, color: Colors.grey[600]),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['title'],
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              post['body'],
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoCard(Map<String, dynamic> todo) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListTile(
        leading: Icon(
          todo['completed'] ? Icons.check_circle : Icons.radio_button_unchecked,
          color: todo['completed'] ? Colors.green : Colors.grey,
        ),
        title: Text(
          todo['todo'],
          style: TextStyle(
            fontSize: 16.sp,
            decoration: todo['completed']
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
      ),
    );
  }
} 