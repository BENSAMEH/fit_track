import 'package:fit_track/features/auth/presentation/screens/splash_screen.dart';
import 'package:fit_track/features/home/presentation/screens/home_screen.dart';
import 'package:fit_track/shared/widgets/main_nav_shell.dart';
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
    
    return ScreenUtilInit(
      designSize: const Size(390, 1045),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(home:MainNavShell(),
          title: 'FitTrack',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
         
        );
      },
    );
  }
}