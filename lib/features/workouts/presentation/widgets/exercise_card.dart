import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'exercise_entry.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onDelete,
    required this.onAddSet,
    required this.onSetChanged,
    required this.onToggleComplete,
  });

  final ExerciseEntry exercise;
  final VoidCallback onDelete;
  final VoidCallback onAddSet;
  final void Function(int setIndex, {double? weight, int? reps}) onSetChanged;
  final void Function(int setIndex) onToggleComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.secondaryShades[700]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(exercise.name, style: AppTypography.headlineSmall),
              ),
              InkWell(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.danger,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Column headers
          Row(
            children: [
              SizedBox(width: 32.w, child: Text('SET', style: AppTypography.labelSmall)),
              Expanded(child: Text('LBS', style: AppTypography.labelSmall)),
              Expanded(child: Text('REPS', style: AppTypography.labelSmall)),
              SizedBox(width: 32.w),
            ],
          ),
          SizedBox(height: 8.h),

          ...List.generate(exercise.sets.length, (i) {
            final set = exercise.sets[i];
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  SizedBox(
                    width: 32.w,
                    child: Text('${i + 1}', style: AppTypography.bodyMedium),
                  ),
                  Expanded(
                    child: _SetInputField(
                      initialValue: set.weight?.toString(),
                      onChanged: (value) {
                        onSetChanged(i, weight: double.tryParse(value));
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _SetInputField(
                      initialValue: set.reps?.toString(),
                      onChanged: (value) {
                        onSetChanged(i, reps: int.tryParse(value));
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    width: 32.w,
                    child: InkWell(
                      onTap: () => onToggleComplete(i),
                      borderRadius: BorderRadius.circular(16.r),
                      child: Icon(
                        set.completed
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: set.completed
                            ? AppColors.primary
                            : AppColors.secondaryShades[500],
                        size: 22.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          SizedBox(height: 4.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onAddSet,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                '+ ADD SET',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SetInputField extends StatelessWidget {
  const _SetInputField({this.initialValue, required this.onChanged});

  final String? initialValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.center,
      style: AppTypography.bodyMedium,
      decoration: InputDecoration(
        isDense: true,
        hintText: '-',
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.secondaryShades[500],
        ),
        filled: true,
        fillColor: AppColors.secondaryShades[800],
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}