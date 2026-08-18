import 'package:fit_track/features/workouts/data/local/app_database.dart';

enum ProgressRange { week, month, year }

class ChartPoint {
  ChartPoint({required this.label, required this.volume});
  final String label;
  final double volume;
}

class PersonalBest {
  PersonalBest({required this.exerciseName, required this.weightKg});
  final String exerciseName;
  final double weightKg;
}

class ProgressStats {
  ProgressStats({required this.chartPoints, required this.personalBests});

  final List<ChartPoint> chartPoints;
  final List<PersonalBest> personalBests;

  factory ProgressStats.fromWorkouts(
    List<WorkoutWithExercises> items,
    ProgressRange range,
  ) {
    return ProgressStats(
      chartPoints: _buildChartPoints(items, range),
      personalBests: _buildPersonalBests(items),
    );
  }

  static List<ChartPoint> _buildChartPoints(
    List<WorkoutWithExercises> items,
    ProgressRange range,
  ) {
    final now = DateTime.now();
    final strengthItems =
        items.where((w) => w.workout.type == 'strength').toList();

    switch (range) {
      case ProgressRange.week:
        // Last 7 days, daily granularity.
        const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
        return List.generate(7, (i) {
          final day = now.subtract(Duration(days: 6 - i));
          final volume = strengthItems
              .where((w) =>
                  w.workout.date.year == day.year &&
                  w.workout.date.month == day.month &&
                  w.workout.date.day == day.day)
              .fold<double>(0, (sum, w) => sum + w.totalVolumeKg);
          return ChartPoint(label: dayLabels[day.weekday - 1], volume: volume);
        });

      case ProgressRange.month:
        // Last 4 weeks, weekly totals.
        return List.generate(4, (i) {
          final weeksAgo = 3 - i;
          final weekStart = now.subtract(Duration(days: now.weekday - 1 + weeksAgo * 7));
          final weekEnd = weekStart.add(const Duration(days: 7));
          final volume = strengthItems
              .where((w) =>
                  !w.workout.date.isBefore(weekStart) &&
                  w.workout.date.isBefore(weekEnd))
              .fold<double>(0, (sum, w) => sum + w.totalVolumeKg);
          return ChartPoint(label: 'W${i + 1}', volume: volume);
        });

      case ProgressRange.year:
        // Last 12 months, monthly totals.
        const monthLabels = [
          'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D',
        ];
        return List.generate(12, (i) {
          final monthsAgo = 11 - i;
          final targetMonth = DateTime(now.year, now.month - monthsAgo, 1);
          final volume = strengthItems
              .where((w) =>
                  w.workout.date.year == targetMonth.year &&
                  w.workout.date.month == targetMonth.month)
              .fold<double>(0, (sum, w) => sum + w.totalVolumeKg);
          return ChartPoint(
            label: monthLabels[targetMonth.month - 1],
            volume: volume,
          );
        });
    }
  }

  static List<PersonalBest> _buildPersonalBests(
    List<WorkoutWithExercises> items,
  ) {
    final bestByExercise = <String, double>{};
    for (final item in items) {
      if (item.workout.type != 'strength') continue;
      for (final exercise in item.exercises) {
        final weight = exercise.weight;
        if (weight == null) continue;
        final current = bestByExercise[exercise.name] ?? 0;
        if (weight > current) bestByExercise[exercise.name] = weight;
      }
    }

    final list = bestByExercise.entries
        .map((e) => PersonalBest(exerciseName: e.key, weightKg: e.value))
        .toList()
      ..sort((a, b) => b.weightKg.compareTo(a.weightKg));

    return list.take(6).toList();
  }
}