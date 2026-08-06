import 'package:fit_track/core/theme/app_colors.dart';
import 'package:fit_track/features/auth/presentation/widgets/register_card.dart';
import 'package:fit_track/features/auth/presentation/widgets/register_top_section.dart';
import 'package:flutter/material.dart';



class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}