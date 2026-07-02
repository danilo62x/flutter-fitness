import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fitness/domain/models/achievement.dart';
import 'package:fitness/domain/models/user_profile.dart';
import 'package:fitness/ui/core/widgets/app_widgets.dart';
import 'package:fitness/ui/features/profile/view_models/profile_view_model.dart';

/// Profile: identity header, lifetime stats, active goals, medals and the
/// recent workout history feed.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final profile = vm.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Configurações',
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth =
                constraints.maxWidth >= 640 ? 580.0 : double.infinity;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  children: [
                    _ProfileHeader(profile: profile),
                    const SizedBox(height: 16),
                    _StatsGrid(profile: profile),
                    const SizedBox(height: 22),
                    const SectionHeader(title: 'Metas'),
                    const SizedBox(height: 10),
                    for (final goal in profile.goals) ...[
                      _GoalTile(goal: goal),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 12),
                    const SectionHeader(title: 'Medalhas'),
                    const SizedBox(height: 10),
                    _Medals(items: profile.medals),
                    const SizedBox(height: 22),
                    const SectionHeader(title: 'Histórico'),
                    const SizedBox(height: 10),
                    for (final entry in profile.history) ...[
                      _HistoryTile(entry: entry),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[scheme.primary, scheme.tertiary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Text(
                profile.initials,
                style: textTheme.headlineSmall?.copyWith(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    profile.title,
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    profile.since,
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Editar',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StatCard(
              icon: Icons.fitness_center_rounded,
              value: '${profile.totalWorkouts}',
              label: 'Treinos',
            ),
          ),
          Expanded(
            child: StatCard(
              icon: Icons.local_fire_department_rounded,
              value: '${profile.streakDays}',
              label: 'Sequência',
              accent: scheme.tertiary,
            ),
          ),
          Expanded(
            child: StatCard(
              icon: Icons.timer_rounded,
              value: '${profile.hoursTrained}h',
              label: 'Horas',
              accent: scheme.secondary,
            ),
          ),
          Expanded(
            child: StatCard(
              icon: Icons.bolt_rounded,
              value: _compact(profile.caloriesBurned),
              label: 'Calorias',
            ),
          ),
        ],
      ),
    );
  }

  String _compact(int value) {
    if (value < 1000) return '$value';
    final k = value / 1000;
    return '${k.toStringAsFixed(1).replaceAll('.', ',')}k';
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tint = accentColor(goal.accent, scheme);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  goal.title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_fmt(goal.current)} / ${_fmt(goal.target)} ${goal.unit}',
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: goal.progress,
                minHeight: 8,
                backgroundColor: tint.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(tint),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double v) {
    final rounded = v.roundToDouble();
    return (v == rounded ? v.toStringAsFixed(0) : v.toStringAsFixed(1))
        .replaceAll('.', ',');
  }
}

class _Medals extends StatelessWidget {
  const _Medals({required this.items});

  final List<Achievement> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final item = items[i];
          final scheme = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;
          return Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: item.unlocked
                      ? scheme.primary
                      : scheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.unlocked
                      ? achievementIcon(item.icon)
                      : Icons.lock_outline_rounded,
                  color:
                      item.unlocked ? scheme.onPrimary : scheme.onSurfaceVariant,
                  size: 28,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 68,
                child: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry});

  final WorkoutHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final visual = WorkoutVisual.of(entry.category, scheme);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            GradientBadge(
              icon: visual.icon,
              colors: visual.colors,
              size: 46,
              radius: 14,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    entry.dateLabel,
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry.durationMin} min',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${entry.kcal} kcal',
                  style: textTheme.labelSmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
