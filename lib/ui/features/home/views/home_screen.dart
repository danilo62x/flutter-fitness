import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:fitness/ui/core/widgets/app_widgets.dart';
import 'package:fitness/ui/core/widgets/tab_scope.dart';
import 'package:fitness/ui/features/home/view_models/home_view_model.dart';

/// Home dashboard for the fitness template. A "dumb" view that reads all of its
/// state from [HomeViewModel] via `context.watch`.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth =
                constraints.maxWidth >= 640 ? 560.0 : double.infinity;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  children: [
                    _Header(vm: vm),
                    const SizedBox(height: 22),
                    _DailyGoalCard(vm: vm),
                    const SizedBox(height: 16),
                    const _QuickActions(),
                    const SizedBox(height: 20),
                    _StatsRow(vm: vm),
                    const SizedBox(height: 16),
                    _WeekCard(vm: vm),
                    const SizedBox(height: 24),
                    Text(
                      'Treinos de hoje',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final workout in vm.workouts) ...[
                      WorkoutCard(
                        workout: workout,
                        onTap: () => context.push('/workout/${workout.id}'),
                        onPlay: () => context.push('/exercise/${workout.id}'),
                      ),
                      const SizedBox(height: 12),
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

class _Header extends StatelessWidget {
  const _Header({required this.vm});

  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vm.greeting,
                style: textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                vm.userName,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        InfoPill(
          icon: Icons.local_fire_department_rounded,
          label: '${vm.streakDays} dias',
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 26,
          backgroundColor: scheme.primaryContainer,
          child: Text(
            vm.initials,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }
}

class _DailyGoalCard extends StatelessWidget {
  const _DailyGoalCard({required this.vm});

  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: scheme.primaryContainer.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            ProgressRing(progress: vm.goalProgress),
            const SizedBox(width: 22),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meta diária',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.local_fire_department_rounded,
                        color: scheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Calorias',
                        style: textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${vm.caloriesDone} / ${vm.caloriesGoal} kcal',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            icon: Icons.play_arrow_rounded,
            label: 'Iniciar',
            onTap: () => context.push('/exercise/w1'),
          ),
        ),
        Expanded(
          child: _QuickAction(
            icon: Icons.calendar_month_rounded,
            label: 'Planos',
            onTap: () => TabScope.of(context)?.goToTab(1),
          ),
        ),
        Expanded(
          child: _QuickAction(
            icon: Icons.restaurant_rounded,
            label: 'Nutrição',
            onTap: () => context.push('/nutrition'),
          ),
        ),
        Expanded(
          child: _QuickAction(
            icon: Icons.leaderboard_rounded,
            label: 'Ranking',
            onTap: () => context.push('/ranking'),
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: scheme.onPrimaryContainer, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.vm});

  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StatCard(
              icon: Icons.directions_walk_rounded,
              value: vm.steps,
              label: 'Passos',
            ),
          ),
          Expanded(
            child: StatCard(
              icon: Icons.map_rounded,
              value: vm.distance,
              label: 'Distância',
            ),
          ),
          Expanded(
            child: StatCard(
              icon: Icons.timer_rounded,
              value: vm.activeTime,
              label: 'Tempo',
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekCard extends StatelessWidget {
  const _WeekCard({required this.vm});

  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Atividade da semana',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 18),
            WeekBars(
              labels: [for (final d in vm.week) d.label],
              values: [for (final d in vm.week) d.value],
              highlighted: vm.highlightedDay,
            ),
          ],
        ),
      ),
    );
  }
}
