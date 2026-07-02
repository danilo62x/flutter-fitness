import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fitness/domain/models/workout.dart';

/// Maps a UI-agnostic workout [category] to an icon + gradient. Keeps the
/// domain model free of Flutter types.
class WorkoutVisual {
  const WorkoutVisual(this.icon, this.colors);

  final IconData icon;
  final List<Color> colors;

  static WorkoutVisual of(String category, ColorScheme scheme) {
    switch (category) {
      case 'cardio':
        return WorkoutVisual(Icons.favorite_rounded, <Color>[
          scheme.tertiary,
          scheme.primary,
        ]);
      case 'mobility':
        return WorkoutVisual(Icons.self_improvement_rounded, <Color>[
          scheme.secondary,
          scheme.tertiary,
        ]);
      case 'strength':
        return WorkoutVisual(Icons.sports_gymnastics_rounded, <Color>[
          scheme.primary,
          scheme.secondary,
        ]);
      case 'fullBody':
      default:
        return WorkoutVisual(Icons.fitness_center_rounded, <Color>[
          scheme.primary,
          scheme.tertiary,
        ]);
    }
  }
}

/// Icon for an exercise [muscle] tag.
IconData muscleIcon(String muscle) {
  switch (muscle) {
    case 'legs':
      return Icons.directions_run_rounded;
    case 'chest':
      return Icons.fitness_center_rounded;
    case 'back':
      return Icons.rowing_rounded;
    case 'shoulders':
      return Icons.accessibility_new_rounded;
    case 'core':
      return Icons.self_improvement_rounded;
    case 'cardio':
      return Icons.favorite_rounded;
    default:
      return Icons.fitness_center_rounded;
  }
}

/// Icon for a meal [category] tag.
IconData mealIcon(String category) {
  switch (category) {
    case 'breakfast':
      return Icons.free_breakfast_rounded;
    case 'lunch':
      return Icons.lunch_dining_rounded;
    case 'snack':
      return Icons.bakery_dining_rounded;
    case 'dinner':
      return Icons.dinner_dining_rounded;
    default:
      return Icons.restaurant_rounded;
  }
}

/// Icon for an achievement [tag].
IconData achievementIcon(String tag) {
  switch (tag) {
    case 'streak':
      return Icons.local_fire_department_rounded;
    case 'morning':
      return Icons.wb_sunny_rounded;
    case 'distance':
      return Icons.route_rounded;
    case 'trophy':
      return Icons.emoji_events_rounded;
    case 'strength':
      return Icons.fitness_center_rounded;
    default:
      return Icons.workspace_premium_rounded;
  }
}

/// Resolves a UI-agnostic accent tag to a [ColorScheme] color.
Color accentColor(String accent, ColorScheme scheme) {
  switch (accent) {
    case 'secondary':
      return scheme.secondary;
    case 'tertiary':
      return scheme.tertiary;
    case 'primary':
    default:
      return scheme.primary;
  }
}

/// A rounded, gradient-filled badge holding a single [icon]. Reused across
/// cards, tiles and headers (no network images).
class GradientBadge extends StatelessWidget {
  const GradientBadge({
    super.key,
    required this.icon,
    required this.colors,
    this.size = 56,
    this.radius = 16,
  });

  final IconData icon;
  final List<Color> colors;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(icon, color: scheme.onPrimary, size: size * 0.46),
    );
  }
}

/// A section title with an optional trailing action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction ?? () {},
            child: Text(action!),
          ),
      ],
    );
  }
}

/// A small tonal pill with an icon and a label (duration, level, calories…).
class InfoPill extends StatelessWidget {
  const InfoPill({
    super.key,
    required this.icon,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tint = color ?? scheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: tint),
          const SizedBox(width: 6),
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular progress ring drawn with [CustomPaint].
///
/// By default it centers a "NN% / da meta" caption, but a custom [center]
/// widget (or explicit [valueLabel]/[captionLabel]) can override that.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 108,
    this.stroke = 12,
    this.color,
    this.center,
    this.valueLabel,
    this.captionLabel = 'da meta',
  });

  final double progress;
  final double size;
  final double stroke;
  final Color? color;
  final Widget? center;
  final String? valueLabel;
  final String captionLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ringColor = color ?? scheme.primary;

    final centerChild = center ??
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              valueLabel ?? '${(progress * 100).round()}%',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
            Text(
              captionLabel,
              style: textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        );

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress: progress.clamp(0.0, 1.0),
          track: ringColor.withValues(alpha: 0.15),
          color: ringColor,
          stroke: stroke,
        ),
        child: Center(child: centerChild),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.track,
    required this.color,
    required this.stroke,
  });

  final double progress;
  final Color track;
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - stroke) / 2;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = track;
    canvas.drawCircle(center, radius, trackPaint);

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.track != track;
}

/// Compact statistic card: tonal icon, bold value and a muted label.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.accent,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tint = accent ?? scheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: tint.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: tint, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Weekly activity as seven bars, one highlighted.
class WeekBars extends StatelessWidget {
  const WeekBars({
    super.key,
    required this.labels,
    required this.values,
    required this.highlighted,
    this.maxHeight = 96,
    this.color,
  });

  final List<String> labels;
  final List<double> values;
  final int highlighted;
  final double maxHeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final barColor = color ?? scheme.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List<Widget>.generate(values.length, (i) {
        final isActive = i == highlighted;
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: maxHeight,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: maxHeight * values[i].clamp(0.0, 1.0),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: isActive
                          ? barColor
                          : barColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                labels[i],
                style: textTheme.labelSmall?.copyWith(
                  color: isActive ? barColor : scheme.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// A single "workout of the day" row: gradient icon, details and a round play
/// button. Tapping the row calls [onTap]; the play button calls [onPlay].
class WorkoutCard extends StatelessWidget {
  const WorkoutCard({super.key, required this.workout, this.onPlay, this.onTap});

  final Workout workout;
  final VoidCallback? onPlay;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final visual = WorkoutVisual.of(workout.category, scheme);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              GradientBadge(icon: visual.icon, colors: visual.colors),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${workout.durationMin} min  •  ${workout.level}',
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: scheme.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: onPlay ?? () {},
                  icon:
                      Icon(Icons.play_arrow_rounded, color: scheme.onPrimary),
                  tooltip: 'Iniciar treino',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
