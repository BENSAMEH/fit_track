import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class ActivityHeatmapCard extends StatelessWidget {
  const ActivityHeatmapCard({
    super.key,
    this.weeks = 12,
    this.intensities,
  });

  /// How many weekly columns to show.
  final int weeks;

  /// Flat list of intensity values (0-4) for weeks*7 days, oldest
  /// first. Pass real data once Drift is wired up; if null, shows
  /// placeholder data so the layout can be reviewed now.
  final List<int>? intensities;

  List<int> _placeholderData() {
    // Fixed seed so the placeholder doesn't flicker between rebuilds.
    final random = Random(42);
    return List.generate(weeks * 7, (_) => random.nextInt(5));
  }

  Color _colorFor(int intensity) {
    switch (intensity) {
      case 0:
        return AppColors.secondaryShades[700]!;
      case 1:
        return AppColors.primaryShades[800]!;
      case 2:
        return AppColors.primaryShades[600]!;
      case 3:
        return AppColors.primaryShades[400]!;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = intensities ?? _placeholderData();

    return Container(
      width: double.infinity,
      height: 246.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(.1),width: 1),
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Activity Map', style: AppTypography.headlineMedium),
              Text(
                'LAST $weeks WEEKS',
                style: AppTypography.labelSmall.copyWith(letterSpacing: 0.5),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true, // shows most recent weeks by default
            child: Row(
              children: List.generate(weeks, (weekIndex) {
                return Padding(
                  padding: EdgeInsets.only(right: weekIndex < weeks - 1 ? 4.w : 0),
                  child: Column(
                    children: List.generate(7, (dayIndex) {
                      final value = data[weekIndex * 7 + dayIndex];
                      return Padding(
                        padding: EdgeInsets.only(bottom: dayIndex < 6 ? 4.h : 0),
                        child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: _colorFor(value),
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Less', style: AppTypography.labelSmall),
              SizedBox(width: 6.w),
              ...List.generate(5, (i) {
                return Padding(
                  padding: EdgeInsets.only(right: 3.w),
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: _colorFor(i),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                );
              }),
              SizedBox(width: 3.w),
              Text('More', style: AppTypography.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}