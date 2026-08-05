import 'package:fit_track/core/theme/app_colors.dart';
import 'package:fit_track/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoSections extends StatelessWidget {
  const LogoSections({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
            
                  
                   Image.asset('assets/images/logo.png'),
                   SizedBox(height: 18.h,),
                
                Text("FITTRACK", style: AppTypography.headlineLarge.copyWith(fontSize: 48.sp)),SizedBox(height: 18.h,),
                Text("Train smarter, not just harder",style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary,fontSize: 18.sp,fontWeight: FontWeight.w100),)
              ],
            ),
          );
  }
}