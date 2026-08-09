
import 'package:fit_track/features/workouts/data/local/app_database.dart';

class WorkoutStats {
  WorkoutStats({
    required this.streakDays,
    required this.workoutsThisWeek,
    required this.workoutsDelta,
    required this.volumeThisWeekKg,
    required this.volumeDeltaKg,
    required this.activeMinsThisWeek,
    required this.activeMinsDelta,
    required this.heatmapIntensities,
    required this.heatmapWeeks,
  });

  final int streakDays;
  final int workoutsThisWeek;
  final int workoutsDelta;
  final double volumeThisWeekKg;
  final double volumeDeltaKg;
  final int activeMinsThisWeek;
  final int activeMinsDelta;

  /// Flat list, length = heatmapWeeks * 7, oldest first. Values 0-4.
  final List<int> heatmapIntensities;
  final int heatmapWeeks;

  String get workoutsDeltaLabel {
    if (workoutsDelta == 0) return 'Same as last week';
    final sign = workoutsDelta > 0 ? '+' : '';
    return '$sign$workoutsDelta this week';
  }

  String get volumeDisplay {
    if (volumeThisWeekKg >= 1000) {
      return '${(volumeThisWeekKg / 1000).toStringAsFixed(1)}k';
    }
    return volumeThisWeekKg.toStringAsFixed(0);
  }

  String get volumeDeltaLabel {
    if (volumeDeltaKg == 0) return 'No change';
    final sign = volumeDeltaKg > 0 ? '+' : '';
    final formatted = volumeDeltaKg.abs() >= 1000
        ? '${(volumeDeltaKg / 1000).toStringAsFixed(1)}k'
        : volumeDeltaKg.toStringAsFixed(0);
    return '$sign$formatted kg';
  }

  String get activeMinsDeltaLabel {
    if (activeMinsDelta == 0) return 'No change';
    final sign = activeMinsDelta > 0 ? '+' : '';
    return '$sign$activeMinsDelta mins';
  }

  /// Builds all derived stats from the raw workout list. Pass the
  /// full history — this does its own date filtering internally.
  factory WorkoutStats.fromWorkouts(
    List<WorkoutWithExercises> items, {
    int heatmapWeeks = 12,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // ---- Streak: consecutive days (ending today or yesterday) with
    // at least one workout. ----
    final workoutDates = items
        .map((w) => DateTime(
              w.workout.date.year,
              w.workout.date.month,
              w.workout.date.day,
            ))
        .toSet();

    int streak = 0;
    var cursor = today;
    // Allow the streak to still "count" if today has no workout yet,
    // as long as yesterday continues an active streak.
    if (!workoutDates.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    while (workoutDates.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    // ---- Week boundaries: Monday-start weeks. ----
    DateTime startOfWeek(DateTime d) =>
        d.subtract(Duration(days: d.weekday - 1));
    final thisWeekStart = startOfWeek(today);
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));

    bool inWeek(DateTime date, DateTime weekStart) {
      final d = DateTime(date.year, date.month, date.day);
      return !d.isBefore(weekStart) && d.isBefore(weekStart.add(const Duration(days: 7)));
    }

    final thisWeekItems =
        items.where((w) => inWeek(w.workout.date, thisWeekStart)).toList();
    final lastWeekItems =
        items.where((w) => inWeek(w.workout.date, lastWeekStart)).toList();

    // ---- Workouts count ----
    final workoutsThisWeek = thisWeekItems.length;
    final workoutsLastWeek = lastWeekItems.length;

    // ---- Volume (strength only) ----
    double volumeFor(List<WorkoutWithExercises> list) => list
        .where((w) => w.workout.type == 'strength')
        .fold<double>(0, (sum, w) => sum + w.totalVolumeKg);
    final volumeThisWeek = volumeFor(thisWeekItems);
    final volumeLastWeek = volumeFor(lastWeekItems);

    // ---- Active minutes ----
    // Cardio: real duration from the stored entry.
    // Strength: no duration is tracked yet in the schema, so this
    // estimates ~3 minutes per logged set as a rough proxy. Add a
    // `durationMinutes` column to Workouts later for real accuracy.
    int activeMinsFor(List<WorkoutWithExercises> list) {
      var total = 0;
      for (final w in list) {
        if (w.workout.type == 'cardio') {
          final seconds = w.cardioEntry?.durationSeconds ?? 0;
          total += (seconds / 60).round();
        } else {
          total += w.exercises.length * 3;
        }
      }
      return total;
    }

    final activeMinsThisWeek = activeMinsFor(thisWeekItems);
    final activeMinsLastWeek = activeMinsFor(lastWeekItems);

    // ---- Heatmap: last N weeks, 7 days each, oldest first ----
    final heatmapStart = thisWeekStart
        .subtract(Duration(days: 7 * (heatmapWeeks - 1)));
    final intensities = List<int>.generate(heatmapWeeks * 7, (i) {
      final day = heatmapStart.add(Duration(days: i));
      final count = items
          .where((w) =>
              w.workout.date.year == day.year &&
              w.workout.date.month == day.month &&
              w.workout.date.day == day.day)
          .length;
      if (count == 0) return 0;
      return count.clamp(1, 4);
    });

    return WorkoutStats(
      streakDays: streak,
      workoutsThisWeek: workoutsThisWeek,
      workoutsDelta: workoutsThisWeek - workoutsLastWeek,
      volumeThisWeekKg: volumeThisWeek,
      volumeDeltaKg: volumeThisWeek - volumeLastWeek,
      activeMinsThisWeek: activeMinsThisWeek,
      activeMinsDelta: activeMinsThisWeek - activeMinsLastWeek,
      heatmapIntensities: intensities,
      heatmapWeeks: heatmapWeeks,
    );
  }
}