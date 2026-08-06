import 'package:fit_track/core/theme/app_colors.dart';
import 'package:fit_track/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterTopSection extends StatelessWidget {
  const RegisterTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 48.h, left: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundColor: Color(0xff353437),
            child: IconButton(
              onPressed: () {Navigator.pop(context);},
              icon: Icon(Icons.arrow_back_sharp, color: Color(0xffE5E1E4)),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Create your account",
            style: AppTypography.headlineLarge.copyWith(
              fontSize: 28.sp,
              color: AppColors.primary,
            ),
          ),
           SizedBox(height: 8.h),
           Text("Start tracking your progress today",style: AppTypography.bodyLarge.copyWith(fontSize: 16.sp),)

        ],
      ),
    );
  }
}
