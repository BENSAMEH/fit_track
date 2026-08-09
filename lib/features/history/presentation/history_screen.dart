import 'package:fit_track/features/history/presentation/widgets/history_search_bar.dart';
import 'package:fit_track/features/history/presentation/widgets/workout_filter_chips.dart';
import 'package:fit_track/features/history/presentation/widgets/workout_history_tile.dart';
import 'package:fit_track/features/workouts/data/local/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _searchController = TextEditingController();
  WorkoutFilter _filter = WorkoutFilter.all;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<WorkoutWithExercises> _applyFilters(List<WorkoutWithExercises> items) {
    return items.where((item) {
      final matchesType = switch (_filter) {
        WorkoutFilter.all => true,
        WorkoutFilter.strength => item.workout.type == 'strength',
        WorkoutFilter.cardio => item.workout.type == 'cardio',
      };
      if (!matchesType) return false;

      if (_query.isEmpty) return true;
      return item.exercises.any((e) => e.name.toLowerCase().contains(_query));
    }).toList();
  }

  /// Groups items by "Month Year", preserving descending date order.
  /// The group containing today's month has no header (matches the
  /// reference: recent items appear ungrouped, older ones grouped).
  Map<String, List<WorkoutWithExercises>> _groupByMonth(
    List<WorkoutWithExercises> items,
  ) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final now = DateTime.now();
    final currentKey = '${months[now.month - 1]} ${now.year}';

    final grouped = <String, List<WorkoutWithExercises>>{};
    for (final item in items) {
      final date = item.workout.date;
      final key = '${months[date.month - 1]} ${date.year}';
      grouped.putIfAbsent(key, () => []).add(item);
    }

    // Reorder so the current month (if present) comes first without
    // its own header — matches the "recent items ungrouped" pattern.
    if (grouped.containsKey(currentKey)) {
      final currentItems = grouped.remove(currentKey)!;
      return {currentKey: currentItems, ...grouped};
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: StreamBuilder<List<WorkoutWithExercises>>(
          stream: AppDatabase.instance.watchAllWorkoutsWithExercises(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load history: ${snapshot.error}',
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              );
            }

            final allItems = snapshot.data ?? [];
            final filtered = _applyFilters(allItems);
            final grouped = _groupByMonth(filtered);

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('History', style: AppTypography.headlineMedium),
                          CircleAvatar(
                            radius: 18.r,
                            backgroundColor: AppColors.surfaceCard,
                            child: Icon(
                              Icons.person,
                              color: AppColors.textSecondary,
                              size: 18.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      HistorySearchBar(
                        controller: _searchController,
                        onFilterTap: () {
                          // TODO: open a fuller filter sheet if needed later.
                        },
                      ),
                      SizedBox(height: 12.h),
                      WorkoutFilterChips(
                        selected: _filter,
                        onChanged: (f) => setState(() => _filter = f),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            allItems.isEmpty
                                ? 'No workouts logged yet'
                                : 'No workouts match your search',
                            style: AppTypography.bodyMedium,
                          ),
                        )
                      : ListView(
                          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                          children: [
                            for (final entry in grouped.entries) ...[
                              if (grouped.keys.first != entry.key) ...[
                                SizedBox(height: 8.h),
                                Text(
                                  entry.key,
                                  style: AppTypography.headlineSmall,
                                ),
                                SizedBox(height: 10.h),
                              ],
                              for (final item in entry.value) ...[
                                WorkoutHistoryTile(
                                  item: item,
                                  onTap: () {
                                    // TODO: navigate to a workout detail screen.
                                  },
                                  onDelete: () {
                                    AppDatabase.instance
                                        .deleteWorkout(item.workout.id);
                                  },
                                ),
                                SizedBox(height: 12.h),
                              ],
                            ],
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}