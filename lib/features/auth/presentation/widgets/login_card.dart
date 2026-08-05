import 'package:fit_track/core/theme/app_colors.dart';
import 'package:fit_track/core/theme/app_typography.dart';
import 'package:fit_track/features/auth/presentation/widgets/social_login_button.dart';
import 'package:fit_track/features/auth/presentation/widgets/auth_button.dart';
import 'package:fit_track/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342.w,
      height: 475.h,
      decoration: BoxDecoration(border: BoxBorder.all(width: 1,color:Colors.white10 ),color: Color(0xFF1A1A1E),borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          children: [
            CustomTextFormField(
              hintText: "athlete@example.com",
              label: "EMAIL ADDRESS",
              preIcon: Icon(Icons.email, color: Color(0xFFBACBB9)),
            ),
            SizedBox(height: 16.h),
            CustomTextFormField(
              label: "PASSWORD",
              preIcon: Icon(Icons.password, color: Color(0xFFBACBB9)),
              hintText: "*********",
              forget: "FORGOT?",
            ),
            SizedBox(height: 16.h),
            AuthButton(onTap: () {}, text: "Continue"),
            SizedBox(height: 18.h),
            Row(
              children: [
                const Expanded(
                  child: Divider(thickness: 1, color: Color(0xFF2A2A2A)),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Text(
                    'OR',
                    style: AppTypography.labelMedium.copyWith(
                      fontSize: 14.sp,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const Expanded(
                  child: Divider(thickness: 1, color: Color(0xFF2A2A2A)),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            SocialLoginButton(
              image: "assets/icons/google.png",
              methodName: "Google",
            ), SizedBox(height: 16.h),
            SocialLoginButton(
              image: "assets/icons/download.png",
              methodName: "Apple",
            ),
          ],
        ),
      ),
    );
  }
}
