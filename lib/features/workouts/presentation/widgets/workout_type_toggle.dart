import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

enum WorkoutType { strength, cardio }

class WorkoutTypeToggle extends StatelessWidget {
  const WorkoutTypeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final WorkoutType selected;
  final ValueChanged<WorkoutType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleOption(
              label: 'Strength',
              selected: selected == WorkoutType.strength,
              onTap: () => onChanged(WorkoutType.strength),
            ),
          ),
          Expanded(
            child: _ToggleOption(
              label: 'Cardio',
              selected: selected == WorkoutType.cardio,
              onTap: () => onChanged(WorkoutType.cardio),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  const _ToggleOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: AnimatedContainer(width: 167.w,height: 48.h,
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: selected ? Colors.black : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}