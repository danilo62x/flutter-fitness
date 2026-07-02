import 'package:fitness/domain/models/achievement.dart';
import 'package:fitness/domain/models/metric_series.dart';

/// Provides progress metrics and achievements for the Progress screen.
class ProgressRepository {
  /// Time series for the tracked metrics (weight, calories, distance).
  List<MetricSeries> seedSeries() => const <MetricSeries>[
        MetricSeries(
          id: 'weight',
          label: 'Peso',
          unit: 'kg',
          values: <double>[74.2, 73.6, 73.1, 72.8, 72.0, 71.5, 71.1, 70.6],
          points: <String>['S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8'],
          current: 70.6,
          delta: -3.6,
          accent: 'primary',
        ),
        MetricSeries(
          id: 'calories',
          label: 'Calorias',
          unit: 'kcal',
          values: <double>[320, 410, 380, 520, 460, 600, 540, 620],
          points: <String>['S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8'],
          current: 620,
          delta: 300,
          accent: 'tertiary',
        ),
        MetricSeries(
          id: 'distance',
          label: 'Distância',
          unit: 'km',
          values: <double>[3.1, 4.0, 3.6, 5.2, 4.8, 6.1, 5.5, 6.8],
          points: <String>['S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8'],
          current: 6.8,
          delta: 3.7,
          accent: 'secondary',
        ),
      ];

  /// Medals earned and in-progress.
  List<Achievement> seedAchievements() => const <Achievement>[
        Achievement(
          id: 'a1',
          title: '7 dias seguidos',
          description: 'Semana perfeita de treinos',
          icon: 'streak',
          unlocked: true,
        ),
        Achievement(
          id: 'a2',
          title: 'Madrugador',
          description: '10 treinos antes das 7h',
          icon: 'morning',
          unlocked: true,
        ),
        Achievement(
          id: 'a3',
          title: '100 km',
          description: 'Distância acumulada',
          icon: 'distance',
          unlocked: true,
        ),
        Achievement(
          id: 'a4',
          title: 'Maratonista',
          description: '42 km em um mês',
          icon: 'trophy',
          unlocked: false,
          progress: 0.65,
        ),
        Achievement(
          id: 'a5',
          title: 'Força total',
          description: '50 treinos de força',
          icon: 'strength',
          unlocked: false,
          progress: 0.4,
        ),
      ];

  Future<List<MetricSeries>> fetchSeries() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return seedSeries();
  }
}
