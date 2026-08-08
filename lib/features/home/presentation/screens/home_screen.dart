import 'package:fit_track/features/workouts/presentation/screens/log_workout_screen.dart';
import 'package:fit_track/shared/widgets/app_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/activity_heatmap_card.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/log_workout_button.dart';
import '../widgets/stat_card_row.dart';
import '../widgets/streak_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data — replace with real values from Drift once
    // the local database + WorkoutCubit are wired up (Phase 4/5).
    const userName = 'Champ';
    const streakDays = 14;
    const workouts = 4;
    const workoutsDelta = '+1 this week';
    const volume = '12k';
    const volumeDelta = '+2.4k kg';
    const activeMins = 240;
    const activeMinsDelta = '+45 mins';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeAppBar(name: userName),
              SizedBox(height: 24.h),

              const StreakCard(streakDays: streakDays),
              SizedBox(height: 32.h),

              const StatCardRow(
                workouts: workouts,
                workoutsDelta: workoutsDelta,
                volume: volume,
                volumeDelta: volumeDelta,
                activeMins: activeMins,
                activeMinsDelta: activeMinsDelta,
              ),
              SizedBox(height: 32.h),

              const ActivityHeatmapCard(),
              SizedBox(height: 32.h),

              LogWorkoutButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LogWorkoutScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
