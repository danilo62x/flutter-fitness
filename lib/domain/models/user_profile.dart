import 'package:fitness/domain/models/achievement.dart';

/// A measurable target on the Profile screen (e.g. goal weight, weekly sessions).
class Goal {
  const Goal({
    required this.title,
    required this.current,
    required this.target,
    required this.unit,
    required this.accent,
  });

  final String title;
  final double current;
  final double target;
  final String unit;

  /// UI-agnostic accent tag mapped to a color by the view.
  final String accent;

  double get progress =>
      target == 0 ? 0 : (current / target).clamp(0.0, 1.0);
}

/// A finished workout in the profile history feed.
class WorkoutHistoryEntry {
  const WorkoutHistoryEntry({
    required this.name,
    required this.dateLabel,
    required this.durationMin,
    required this.kcal,
    required this.category,
  });

  final String name;
  final String dateLabel;
  final int durationMin;
  final int kcal;

  /// UI-agnostic category tag mapped to an icon by the view.
  final String category;
}

/// Aggregate profile shown on the Profile screen.
class UserProfile {
  const UserProfile({
    required this.name,
    required this.title,
    required this.since,
    required this.totalWorkouts,
    required this.streakDays,
    required this.hoursTrained,
    required this.caloriesBurned,
    required this.goals,
    required this.medals,
    required this.history,
  });

  final String name;
  final String title;
  final String since;
  final int totalWorkouts;
  final int streakDays;
  final int hoursTrained;
  final int caloriesBurned;
  final List<Goal> goals;
  final List<Achievement> medals;
  final List<WorkoutHistoryEntry> history;

  /// Initials for the avatar (no network image in the template).
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
