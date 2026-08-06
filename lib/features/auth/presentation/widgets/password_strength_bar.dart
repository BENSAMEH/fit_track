import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

enum PasswordStrength { empty, weak, fair, good, strong }

/// Very simple heuristic — enough for UI feedback, not real security
/// scoring. Swap for zxcvbn or similar if you want it to be rigorous.
PasswordStrength calculatePasswordStrength(String password) {
  if (password.isEmpty) return PasswordStrength.empty;

  var score = 0;
  if (password.length >= 8) score++;
  if (RegExp(r'[A-Z]').hasMatch(password)) score++;
  if (RegExp(r'[0-9]').hasMatch(password)) score++;
  if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

  switch (score) {
    case 0:
    case 1:
      return PasswordStrength.weak;
    case 2:
      return PasswordStrength.fair;
    case 3:
      return PasswordStrength.good;
    default:
      return PasswordStrength.strong;
  }
}

class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({super.key, required this.strength});

  final PasswordStrength strength;

  int get _filledSegments {
    switch (strength) {
      case PasswordStrength.empty:
        return 0;
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.fair:
        return 2;
      case PasswordStrength.good:
        return 3;
      case PasswordStrength.strong:
        return 4;
    }
  }

  Color get _color {
    switch (strength) {
      case PasswordStrength.empty:
        return AppColors.secondaryShades[600]!;
      case PasswordStrength.weak:
        return AppColors.danger;
      case PasswordStrength.fair:
        return AppColors.primaryShades[600]!;
      case PasswordStrength.good:
        return AppColors.primaryShades[400]!;
      case PasswordStrength.strong:
        return AppColors.primary;
    }
  }

  String get _label {
    switch (strength) {
      case PasswordStrength.empty:
        return '';
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.good:
        return 'Good';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (strength == PasswordStrength.empty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: List.generate(4, (i) {
                final filled = i < _filledSegments;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i < 3 ? 4.w : 0),
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: filled
                          ? _color
                          : AppColors.secondaryShades[700],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(width: 10.w),
          Text(_label, style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}