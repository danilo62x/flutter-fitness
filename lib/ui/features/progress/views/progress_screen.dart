import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fitness/domain/models/achievement.dart';
import 'package:fitness/domain/models/metric_series.dart';
import 'package:fitness/ui/core/widgets/app_widgets.dart';
import 'package:fitness/ui/core/widgets/charts.dart';
import 'package:fitness/ui/features/progress/view_models/progress_view_model.dart';

/// Progress dashboard: range filter, trend summary, drawn line charts per
/// metric and an achievements shelf.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProgressViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Progresso')),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth =
                constraints.maxWidth >= 640 ? 600.0 : double.infinity;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  children: [
                    _RangeChips(vm: vm),
                    const SizedBox(height: 16),
                    _TrendSummary(vm: vm),
                    const SizedBox(height: 16),
                    _ChartCard(series: vm.weight, accent: 'primary'),
                    const SizedBox(height: 14),
                    _ChartCard(series: vm.calories, accent: 'tertiary'),
                    const SizedBox(height: 14),
                    _ChartCard(series: vm.distance, accent: 'secondary'),
                    const SizedBox(height: 22),
                    SectionHeader(
                      title: 'Conquistas',
                      action: '${vm.unlockedMedals} de ${vm.achievements.length}',
                    ),
                    const SizedBox(height: 8),
                    _Achievements(items: vm.achievements),
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

class _RangeChips extends StatelessWidget {
  const _RangeChips({required this.vm});

  final ProgressViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: List<Widget>.generate(vm.ranges.length, (i) {
        return ChoiceChip(
          label: Text(vm.ranges[i]),
          selected: vm.selectedRange == i,
          onSelected: (_) => vm.selectRange(i),
        );
      }),
    );
  }
}

class _TrendSummary extends StatelessWidget {
  const _TrendSummary({required this.vm});

  final ProgressViewModel vm;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _TrendCard(series: vm.weight, accent: 'primary')),
          Expanded(child: _TrendCard(series: vm.calories, accent: 'tertiary')),
          Expanded(child: _TrendCard(series: vm.distance, accent: 'secondary')),
        ],
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.series, required this.accent});

  final MetricSeries series;
  final String accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tint = accentColor(accent, scheme);
    final up = series.delta >= 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              series.label,
              style: textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _fmt(series.current),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  up ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  size: 15,
                  color: tint,
                ),
                const SizedBox(width: 3),
                Text(
                  '${up ? '+' : ''}${_fmt(series.delta)}',
                  style: textTheme.labelSmall?.copyWith(
                    color: tint,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
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

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.series, required this.accent});

  final MetricSeries series;
  final String accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tint = accentColor(accent, scheme);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  series.label,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_fmt(series.current)} ${series.unit}',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: tint,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LineChart(values: series.values, color: tint),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final p in series.points)
                  Expanded(
                    child: Text(
                      p,
                      textAlign: TextAlign.center,
                      style: textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
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

class _Achievements extends StatelessWidget {
  const _Achievements({required this.items});

  final List<Achievement> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 148,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: items.length,
        itemBuilder: (context, i) => _MedalBadge(item: items[i]),
        separatorBuilder: (_, _) => const SizedBox(width: 12),
      ),
    );
  }
}

class _MedalBadge extends StatelessWidget {
  const _MedalBadge({required this.item});

  final Achievement item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final unlocked = item.unlocked;
    return SizedBox(
      width: 110,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: unlocked
                      ? scheme.primary
                      : scheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  unlocked
                      ? achievementIcon(item.icon)
                      : Icons.lock_outline_rounded,
                  color: unlocked ? scheme.onPrimary : scheme.onSurfaceVariant,
                  size: 26,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                unlocked ? 'Conquistado' : '${(item.progress * 100).round()}%',
                style: textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
