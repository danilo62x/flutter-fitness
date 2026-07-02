import 'package:fitness/domain/models/ranked_user.dart';

/// Provides the friends leaderboard for the Ranking screen.
class RankingRepository {
  /// Synchronous demo data — keeps the initial render non-empty.
  List<RankedUser> seed() => const <RankedUser>[
        RankedUser(
          id: 'u1',
          name: 'Marina Alves',
          points: 4820,
          position: 1,
          trend: 0,
          level: 'Elite',
        ),
        RankedUser(
          id: 'u2',
          name: 'Diego Ramos',
          points: 4510,
          position: 2,
          trend: 1,
          level: 'Elite',
        ),
        RankedUser(
          id: 'u3',
          name: 'Ana Souza',
          points: 4290,
          position: 3,
          trend: 2,
          level: 'Ouro',
          isMe: true,
        ),
        RankedUser(
          id: 'u4',
          name: 'Carlos Nunes',
          points: 3980,
          position: 4,
          trend: -1,
          level: 'Ouro',
        ),
        RankedUser(
          id: 'u5',
          name: 'Beatriz Lima',
          points: 3610,
          position: 5,
          trend: 1,
          level: 'Prata',
        ),
        RankedUser(
          id: 'u6',
          name: 'Rafael Costa',
          points: 3350,
          position: 6,
          trend: -2,
          level: 'Prata',
        ),
        RankedUser(
          id: 'u7',
          name: 'Juliana Reis',
          points: 3120,
          position: 7,
          trend: 0,
          level: 'Prata',
        ),
        RankedUser(
          id: 'u8',
          name: 'Felipe Rocha',
          points: 2870,
          position: 8,
          trend: 3,
          level: 'Bronze',
        ),
      ];

  Future<List<RankedUser>> fetch() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return seed();
  }
}
