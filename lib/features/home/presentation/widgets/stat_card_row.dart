import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class StatCardRow extends StatelessWidget {
  const StatCardRow({
    super.key,
    required this.workouts,
    required this.workoutsDelta,
    required this.volume,
    required this.volumeDelta,
    required this.activeMins,
    required this.activeMinsDelta,
  });

  final int workouts;
  final String workoutsDelta;
  final String volume;
  final String volumeDelta;
  final int activeMins;
  final String activeMinsDelta;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'WORKOUTS',
            value: '$workouts',
            delta: workoutsDelta,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _StatCard(label: 'VOLUME', value: '$volume ', delta: volumeDelta,volumeKg: "Kg",),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _StatCard(
            label: 'ACTIVE MINS',
            value: '$activeMins',
            delta: activeMinsDelta,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.delta,
    this.volumeKg
  });

  final String label;
  final String value;
  final String delta;
  final String ?volumeKg;

  @override
  Widget build(BuildContext context) {
    return Container(height: 134.h,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(.1),width: 1),
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(fontSize: 12.sp,letterSpacing: 0.4),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          Row(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(value, style: AppTypography.headlineSmall.copyWith(fontSize: 28.sp)),
              Column(
                children: [SizedBox(height: 10.h,),
                  Text(volumeKg??"",style: AppTypography.labelMedium.copyWith(fontSize: 14),),
                ],
              )
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            delta,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primary,
              fontSize: 10.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}