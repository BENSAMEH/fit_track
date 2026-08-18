import 'package:fit_track/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fit_track/features/auth/presentation/screens/login_screen.dart';
import 'package:fit_track/features/auth/presentation/screens/splash_screen.dart';
import 'package:fit_track/shared/widgets/main_nav_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const FitTrackApp());
  
}

class FitTrackApp extends StatelessWidget {
  const FitTrackApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: ScreenUtilInit(
        designSize: const Size(390, 1045),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'FitTrack',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const MainNavShell(),
            },
          );
        },
      ),
    );
  }
}
