import 'package:fit_track/core/theme/app_colors.dart';
import 'package:fit_track/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fit_track/features/auth/presentation/cubit/auth_state.dart';
import 'package:fit_track/features/auth/presentation/widgets/register_card.dart';
import 'package:fit_track/features/auth/presentation/widgets/register_top_section.dart';
import 'package:fit_track/shared/widgets/main_nav_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Successful signup -> go into the app, not back to login.
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainNavShell(),));
        } else if (state is AuthUnauthenticated) {
         
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Check your email to confirm your account.'),
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                RegisterTopSection(),
                RegisterCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}