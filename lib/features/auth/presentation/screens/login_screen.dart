import 'package:fit_track/core/theme/app_typography.dart';
import 'package:fit_track/features/auth/presentation/screens/register_screen.dart';
import 'package:fit_track/features/auth/presentation/widgets/login_card.dart';
import 'package:fit_track/features/auth/presentation/widgets/logo_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

/// Placeholder — replace with the real sign-in UI next.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Form(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 65.w),
          child: Column(
            children: [
              LogoSections(),
              SizedBox(height: 48.h),
              LoginCard(),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 16.sp,
                      color: const Color(0xFFB8B8B8),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign up",
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF39F27A),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
