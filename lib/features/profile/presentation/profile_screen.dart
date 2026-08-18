import 'package:fit_track/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fit_track/features/auth/presentation/cubit/auth_state.dart';
import 'package:fit_track/features/profile/presentation/widgets/setting_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _fullName(AuthState state) {
    if (state is AuthAuthenticated) {
      final name = state.user.userMetadata?['full_name'] as String?;
      if (name != null && name.trim().isNotEmpty) return name.trim();
    }
    return 'Athlete';
  }

  String _email(AuthState state) {
    if (state is AuthAuthenticated) return state.user.email ?? '';
    return '';
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: Text('Log out?', style: AppTypography.headlineSmall),
        content: Text(
          'You\'ll need to sign in again to access your workouts.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Log out', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AuthCubit>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // Clear the whole navigation stack so back button can't
          // return into the app after logging out.
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final name = _fullName(state);
              final email = _email(state);
              final isLoading = state is AuthLoading;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    SizedBox(height: 24.h),

                    // Avatar + name + email
                    Row(
                      children: [
                        Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _initials(name),
                              style: AppTypography.headlineMedium.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.h),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: AppTypography.headlineSmall),
                              SizedBox(height: 2.h),
                              Text(email, style: AppTypography.bodySmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),

                    // Settings list — placeholders for now.
                    SettingsTile(
                      icon: Icons.notifications_outlined,
                      label: 'Workout Reminders',
                      trailing: Switch(
                        value: false,
                        activeColor: AppColors.primary,
                        onChanged: (_) {
                          // TODO: wire to local_notifications feature.
                        },
                      ),
                    ),
                    SettingsTile(
                      icon: Icons.favorite_outline,
                      label: 'Connected Accounts',
                      onTap: () {
                        // TODO: navigate to Health Sync settings.
                      },
                    ),
                    SettingsTile(
                      icon: Icons.file_download_outlined,
                      label: 'Export Data',
                      onTap: () {
                        // TODO: implement data export.
                      },
                    ),
                    SizedBox(height: 24.h),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: isLoading
                            ? null
                            : () => _confirmLogout(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.danger,
                          side: BorderSide(color: AppColors.danger),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.danger,
                                ),
                              )
                            : const Text('Log Out'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

