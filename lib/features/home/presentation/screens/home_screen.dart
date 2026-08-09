import 'package:fit_track/features/home/data/local/workout_stats.dart';
import 'package:fit_track/features/workouts/data/local/app_database.dart';
import 'package:fit_track/features/workouts/presentation/screens/log_workout_screen.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: StreamBuilder<List<WorkoutWithExercises>>(
          stream: AppDatabase.instance.watchAllWorkoutsWithExercises(),
          builder: (context, snapshot) {
            final items = snapshot.data ?? [];
            final stats = WorkoutStats.fromWorkouts(items);

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TODO: replace with real user name once auth/Cubit exists.
                  const HomeAppBar(name: 'Champ'),
                  SizedBox(height: 24.h),

                  StreakCard(streakDays: stats.streakDays),
                  SizedBox(height: 32.h),

                  StatCardRow(
                    workouts: stats.workoutsThisWeek,
                    workoutsDelta: stats.workoutsDeltaLabel,
                    volume: stats.volumeDisplay,
                    volumeDelta: stats.volumeDeltaLabel,
                    activeMins: stats.activeMinsThisWeek,
                    activeMinsDelta: stats.activeMinsDeltaLabel,
                  ),
                  SizedBox(height: 32.h),

                  ActivityHeatmapCard(
                    weeks: stats.heatmapWeeks,
                    intensities: stats.heatmapIntensities,
                  ),
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
            );
          },
        ),
      ),
    );
  }
}