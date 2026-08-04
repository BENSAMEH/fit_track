import 'package:fit_track/features/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

import '../../../core/theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Placeholder timing/logic — later this becomes a Cubit that
    // checks auth state instead of just waiting on a timer.
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginScreen(),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            SizedBox(height: 20.h),
            RichText(
              text: TextSpan(
                style: AppTypography.headlineMedium,
                children: [
                  TextSpan(
                    text: 'Fit',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  const TextSpan(text: 'Track'),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Train smarter, not just harder',
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}



