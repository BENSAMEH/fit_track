import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/progress_stats.dart';

class TimeRangeToggle extends StatelessWidget {
  const TimeRangeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ProgressRange selected;
  final ValueChanged<ProgressRange> onChanged;

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
          _Option(
            label: 'Week',
            selected: selected == ProgressRange.week,
            onTap: () => onChanged(ProgressRange.week),
          ),
          _Option(
            label: 'Month',
            selected: selected == ProgressRange.month,
            onTap: () => onChanged(ProgressRange.month),
          ),
          _Option(
            label: 'Year',
            selected: selected == ProgressRange.year,
            onTap: () => onChanged(ProgressRange.year),
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(vertical: 9.h),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: selected ? Colors.black : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}