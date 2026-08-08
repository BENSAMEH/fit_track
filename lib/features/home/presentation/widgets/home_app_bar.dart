import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.onNotificationTap,
  });

  final String name;
  final String? avatarUrl;
  final VoidCallback? onNotificationTap;

  String get _formattedDate {
    const weekdays = [
      'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY',
      'FRIDAY', 'SATURDAY', 'SUNDAY',
    ];
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    final now = DateTime.now();
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 22.r,
          backgroundColor: AppColors.secondaryShades[700],
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null
              ? Icon(Icons.person, color: AppColors.textSecondary, size: 22.sp)
              : null,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formattedDate,
                style: AppTypography.labelSmall.copyWith(letterSpacing: 0.6),
              ),
              SizedBox(height: 2.h),
              Text('Welcome back, $name', style: AppTypography.headlineSmall.copyWith(fontSize: 20.sp)),
            ],
          ),
        ),
        InkWell(
          onTap: onNotificationTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: AppColors.textSecondary,
              size: 26.sp,
            ),
          ),
        ),
      ],
    );
  }
}