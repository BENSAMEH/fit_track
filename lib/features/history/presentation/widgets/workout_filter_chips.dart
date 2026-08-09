import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

enum WorkoutFilter { all, strength, cardio }

class WorkoutFilterChips extends StatelessWidget {
  const WorkoutFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final WorkoutFilter selected;
  final ValueChanged<WorkoutFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Chip(
          label: 'All',
          showCheck: true,
          selected: selected == WorkoutFilter.all,
          onTap: () => onChanged(WorkoutFilter.all),
        ),
        SizedBox(width: 8.w),
        _Chip(
          label: 'Strength',
          selected: selected == WorkoutFilter.strength,
          onTap: () => onChanged(WorkoutFilter.strength),
        ),
        SizedBox(width: 8.w),
        _Chip(
          label: 'Cardio',
          selected: selected == WorkoutFilter.cardio,
          onTap: () => onChanged(WorkoutFilter.cardio),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.showCheck = false,
  });

  final String label;
  final bool selected;
  final bool showCheck;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected && showCheck) ...[
              Icon(Icons.check, size: 14.sp, color: Colors.black),
              SizedBox(width: 4.w),
            ],
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: selected ? Colors.black : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}