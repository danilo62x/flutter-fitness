import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:fitness/ui/core/widgets/app_widgets.dart';
import 'package:fitness/ui/core/widgets/charts.dart';
import 'package:fitness/ui/features/workout/view_models/exercise_player_view_model.dart';

/// Live exercise player: circular timer, current set/reps, set progress dots and
/// transport controls (previous / pause / next).
class ExercisePlayerScreen extends StatelessWidget {
  const ExercisePlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExercisePlayerViewModel>();
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final exercise = vm.current;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Fechar',
        ),
        title: Text('Exercício ${vm.index + 1} de ${vm.total}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: (vm.index + 1) / vm.total,
                  minHeight: 8,
                  backgroundColor: scheme.primary.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                exercise.name,
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                vm.paused ? 'Pausado' : 'Em andamento',
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              TimerRing(
                progress: vm.timerProgress,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      muscleIcon(exercise.muscle),
                      size: 34,
                      color: scheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      vm.remainingLabel,
                      style: textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      'descanso',
                      style: textTheme.labelMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InfoPill(
                    icon: Icons.layers_rounded,
                    label: 'Série ${vm.currentSet} de ${exercise.sets}',
                  ),
                  const SizedBox(width: 12),
                  InfoPill(
                    icon: Icons.repeat_rounded,
                    label: '${exercise.reps} reps',
                    color: scheme.tertiary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SetDots(total: exercise.sets, current: vm.currentSet),
              const Spacer(),
              _Controls(vm: vm),
              const SizedBox(height: 18),
              if (vm.upcoming != null)
                _UpNextCard(name: vm.upcoming!.name),
            ],
          ),
        ),
      ),
    );
  }
}

class _SetDots extends StatelessWidget {
  const _SetDots({required this.total, required this.current});

  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(total, (i) {
        final done = i < current;
        return Container(
          width: done ? 26 : 12,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: done
                ? scheme.primary
                : scheme.primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.vm});

  final ExercisePlayerViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundButton(
          icon: Icons.skip_previous_rounded,
          onTap: vm.previousExercise,
          filled: false,
        ),
        const SizedBox(width: 28),
        _RoundButton(
          icon: vm.paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
          onTap: vm.togglePause,
          filled: true,
          size: 76,
        ),
        const SizedBox(width: 28),
        _RoundButton(
          icon: Icons.skip_next_rounded,
          onTap: vm.nextExercise,
          filled: false,
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.onTap,
    required this.filled,
    this.size = 60,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: filled ? scheme.primary : scheme.surfaceContainerHighest,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: filled ? 38 : 26,
            color: filled ? scheme.onPrimary : scheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _UpNextCard extends StatelessWidget {
  const _UpNextCard({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.arrow_forward_rounded, color: scheme.primary, size: 20),
            const SizedBox(width: 12),
            Text(
              'Próximo',
              style: textTheme.labelLarge?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
