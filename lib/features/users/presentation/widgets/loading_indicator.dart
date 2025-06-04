import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.r,
            backgroundColor: Colors.white,
          ),
          title: Container(
            width: double.infinity,
            height: 16.h,
            color: Colors.white,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              Container(
                width: 200.w,
                height: 14.h,
                color: Colors.white,
              ),
              SizedBox(height: 2.h),
              Container(
                width: 150.w,
                height: 12.h,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 