import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:fitness/domain/models/exercise.dart';
import 'package:fitness/domain/models/workout.dart';
import 'package:fitness/ui/core/widgets/app_widgets.dart';
import 'package:fitness/ui/features/workout/view_models/workout_detail_view_model.dart';

/// Workout detail: gradient header, meta pills, description and the ordered
/// exercise list. A pinned button starts the exercise player.
class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WorkoutDetailViewModel>();
    final workout = vm.workout;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Treino'),
        actions: [
          IconButton(
            onPressed: vm.toggleFavorite,
            icon: Icon(
              vm.favorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: vm.favorite ? scheme.primary : null,
            ),
            tooltip: 'Favoritar',
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth =
                constraints.maxWidth >= 640 ? 560.0 : double.infinity;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    _WorkoutHeader(workout: workout),
                    const SizedBox(height: 18),
                    _MetaPills(workout: workout),
                    const SizedBox(height: 18),
                    Text(
                      workout.description,
                      style: textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Text(
                          'Exercícios',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${workout.exerciseCount}',
                          style: textTheme.titleMedium?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    for (var i = 0; i < workout.exercises.length; i++) ...[
                      _ExerciseTile(
                        index: i + 1,
                        exercise: workout.exercises[i],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: FilledButton.icon(
          onPressed: () => context.push('/exercise/${workout.id}'),
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Iniciar treino'),
        ),
      ),
    );
  }
}

class _WorkoutHeader extends StatelessWidget {
  const _WorkoutHeader({required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final visual = WorkoutVisual.of(workout.category, scheme);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: visual.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: scheme.onPrimary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(visual.icon, color: scheme.onPrimary, size: 30),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.onPrimary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  workout.level,
                  style: textTheme.labelMedium?.copyWith(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            workout.name,
            style: textTheme.headlineSmall?.copyWith(
              color: scheme.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Foco em ${workout.focus.toLowerCase()}',
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onPrimary.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaPills extends StatelessWidget {
  const _MetaPills({required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        InfoPill(
          icon: Icons.schedule_rounded,
          label: '${workout.durationMin} min',
        ),
        InfoPill(
          icon: Icons.local_fire_department_rounded,
          label: '${workout.calories} kcal',
          color: scheme.tertiary,
        ),
        InfoPill(
          icon: Icons.repeat_rounded,
          label: '${workout.totalSets} séries',
          color: scheme.secondary,
        ),
        InfoPill(
          icon: Icons.fitness_center_rounded,
          label: workout.focus,
        ),
      ],
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({required this.index, required this.exercise});

  final int index;
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                muscleIcon(exercise.muscle),
                color: scheme.onPrimaryContainer,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${exercise.sets} séries × ${exercise.reps}  •  '
                    '${exercise.restSec}s descanso',
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$index',
              style: textTheme.titleMedium?.copyWith(
                color: scheme.outline,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
