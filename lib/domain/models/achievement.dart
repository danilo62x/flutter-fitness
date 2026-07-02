/// A medal / achievement earned (or in progress) by the user.
class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
    this.progress = 1.0,
  });

  final String id;
  final String title;
  final String description;

  /// UI-agnostic icon tag mapped to [IconData] by the view.
  final String icon;
  final bool unlocked;

  /// Progress toward unlocking, in `0..1` (1 when [unlocked]).
  final double progress;
}
