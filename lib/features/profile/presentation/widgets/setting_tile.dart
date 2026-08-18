import 'package:fit_track/core/theme/app_colors.dart';
import 'package:fit_track/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({super.key, 
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(child: Text(label, style: AppTypography.bodyMedium)),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 20.sp,
                ),
          ],
        ),
      ),
    );
  }
}