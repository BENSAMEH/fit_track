import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/local/app_database.dart';
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
  bool _isSaving = false;

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

  bool get _hasContent {
    if (_type == WorkoutType.cardio) {
      return _cardioActivityController.text.trim().isNotEmpty ||
          _cardioDurationController.text.trim().isNotEmpty ||
          _cardioDistanceController.text.trim().isNotEmpty;
    }
    return _exercises.isNotEmpty;
  }

  Future<void> _finishWorkout() async {
    if (!_hasContent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one exercise first')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final db = AppDatabase.instance;

      if (_type == WorkoutType.strength) {
        final exerciseCompanions = <ExercisesCompanion>[];
        for (var i = 0; i < _exercises.length; i++) {
          final exercise = _exercises[i];
          for (var setIndex = 0; setIndex < exercise.sets.length; setIndex++) {
            final set = exercise.sets[setIndex];
            exerciseCompanions.add(
              ExercisesCompanion.insert(
                workoutId: 0, // overwritten inside saveWorkoutWithExercises
                name: exercise.name,
                sets: Value(setIndex + 1),
                reps: Value(set.reps),
                weight: Value(set.weight),
                orderIndex: Value(i),
              ),
            );
          }
        }

        await db.saveWorkoutWithExercises(
          workout: WorkoutsCompanion.insert(
            date: DateTime.now(),
            type: 'strength',
          ),
          exercises: exerciseCompanions,
        );
      } else {
        final duration = int.tryParse(_cardioDurationController.text.trim());
        final distance =
            double.tryParse(_cardioDistanceController.text.trim());
        final activity = _cardioActivityController.text.trim().isEmpty
            ? 'Cardio'
            : _cardioActivityController.text.trim();

        await db.saveWorkoutWithExercises(
          workout: WorkoutsCompanion.insert(
            date: DateTime.now(),
            type: 'cardio',
          ),
          exercises: [
            ExercisesCompanion.insert(
              workoutId: 0,
              name: activity,
              durationSeconds: Value(duration != null ? duration * 60 : null),
              distanceMeters:
                  Value(distance != null ? distance * 1000 : null),
            ),
          ],
        );
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save workout: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Log Workout', style: AppTypography.headlineMedium),
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
                            onDelete: () =>
                                setState(() => _exercises.removeAt(i)),
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
                          icon: Icon(Icons.add_circle_outline, size: 20.sp),
                          label: Text(
                            'Add Exercise',
                            style: AppTypography.headlineMedium,
                          ),
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
              onPressed: _isSaving ? null : _finishWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              child: _isSaving
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : Text(
                      'Finish Workout',
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}