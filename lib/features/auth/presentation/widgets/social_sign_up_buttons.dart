import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class SocialSignUpButtons extends StatelessWidget {
  const SocialSignUpButtons({
    super.key,
    required this.onGoogleTap,
    required this.onAppleTap,
  });

  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.secondaryShades[700])),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                'OR SIGN UP WITH',
                style: AppTypography.labelSmall.copyWith(letterSpacing: 0.8),
              ),
            ),
            Expanded(child: Divider(color: AppColors.secondaryShades[700])),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onGoogleTap,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.secondaryShades[800],
                  side: BorderSide(color: AppColors.secondaryShades[600]!),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                // Simple 'G' glyph — swap for a proper multi-color Google
                // asset/icon if you want pixel-exact branding.
                icon: Text(
                  'G',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                label: Text('Google', style: AppTypography.bodyMedium),
              ),
            ),
            SizedBox(width:10.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onAppleTap,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.secondaryShades[800],
                  side: BorderSide(color: AppColors.secondaryShades[600]!),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: const Icon(Icons.apple, color: Colors.white, size: 20),
                label: Text('Apple', style: AppTypography.bodyMedium),
              ),
            ),
          ],
        ),
      ],
    );
  }
}