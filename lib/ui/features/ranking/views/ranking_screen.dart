import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fitness/domain/models/ranked_user.dart';
import 'package:fitness/ui/features/ranking/view_models/ranking_view_model.dart';

/// Friends leaderboard: period filter, a top-three podium and the ranked list
/// with the current user highlighted.
class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RankingViewModel>();
    final podium = vm.podium;

    return Scaffold(
      appBar: AppBar(title: const Text('Ranking')),
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
                    _PeriodChips(vm: vm),
                    const SizedBox(height: 16),
                    if (podium.length >= 3) _Podium(top: podium),
                    const SizedBox(height: 20),
                    for (final user in vm.rest) ...[
                      _RankTile(user: user),
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

class _PeriodChips extends StatelessWidget {
  const _PeriodChips({required this.vm});

  final RankingViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: List<Widget>.generate(vm.periods.length, (i) {
        return ChoiceChip(
          label: Text(vm.periods[i]),
          selected: vm.selectedPeriod == i,
          onSelected: (_) => vm.selectPeriod(i),
        );
      }),
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium({required this.top});

  final List<RankedUser> top;

  static const Color _gold = Color(0xFFFFC24B);
  static const Color _silver = Color(0xFFB8C2CC);
  static const Color _bronze = Color(0xFFCF9A6B);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primaryContainer.withValues(alpha: 0.25),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: _PodiumSpot(
                user: top[1],
                medal: _silver,
                height: 74,
              ),
            ),
            Expanded(
              child: _PodiumSpot(
                user: top[0],
                medal: _gold,
                height: 104,
                crown: true,
              ),
            ),
            Expanded(
              child: _PodiumSpot(
                user: top[2],
                medal: _bronze,
                height: 58,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PodiumSpot extends StatelessWidget {
  const _PodiumSpot({
    required this.user,
    required this.medal,
    required this.height,
    this.crown = false,
  });

  final RankedUser user;
  final Color medal;
  final double height;
  final bool crown;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          crown ? Icons.emoji_events_rounded : Icons.workspace_premium_rounded,
          color: medal,
          size: crown ? 26 : 20,
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: medal, width: 2.5),
          ),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: scheme.primaryContainer,
            child: Text(
              user.initials,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user.name.split(' ').first,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
        Text(
          '${user.points} pts',
          style: textTheme.labelSmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                medal.withValues(alpha: 0.85),
                medal.withValues(alpha: 0.45),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${user.position}',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RankTile extends StatelessWidget {
  const _RankTile({required this.user});

  final RankedUser user;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final me = user.isMe;
    return Card(
      color: me ? scheme.primaryContainer.withValues(alpha: 0.55) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              child: Text(
                '${user.position}',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 20,
              backgroundColor: scheme.secondaryContainer,
              child: Text(
                user.initials,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    me ? '${user.name} (você)' : user.name,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.level,
                    style: textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _TrendBadge(trend: user.trend),
            const SizedBox(width: 12),
            Text(
              '${user.points}',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.trend});

  final int trend;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    late final IconData icon;
    late final Color color;
    if (trend > 0) {
      icon = Icons.arrow_upward_rounded;
      color = scheme.primary;
    } else if (trend < 0) {
      icon = Icons.arrow_downward_rounded;
      color = scheme.error;
    } else {
      icon = Icons.remove_rounded;
      color = scheme.onSurfaceVariant;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        Text(
          '${trend.abs()}',
          style: textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
