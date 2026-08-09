import 'package:fit_track/features/workouts/data/local/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class WorkoutHistoryTile extends StatelessWidget {
  const WorkoutHistoryTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  final WorkoutWithExercises item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  bool get _isStrength => item.workout.type == 'strength';

  String get _dateLabel {
    final date = item.workout.date;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String get _summary {
    if (_isStrength) {
      final volume = item.totalVolumeKg;
      return '${item.exerciseCount} exercises · ${volume.toStringAsFixed(0)} kg';
    }
    final entry = item.cardioEntry;
    final km = entry?.distanceMeters != null
        ? (entry!.distanceMeters! / 1000).toStringAsFixed(1)
        : null;
    final min = entry?.durationSeconds != null
        ? (entry!.durationSeconds! / 60).round()
        : null;
    final parts = [
      if (km != null) '$km km',
      if (min != null) '$min min',
    ];
    return parts.isEmpty ? 'Cardio session' : parts.join(' · ');
  }

  IconData get _icon {
    if (_isStrength) return Icons.fitness_center;
    final name = item.cardioEntry?.name.toLowerCase() ?? '';
    if (name.contains('swim')) return Icons.pool;
    if (name.contains('bike') || name.contains('cycl')) {
      return Icons.directions_bike;
    }
    return Icons.directions_run;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.workout.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22.sp),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, color: AppColors.primary, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_dateLabel, style: AppTypography.headlineSmall),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            _isStrength ? 'Strength' : 'Cardio',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            _summary,
                            style: AppTypography.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}