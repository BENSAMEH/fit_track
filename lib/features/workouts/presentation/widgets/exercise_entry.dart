/// A single logged set within an exercise. Kept as a simple mutable
/// class for now since state lives in setState — once WorkoutCubit
/// exists (Phase 5), this becomes an immutable model instead.
class SetEntry {
  SetEntry({this.weight, this.reps, this.completed = false});

  double? weight;
  int? reps;
  bool completed;
}

class ExerciseEntry {
  ExerciseEntry({required this.name, List<SetEntry>? sets})
      : sets = sets ?? [SetEntry()];

  String name;
  List<SetEntry> sets;
}