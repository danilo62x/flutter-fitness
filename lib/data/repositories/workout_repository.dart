import 'package:fitness/data/services/workout_api_service.dart';
import 'package:fitness/domain/models/exercise.dart';
import 'package:fitness/domain/models/workout.dart';

/// Single source of truth for workout data.
///
/// [seed] returns instant demo data (synchronous) so the first frame already
/// shows content. [fetch] models the real async path through the HTTP service.
class WorkoutRepository {
  WorkoutRepository({required WorkoutApiService api}) : _api = api;

  final WorkoutApiService _api;

  /// Underlying HTTP service, exposed for real backend wiring.
  WorkoutApiService get api => _api;

  /// Synchronous demo data — keeps the initial render non-empty.
  List<Workout> seed() => const <Workout>[
        Workout(
          id: 'w1',
          name: 'Full Body Power',
          durationMin: 45,
          level: 'Intermediário',
          category: 'fullBody',
          focus: 'Corpo inteiro',
          calories: 420,
          description:
              'Circuito completo que trabalha os principais grupos musculares '
              'com foco em força e resistência. Ideal para dias de treino único.',
          exercises: <Exercise>[
            Exercise(
              id: 'e1',
              name: 'Agachamento livre',
              muscle: 'legs',
              sets: 4,
              reps: '12',
              restSec: 60,
              note: 'Desça até a paralela',
            ),
            Exercise(
              id: 'e2',
              name: 'Supino com halteres',
              muscle: 'chest',
              sets: 4,
              reps: '10',
              restSec: 75,
            ),
            Exercise(
              id: 'e3',
              name: 'Remada curvada',
              muscle: 'back',
              sets: 3,
              reps: '12',
              restSec: 60,
            ),
            Exercise(
              id: 'e4',
              name: 'Desenvolvimento militar',
              muscle: 'shoulders',
              sets: 3,
              reps: '10',
              restSec: 60,
            ),
            Exercise(
              id: 'e5',
              name: 'Prancha isométrica',
              muscle: 'core',
              sets: 3,
              reps: '45s',
              restSec: 45,
            ),
            Exercise(
              id: 'e6',
              name: 'Afundo alternado',
              muscle: 'legs',
              sets: 3,
              reps: '14',
              restSec: 60,
            ),
          ],
        ),
        Workout(
          id: 'w2',
          name: 'HIIT Cardio',
          durationMin: 30,
          level: 'Avançado',
          category: 'cardio',
          focus: 'Condicionamento',
          calories: 380,
          description:
              'Intervalos de alta intensidade para acelerar o metabolismo e '
              'queimar gordura em pouco tempo.',
          exercises: <Exercise>[
            Exercise(
              id: 'e7',
              name: 'Burpees',
              muscle: 'cardio',
              sets: 4,
              reps: '20',
              restSec: 30,
            ),
            Exercise(
              id: 'e8',
              name: 'Mountain climbers',
              muscle: 'core',
              sets: 4,
              reps: '30s',
              restSec: 30,
            ),
            Exercise(
              id: 'e9',
              name: 'Polichinelos',
              muscle: 'cardio',
              sets: 4,
              reps: '40',
              restSec: 30,
            ),
            Exercise(
              id: 'e10',
              name: 'Agachamento com salto',
              muscle: 'legs',
              sets: 4,
              reps: '15',
              restSec: 45,
            ),
          ],
        ),
        Workout(
          id: 'w3',
          name: 'Mobilidade & Alongamento',
          durationMin: 20,
          level: 'Iniciante',
          category: 'mobility',
          focus: 'Flexibilidade',
          calories: 140,
          description:
              'Sequência suave para melhorar amplitude de movimento e acelerar '
              'a recuperação muscular.',
          exercises: <Exercise>[
            Exercise(
              id: 'e11',
              name: 'Gato e camelo',
              muscle: 'core',
              sets: 2,
              reps: '10',
              restSec: 20,
            ),
            Exercise(
              id: 'e12',
              name: 'Alongamento de isquiotibiais',
              muscle: 'legs',
              sets: 2,
              reps: '30s',
              restSec: 20,
            ),
            Exercise(
              id: 'e13',
              name: 'Rotação de ombros',
              muscle: 'shoulders',
              sets: 2,
              reps: '12',
              restSec: 20,
            ),
          ],
        ),
      ];

  /// Returns a single workout by [id], falling back to the first seed item.
  Workout seedById(String? id) {
    final all = seed();
    return all.firstWhere(
      (w) => w.id == id,
      orElse: () => all.first,
    );
  }

  /// Real async path. Falls back to [seed] so the template runs with no backend.
  Future<List<Workout>> fetch() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return seed();

    // Real backend:
    // final models = await _api.fetchWorkouts();
    // return models.map((m) => m.toDomain()).toList();
  }
}
