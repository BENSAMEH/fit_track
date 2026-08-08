import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_typography.dart';
import 'auth_button.dart';
import 'custom_text_form_field_login.dart';
import 'social_login_button.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    // TODO: wire to auth Cubit once the auth data layer exists.
    // e.g. context.read<AuthCubit>().login(
    //   email: _emailController.text,
    //   password: _passwordController.text,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342.w,
      // Fixed height removed — a fixed height plus a growing error
      // message under a field causes bottom overflow. Let it size
      // to its content instead.
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.white10),
        color: const Color(0xFF1A1A1E),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormFieldLogin(
                hintText: 'athlete@example.com',
                label: 'EMAIL ADDRESS',
                preIcon: const Icon(Icons.email, color: Color(0xFFBACBB9)),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your email';
                  }
                  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              CustomTextFormFieldLogin(
                label: 'PASSWORD',
                preIcon: const Icon(Icons.lock, color: Color(0xFFBACBB9)),
                hintText: '*********',
                forget: 'FORGOT?',
                controller: _passwordController,
                obscureText: true,
                onForgotTap: () {
                  // TODO: navigate to forgot-password screen.
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              AuthButton(onTap: _onContinue, text: 'Continue'),
              SizedBox(height: 18.h),
              Row(
                children: [
                  const Expanded(
                    child: Divider(thickness: 1, color: Color(0xFF2A2A2A)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Text(
                      'OR',
                      style: AppTypography.labelMedium.copyWith(
                        fontSize: 14.sp,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(thickness: 1, color: Color(0xFF2A2A2A)),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              SocialLoginButton(
                image: 'assets/icons/google.png',
                methodName: 'Google',
                onTap: () {
                  // TODO: wire to Google sign-in flow.
                },
              ),
              SizedBox(height: 16.h),
              SocialLoginButton(
                image: 'assets/icons/download.png',
                methodName: 'Apple',
                onTap: () {
                  // TODO: wire to Apple sign-in flow.
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}