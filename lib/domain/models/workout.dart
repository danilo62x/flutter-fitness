import 'package:fitness/domain/models/exercise.dart';

/// Clean domain model consumed by the UI layer.
///
/// [category] is a UI-agnostic tag (e.g. `fullBody`, `cardio`, `strength`) that
/// the presentation layer maps to an icon and gradient — keeping this model free
/// of any Flutter dependency.
class Workout {
  const Workout({
    required this.id,
    required this.name,
    required this.durationMin,
    required this.level,
    required this.category,
    this.focus = '',
    this.calories = 0,
    this.description = '',
    this.exercises = const <Exercise>[],
  });

  final String id;
  final String name;
  final int durationMin;
  final String level;
  final String category;

  /// Primary muscle focus, e.g. `Corpo inteiro`.
  final String focus;

  /// Estimated calories burned.
  final int calories;
  final String description;
  final List<Exercise> exercises;

  int get exerciseCount => exercises.length;

  /// Total sets across every exercise.
  int get totalSets =>
      exercises.fold(0, (sum, exercise) => sum + exercise.sets);
}
