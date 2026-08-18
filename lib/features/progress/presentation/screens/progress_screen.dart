import 'package:fit_track/features/home/presentation/widgets/activity_heatmap_card.dart';
import 'package:fit_track/features/workouts/data/local/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/progress_stats.dart';
import '../widgets/personal_bests_grid.dart';
import '../widgets/time_range_toggle.dart';
import '../widgets/volume_chart_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  ProgressRange _range = ProgressRange.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: StreamBuilder<List<WorkoutWithExercises>>(
          stream: AppDatabase.instance.watchAllWorkoutsWithExercises(),
          builder: (context, snapshot) {
            final items = snapshot.data ?? [];
            final stats = ProgressStats.fromWorkouts(items, _range);

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Progress', style: AppTypography.headlineMedium),
                  SizedBox(height: 20.h),

                  TimeRangeToggle(
                    selected: _range,
                    onChanged: (r) => setState(() => _range = r),
                  ),
                  SizedBox(height: 20.h),

                  VolumeChartCard(points: stats.chartPoints),
                  SizedBox(height: 16.h),

                  PersonalBestsGrid(bests: stats.personalBests),
                  SizedBox(height: 16.h),

                  // Compact heatmap — fewer weeks than Home's version.
                  const ActivityHeatmapCard(weeks: 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}