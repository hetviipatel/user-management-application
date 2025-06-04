import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management_app/features/users/presentation/bloc/user_bloc.dart';

class CreatePostScreen extends StatefulWidget {
  final int userId;

  const CreatePostScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _savePost() {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isNotEmpty && body.isNotEmpty) {
      // Dispatch event to Bloc to add post
      context.read<UserBloc>().add(AddPost(widget.userId, title, body));
      Navigator.pop(context); // Go back to user details screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Post'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: 'Body',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: _savePost,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  'Save Post',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 