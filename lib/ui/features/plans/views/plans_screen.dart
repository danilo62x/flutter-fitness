import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:fitness/domain/models/training_plan.dart';
import 'package:fitness/ui/core/widgets/app_widgets.dart';
import 'package:fitness/ui/features/plans/view_models/plans_view_model.dart';

/// Browse training plans with a level filter. Cards reflow to two columns on
/// wide screens.
class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlansViewModel>();
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final plans = vm.plans;

    return Scaffold(
      appBar: AppBar(title: const Text('Planos de treino')),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 720;
            final columns = wide ? 2 : 1;
            const spacing = 14.0;
            final contentWidth = wide ? 900.0 : double.infinity;
            final available = constraints.maxWidth.clamp(0.0, contentWidth) - 40;
            final cardWidth =
                columns == 1 ? available : (available - spacing) / 2;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  children: [
                    Text(
                      'Escolha um programa e evolua semana a semana.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _FilterChips(vm: vm),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        for (final plan in plans)
                          SizedBox(
                            width: cardWidth,
                            child: _PlanCard(
                              plan: plan,
                              onTap: () => context.push('/plan/${plan.id}'),
                            ),
                          ),
                      ],
                    ),
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

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.vm});

  final PlansViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 6,
      children: List<Widget>.generate(vm.filters.length, (i) {
        return ChoiceChip(
          label: Text(vm.filters[i]),
          selected: vm.selectedFilter == i,
          onSelected: (_) => vm.selectFilter(i),
        );
      }),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.onTap});

  final TrainingPlan plan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final visual = WorkoutVisual.of(plan.accent, scheme);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GradientBadge(icon: visual.icon, colors: visual.colors),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _LevelChip(level: plan.level),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: scheme.outline),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                plan.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  InfoPill(
                    icon: Icons.event_repeat_rounded,
                    label: '${plan.weeks} semanas',
                  ),
                  InfoPill(
                    icon: Icons.calendar_today_rounded,
                    label: '${plan.sessionsPerWeek}x/semana',
                    color: scheme.tertiary,
                  ),
                  InfoPill(
                    icon: Icons.flag_rounded,
                    label: plan.focus,
                    color: scheme.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Progresso',
                    style: textTheme.labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(plan.progress * 100).round()}%',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: plan.progress,
                  minHeight: 8,
                  backgroundColor: scheme.primary.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.level});

  final String level;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        level,
        style: textTheme.labelSmall?.copyWith(
          color: scheme.onSecondaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
