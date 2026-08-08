import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/cardio_entry_card.dart';
import '../widgets/exercise_card.dart';
import '../widgets/exercise_entry.dart';
import '../widgets/workout_type_toggle.dart';

class LogWorkoutScreen extends StatefulWidget {
  const LogWorkoutScreen({super.key});

  @override
  State<LogWorkoutScreen> createState() => _LogWorkoutScreenState();
}

class _LogWorkoutScreenState extends State<LogWorkoutScreen> {
  WorkoutType _type = WorkoutType.strength;
  final List<ExerciseEntry> _exercises = [];

  final _cardioActivityController = TextEditingController();
  final _cardioDurationController = TextEditingController();
  final _cardioDistanceController = TextEditingController();

  @override
  void dispose() {
    _cardioActivityController.dispose();
    _cardioDurationController.dispose();
    _cardioDistanceController.dispose();
    super.dispose();
  }

  void _addExercise() async {
    final name = await _promptExerciseName(context);
    if (name == null || name.trim().isEmpty) return;
    setState(() => _exercises.add(ExerciseEntry(name: name.trim())));
  }

  Future<String?> _promptExerciseName(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: Text('Exercise name', style: AppTypography.headlineSmall),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: AppTypography.bodyLarge,
          decoration: const InputDecoration(hintText: 'e.g. Bench Press'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text('Add', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _finishWorkout() {
    // TODO: persist to Drift once local storage is wired up (next step).
    // For now this just proves the form's data is collectable.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Log Workout', style: AppTypography.headlineSmall),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: WorkoutTypeToggle(
                selected: _type,
                onChanged: (type) => setState(() => _type = type),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_type == WorkoutType.cardio) ...[
                      CardioEntryCard(
                        activityController: _cardioActivityController,
                        durationController: _cardioDurationController,
                        distanceController: _cardioDistanceController,
                      ),
                    ] else ...[
                      ...List.generate(_exercises.length, (i) {
                        final exercise = _exercises[i];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: ExerciseCard(
                            exercise: exercise,
                            onDelete: () => setState(() => _exercises.removeAt(i)),
                            onAddSet: () {
                              setState(() => exercise.sets.add(SetEntry()));
                            },
                            onSetChanged: (setIndex, {weight, reps}) {
                              setState(() {
                                if (weight != null) {
                                  exercise.sets[setIndex].weight = weight;
                                }
                                if (reps != null) {
                                  exercise.sets[setIndex].reps = reps;
                                }
                              });
                            },
                            onToggleComplete: (setIndex) {
                              setState(() {
                                final s = exercise.sets[setIndex];
                                s.completed = !s.completed;
                              });
                            },
                          ),
                        );
                      }),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _addExercise,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: BorderSide(
                              color: AppColors.secondaryShades[600]!,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Add Exercise'),
                        ),
                      ),
                    ],
                    SizedBox(height: 80.h), // clearance for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: _finishWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Finish Workout',
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}