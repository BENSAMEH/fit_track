import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.history_rounded, label: 'History'),
    _NavItem(icon: Icons.show_chart_rounded, label: 'Progress'),
    _NavItem(icon: Icons.favorite_rounded, label: 'Health'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryShades[800],
        border: Border(
          top: BorderSide(color: AppColors.secondaryShades[700]!, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (i) {
            return _NavButton(
              item: _items[i],
              selected: i == currentIndex,
              onTap: () => onTap(i),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selected tab gets a filled green pill behind the icon;
            // unselected tabs just show a plain gray icon.
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.all(selected ? 8.w : 0),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [
                  Icon(
                    item.icon,
                    color: selected ? Color(0xff007236) : AppColors.textSecondary,
                    size: 20.sp,
                  ),Text(
              item.label,
              style: AppTypography.labelSmall.copyWith(
                color: selected ? Color(0xff007236) : AppColors.textSecondary,
                fontSize: 12.sp,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            )
                ],
              ),
            ),
            SizedBox(height: 3.h),
            
          ],
        ),
      ),
    );
  }
}