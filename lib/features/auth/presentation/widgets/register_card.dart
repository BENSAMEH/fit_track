import 'package:fit_track/core/theme/app_colors.dart';
import 'package:fit_track/core/theme/app_typography.dart';
import 'package:fit_track/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:fit_track/features/auth/presentation/widgets/custom_text_form_field_register.dart';
import 'package:fit_track/features/auth/presentation/widgets/password_strength_bar.dart';
import 'package:fit_track/features/auth/presentation/widgets/register_footer_link.dart';
import 'package:fit_track/features/auth/presentation/widgets/social_sign_up_buttons.dart';
import 'package:fit_track/features/auth/presentation/widgets/terms_checkbox_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class RegisterCard extends StatefulWidget {
  const RegisterCard({super.key});

  @override
  State<RegisterCard> createState() => _RegisterCardState();
}

class _RegisterCardState extends State<RegisterCard> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  PasswordStrength _strength = PasswordStrength.empty;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid) return;

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms of Service to continue'),
        ),
      );
      return;
    }

    // TODO: wire to auth Cubit once the auth data layer exists.
    // e.g. context.read<AuthCubit>().register(
    //   fullName: _fullNameController.text,
    //   email: _emailController.text,
    //   password: _passwordController.text,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 32.h, left: 24.w, right: 24.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextFormFieldRegister(
              label: 'FULL NAME',
              hintText: 'John Doe',
              controller: _fullNameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter your full name';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            CustomTextFormFieldRegister(
              label: 'EMAIL ADDRESS',
              hintText: 'john@example.com',
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

            CustomTextFormFieldRegister(
              label: 'PASSWORD',
              hintText: '••••••••',
              controller: _passwordController,
              obscureText: _obscurePassword,
              suffIcon: Icon(
                _obscurePassword
                    ? Icons.remove_red_eye_outlined
                    : Icons.visibility_off_outlined,
              ),
              onSuffixTap: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              validator: (value) {
                if (value == null || value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),
            // No SizedBox here — PasswordStrengthBar has its own top padding.
            Builder(
              builder: (context) {
                // Rebuild strength on every keystroke via a local listener.
                return ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _passwordController,
                  builder: (context, value, _) {
                    final strength = calculatePasswordStrength(value.text);
                    return PasswordStrengthBar(strength: strength);
                  },
                );
              },
            ),
            SizedBox(height: 16.h),

            CustomTextFormFieldRegister(
              label: 'CONFIRM PASSWORD',
              hintText: '••••••••',
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              suffIcon: Icon(
                _obscureConfirmPassword
                    ? Icons.remove_red_eye_outlined
                    : Icons.visibility_off_outlined,
              ),
              onSuffixTap: () {
                setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                );
              },
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),

            TermsCheckboxRow(
              value: _agreedToTerms,
              onChanged: (value) {
                setState(() => _agreedToTerms = value ?? false);
              },
              onTapTerms: () {
                // TODO: navigate to Terms of Service screen/URL.
              },
              onTapPrivacy: () {
                // TODO: navigate to Privacy Policy screen/URL.
              },
            ),
            SizedBox(height: 16.h),

            ElevatedButton(
              onPressed: _onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Create Account',
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height:16.h),

            SocialSignUpButtons(
              onGoogleTap: () {
                // TODO: wire to Google sign-up flow.
              },
              onAppleTap: () {
                // TODO: wire to Apple sign-up flow.
              },
            ),
            SizedBox(height: 16.h),

            RegisterFooterLink(
              onLoginTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}