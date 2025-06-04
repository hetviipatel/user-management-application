import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/models/user_model.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const UserListItem({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            radius: 28.r,
            backgroundImage: CachedNetworkImageProvider(user.image),
          ),
          title: Text(
            user.fullName,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              Text(
                user.email,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
              ),
              SizedBox(height: 2.h),
              Text(
                user.company.name,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 18.w, color: Colors.grey),
        ),
      ),
    );
  }
} 