import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({super.key, required this.streakDays});

  final int streakDays;

  String get _subtitle {
    if (streakDays == 0) return 'Log a workout to start your streak';
    if (streakDays < 3) return 'Off to a good start!';
    return "You're on fire! Keep it up.";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 142.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(.1),width: 1),
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CURRENT STREAK',
                  style: AppTypography.labelSmall.copyWith(
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$streakDays',
                      style: AppTypography.headlineLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text('Days', style: AppTypography.headlineSmall),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(_subtitle, style: AppTypography.bodySmall),
              ],
            ),
          ),
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: Color(0xFF39FF88).withOpacity(.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.primary,
              size: 30.sp,
            ),
          ),
        ],
      ),
    );
  }
}