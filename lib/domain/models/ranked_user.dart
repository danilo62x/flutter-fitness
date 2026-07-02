/// A friend on the weekly leaderboard.
class RankedUser {
  const RankedUser({
    required this.id,
    required this.name,
    required this.points,
    required this.position,
    required this.trend,
    required this.level,
    this.isMe = false,
  });

  final String id;
  final String name;
  final int points;
  final int position;

  /// Positions gained (+) or lost (-) since last week.
  final int trend;
  final String level;
  final bool isMe;

  /// Initials for the avatar (no network image in the template).
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
