import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// A workout bundled with its exercises — used by screens (like
/// History) that need to show a summary derived from both, without
/// running a separate query per row manually.
class WorkoutWithExercises {
  WorkoutWithExercises({required this.workout, required this.exercises});

  final Workout workout;
  final List<Exercise> exercises;

  /// Distinct exercise names — e.g. 3 sets of Bench Press count as 1
  /// exercise, matching how the History screen displays "N exercises".
  int get exerciseCount => exercises.map((e) => e.name).toSet().length;

  /// Sum of weight*reps across all set rows. Only meaningful for
  /// strength workouts.
  double get totalVolumeKg {
    return exercises.fold<double>(0, (sum, e) {
      final weight = e.weight ?? 0;
      final reps = e.reps ?? 0;
      return sum + (weight * reps);
    });
  }

  /// Only meaningful for cardio workouts — assumes a single exercise
  /// row holding duration/distance, matching how LogWorkoutScreen
  /// saves cardio sessions.
  Exercise? get cardioEntry => exercises.isNotEmpty ? exercises.first : null;
}

@DriftDatabase(tables: [Workouts, Exercises])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Singleton so the whole app shares one DB connection.
  static final AppDatabase instance = AppDatabase();

  @override
  int get schemaVersion => 1;

  // ---- Workout queries ----

  Future<int> insertWorkout(WorkoutsCompanion workout) {
    return into(workouts).insert(workout);
  }

  Future<void> insertExercises(List<ExercisesCompanion> exercises) {
    return batch((batch) => batch.insertAll(this.exercises, exercises));
  }

  /// Live stream of all workouts, most recent first.
  Stream<List<Workout>> watchAllWorkouts() {
    return (select(workouts)..orderBy([(w) => OrderingTerm.desc(w.date)]))
        .watch();
  }

  Future<List<Exercise>> getExercisesForWorkout(int workoutId) {
    return (select(exercises)..where((e) => e.workoutId.equals(workoutId)))
        .get();
  }

  /// Live stream of workouts + their exercises combined — what the
  /// History screen actually needs for its summary lines. Rebuilds
  /// automatically whenever the underlying workouts table changes.
  Stream<List<WorkoutWithExercises>> watchAllWorkoutsWithExercises() {
    return watchAllWorkouts().asyncMap((workoutList) async {
      final result = <WorkoutWithExercises>[];
      for (final w in workoutList) {
        final exs = await getExercisesForWorkout(w.id);
        result.add(WorkoutWithExercises(workout: w, exercises: exs));
      }
      return result;
    });
  }

  Future<void> deleteWorkout(int workoutId) {
    return (delete(workouts)..where((w) => w.id.equals(workoutId))).go();
  }

  /// Convenience: insert a workout plus all its exercises in one go.
  Future<int> saveWorkoutWithExercises({
    required WorkoutsCompanion workout,
    required List<ExercisesCompanion> exercises,
  }) async {
    return transaction(() async {
      final workoutId = await insertWorkout(workout);
      final exercisesWithId = exercises
          .map((e) => e.copyWith(workoutId: Value(workoutId)))
          .toList();
      await insertExercises(exercisesWithId);
      return workoutId;
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fittrack.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}