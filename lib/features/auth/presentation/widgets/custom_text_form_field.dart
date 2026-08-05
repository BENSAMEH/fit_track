import 'package:fit_track/core/theme/app_colors.dart';
import 'package:fit_track/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  String label;
  Icon preIcon;
  String hintText;
  String ?forget;
  CustomTextFormField({super.key, required this.label, required this.preIcon,required this.hintText,this.forget});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.labelMedium.copyWith(fontSize: 12.sp)),
            Text(forget??"",style: AppTypography.bodyMedium.copyWith(color: AppColors.primary,fontSize: 12.sp),)
          ],
        ),
        SizedBox(height: 8.h,),
        TextFormField(decoration: InputDecoration(hintStyle: AppTypography.headlineSmall.copyWith(fontSize: 16.sp,color:  Color(0xFFBACBB9)),prefixIcon: preIcon,hintText:hintText ,fillColor: Colors.white),)
      ],
    );
  }
}
