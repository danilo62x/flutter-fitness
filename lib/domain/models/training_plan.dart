/// A multi-week training program shown on the Plans screen.
class TrainingPlan {
  const TrainingPlan({
    required this.id,
    required this.name,
    required this.level,
    required this.weeks,
    required this.sessionsPerWeek,
    required this.focus,
    required this.accent,
    required this.progress,
    required this.description,
    this.tags = const <String>[],
  });

  final String id;
  final String name;
  final String level;
  final int weeks;
  final int sessionsPerWeek;
  final String focus;

  /// UI-agnostic accent tag mapped to an icon + gradient by the view.
  final String accent;

  /// Completion ratio in `0..1`.
  final double progress;
  final String description;
  final List<String> tags;
}
