import 'package:drift/drift.dart';

/// Matches the `workouts` table from the project doc.
class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Will hold the Supabase user id once auth/sync exist. Nullable
  // for now since everything is local-only in Phase 4.
  TextColumn get userId => text().nullable()();

  DateTimeColumn get date => dateTime()();

  // 'strength' or 'cardio'
  TextColumn get type => text()();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  // Used later for sync (Phase 6) — not read/written yet.
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// Matches the `exercises` table — child of Workouts.
class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get workoutId =>
      integer().references(Workouts, #id, onDelete: KeyAction.cascade)();

  TextColumn get name => text()();

  IntColumn get sets => integer().nullable()();
  IntColumn get reps => integer().nullable()();
  RealColumn get weight => real().nullable()();

  IntColumn get durationSeconds => integer().nullable()();
  RealColumn get distanceMeters => real().nullable()();

  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
}