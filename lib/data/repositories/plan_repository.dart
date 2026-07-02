import 'package:fitness/data/services/training_plan_api_service.dart';
import 'package:fitness/domain/models/training_plan.dart';

/// Single source of truth for training plans.
class PlanRepository {
  PlanRepository({required TrainingPlanApiService api}) : _api = api;

  final TrainingPlanApiService _api;

  /// Underlying HTTP service, exposed for real backend wiring.
  TrainingPlanApiService get api => _api;

  /// Synchronous demo data — keeps the initial render non-empty.
  List<TrainingPlan> seed() => const <TrainingPlan>[
        TrainingPlan(
          id: 'p1',
          name: 'Começo Forte',
          level: 'Iniciante',
          weeks: 4,
          sessionsPerWeek: 3,
          focus: 'Adaptação',
          accent: 'mobility',
          progress: 0.25,
          description:
              'Fundamentos de força e mobilidade para criar consistência sem '
              'sobrecarregar as articulações.',
          tags: <String>['Corpo inteiro', 'Baixo impacto'],
        ),
        TrainingPlan(
          id: 'p2',
          name: 'Hipertrofia 5x',
          level: 'Intermediário',
          weeks: 8,
          sessionsPerWeek: 5,
          focus: 'Ganho de massa',
          accent: 'fullBody',
          progress: 0.6,
          description:
              'Divisão por grupos musculares com volume progressivo para '
              'maximizar hipertrofia.',
          tags: <String>['Push/Pull', 'Pernas', 'Core'],
        ),
        TrainingPlan(
          id: 'p3',
          name: 'Queima Total',
          level: 'Avançado',
          weeks: 6,
          sessionsPerWeek: 4,
          focus: 'Definição',
          accent: 'cardio',
          progress: 0.4,
          description:
              'Combinação de HIIT e força metabólica para reduzir percentual '
              'de gordura mantendo massa magra.',
          tags: <String>['HIIT', 'Metabólico'],
        ),
        TrainingPlan(
          id: 'p4',
          name: 'Corrida & Resistência',
          level: 'Intermediário',
          weeks: 10,
          sessionsPerWeek: 4,
          focus: 'Cardio',
          accent: 'cardio',
          progress: 0.15,
          description:
              'Progressão de corrida com trabalho de base aeróbica e tiros '
              'para melhorar seu VO2.',
          tags: <String>['Corrida', 'Zona 2'],
        ),
      ];

  /// Returns a single plan by [id], falling back to the first seed item.
  TrainingPlan seedById(String? id) {
    final all = seed();
    return all.firstWhere((p) => p.id == id, orElse: () => all.first);
  }

  /// Real async path. Falls back to [seed] so the template runs with no backend.
  Future<List<TrainingPlan>> fetch() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return seed();

    // Real backend:
    // final models = await _api.fetchPlans();
    // return models.map((m) => m.toDomain()).toList();
  }
}
