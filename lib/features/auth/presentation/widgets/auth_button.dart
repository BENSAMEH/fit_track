import 'package:fit_track/core/theme/app_colors.dart';
import 'package:fit_track/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const AuthButton({
    super.key, 
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 292.w,
        height: 51.h,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12.r), // Added standard rounding
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTypography.headlineMedium.copyWith(
            color: Color(0xFF007236),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}