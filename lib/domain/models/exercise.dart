/// A single exercise inside a [Workout].
///
/// [muscle] is a UI-agnostic tag (e.g. `chest`, `legs`, `core`) that the
/// presentation layer maps to an icon — keeping this model Flutter-free.
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.muscle,
    required this.sets,
    required this.reps,
    required this.restSec,
    this.note = '',
  });

  final String id;
  final String name;
  final String muscle;
  final int sets;

  /// Repetitions as a label so it can hold values like `12` or `45s`.
  final String reps;

  /// Rest between sets, in seconds.
  final int restSec;
  final String note;
}
