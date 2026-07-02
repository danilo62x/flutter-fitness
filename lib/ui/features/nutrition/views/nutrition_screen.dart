import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fitness/domain/models/macro.dart';
import 'package:fitness/domain/models/meal.dart';
import 'package:fitness/domain/models/nutrition_day.dart';
import 'package:fitness/ui/core/widgets/app_widgets.dart';
import 'package:fitness/ui/core/widgets/charts.dart';
import 'package:fitness/ui/features/nutrition/view_models/nutrition_view_model.dart';

/// Daily nutrition: calorie ring, macro bars, a water tracker and the meal log.
class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NutritionViewModel>();
    final day = vm.day;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrição'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                vm.dateLabel,
                style: textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
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
                    _CaloriesCard(day: day),
                    const SizedBox(height: 16),
                    _MacrosCard(macros: day.macros),
                    const SizedBox(height: 16),
                    _WaterCard(vm: vm),
                    const SizedBox(height: 22),
                    const SectionHeader(title: 'Refeições'),
                    const SizedBox(height: 8),
                    for (final meal in day.meals) ...[
                      _MealTile(meal: meal),
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

class _CaloriesCard extends StatelessWidget {
  const _CaloriesCard({required this.day});

  final NutritionDay day;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: scheme.primaryContainer.withValues(alpha: 0.30),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            ProgressRing(
              progress: day.calorieProgress,
              size: 132,
              stroke: 14,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${day.caloriesConsumed}',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
                  ),
                  Text(
                    'de ${day.caloriesGoal}',
                    style: textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CalorieStat(
                    label: 'Consumidas',
                    value: '${day.caloriesConsumed} kcal',
                    color: scheme.primary,
                  ),
                  const SizedBox(height: 12),
                  _CalorieStat(
                    label: 'Restantes',
                    value: '${day.caloriesRemaining} kcal',
                    color: scheme.tertiary,
                  ),
                  const SizedBox(height: 12),
                  _CalorieStat(
                    label: 'Queimadas',
                    value: '${day.caloriesBurned} kcal',
                    color: scheme.secondary,
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

class _CalorieStat extends StatelessWidget {
  const _CalorieStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MacrosCard extends StatelessWidget {
  const _MacrosCard({required this.macros});

  final List<Macro> macros;

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
              'Macronutrientes',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < macros.length; i++) ...[
              MacroBar(
                label: macros[i].name,
                value: macros[i].grams,
                goal: macros[i].goalGrams,
                unit: 'g',
                color: accentColor(macros[i].accent, scheme),
              ),
              if (i != macros.length - 1) const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _WaterCard extends StatelessWidget {
  const _WaterCard({required this.vm});

  final NutritionViewModel vm;

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
            Row(
              children: [
                Text(
                  'Água',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '${vm.water} de ${vm.waterGoal} copos',
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List<Widget>.generate(vm.waterGoal, (i) {
                      final filled = i < vm.water;
                      return Icon(
                        filled
                            ? Icons.local_drink_rounded
                            : Icons.local_drink_outlined,
                        color: filled
                            ? scheme.primary
                            : scheme.onSurfaceVariant.withValues(alpha: 0.5),
                        size: 26,
                      );
                    }),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: vm.removeWater,
                  icon: const Icon(Icons.remove_rounded),
                ),
                const SizedBox(width: 6),
                IconButton.filled(
                  onPressed: vm.addWater,
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MealTile extends StatelessWidget {
  const _MealTile({required this.meal});

  final Meal meal;

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
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                mealIcon(meal.category),
                color: scheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    meal.items,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                  '${meal.kcal} kcal',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  meal.time,
                  style: textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
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
