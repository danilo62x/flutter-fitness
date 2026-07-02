import 'package:fitness/domain/models/achievement.dart';
import 'package:fitness/domain/models/user_profile.dart';

/// Provides the aggregate user profile for the Profile screen.
class ProfileRepository {
  /// Synchronous demo data — keeps the initial render non-empty.
  UserProfile seed() => const UserProfile(
        name: 'Ana Souza',
        title: 'Nível Ouro • Atleta',
        since: 'Membro desde 2023',
        totalWorkouts: 128,
        streakDays: 12,
        hoursTrained: 96,
        caloriesBurned: 48200,
        goals: <Goal>[
          Goal(
            title: 'Peso alvo',
            current: 70.6,
            target: 68.0,
            unit: 'kg',
            accent: 'primary',
          ),
          Goal(
            title: 'Treinos na semana',
            current: 4,
            target: 5,
            unit: '',
            accent: 'tertiary',
          ),
          Goal(
            title: 'Distância no mês',
            current: 34,
            target: 50,
            unit: 'km',
            accent: 'secondary',
          ),
        ],
        medals: <Achievement>[
          Achievement(
            id: 'a1',
            title: '7 dias',
            description: 'Sequência',
            icon: 'streak',
            unlocked: true,
          ),
          Achievement(
            id: 'a3',
            title: '100 km',
            description: 'Distância',
            icon: 'distance',
            unlocked: true,
          ),
          Achievement(
            id: 'a6',
            title: '100 treinos',
            description: 'Marco',
            icon: 'trophy',
            unlocked: true,
          ),
          Achievement(
            id: 'a5',
            title: 'Força',
            description: '50 treinos',
            icon: 'strength',
            unlocked: false,
            progress: 0.4,
          ),
        ],
        history: <WorkoutHistoryEntry>[
          WorkoutHistoryEntry(
            name: 'Full Body Power',
            dateLabel: 'Hoje • 07:10',
            durationMin: 45,
            kcal: 420,
            category: 'fullBody',
          ),
          WorkoutHistoryEntry(
            name: 'HIIT Cardio',
            dateLabel: 'Ontem • 18:40',
            durationMin: 30,
            kcal: 380,
            category: 'cardio',
          ),
          WorkoutHistoryEntry(
            name: 'Corrida na esteira',
            dateLabel: 'Seg • 06:50',
            durationMin: 35,
            kcal: 340,
            category: 'cardio',
          ),
          WorkoutHistoryEntry(
            name: 'Mobilidade & Alongamento',
            dateLabel: 'Dom • 09:20',
            durationMin: 20,
            kcal: 140,
            category: 'mobility',
          ),
        ],
      );

  Future<UserProfile> fetch() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return seed();
  }
}
