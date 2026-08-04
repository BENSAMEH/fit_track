import 'package:fit_track/features/auth/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theme/app_theme.dart';


void main() {
  runApp(const FitTrackApp());
}

class FitTrackApp extends StatelessWidget {
  const FitTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    // designSize = the screen you designed against (e.g. your Stitch
    // frames). Every .w/.h/.sp/.r value scales relative to this.
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone-X-ish reference size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(home: SplashScreen(),
          title: 'FitTrack',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
         
        );
      },
    );
  }
}