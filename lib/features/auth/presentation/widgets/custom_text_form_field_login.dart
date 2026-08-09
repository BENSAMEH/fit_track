import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class CustomTextFormFieldLogin extends StatelessWidget {
  const CustomTextFormFieldLogin({
    super.key,
    required this.label,
    this.preIcon,
    required this.hintText,
    this.suffIcon,
    this.forget,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.onForgotTap,
  });

  final String label;
  final Icon? preIcon;
  final Icon? suffIcon;
  final String hintText;
  final String? forget;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final VoidCallback? onForgotTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(fontSize: 12.sp),
            ),
            if (forget != null && forget!.isNotEmpty)
              GestureDetector(
                onTap: onForgotTap,
                child: Text(
                  forget!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          keyboardType: keyboardType,
          // Without this, typed text defaults to the theme's light
          // text color and is invisible on the white field background.
          style: AppTypography.bodyLarge.copyWith(
            color: Colors.black,
            fontSize: 16.sp,
          ),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintStyle: AppTypography.headlineSmall.copyWith(
              fontSize: 16.sp,
              color: const Color(0xFFBACBB9),
            ),
            prefixIcon: preIcon,
            suffixIcon: suffIcon,
            hintText: hintText,
            // filled + fillColor must be set together, or the fill
            // never actually renders.
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.danger, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}