import 'package:fit_track/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fit_track/features/auth/presentation/cubit/auth_state.dart';
import 'package:fit_track/shared/widgets/main_nav_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/login_card.dart';
import '../widgets/logo_sections.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit,AuthState>(
      listener: ( context,state) { if (state is AuthAuthenticated) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainNavShell(),));
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    } },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              // Was (horizontal: 24.h, vertical: 65.w) — .h/.w were
              // swapped, which throws off scaling on non-square-ish
              // aspect ratios.
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
              child: Column(
                children: [
                  const LogoSections(),
                  SizedBox(height: 48.h),
                  // LoginCard now owns its own Form/controllers —
                  // no need to wrap it in another Form here.
                  const LoginCard(),
                  SizedBox(height: 32.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 16.sp,
                          color: const Color(0xFFB8B8B8),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign up',
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF39F27A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}