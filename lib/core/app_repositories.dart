import 'package:fitness/data/repositories/nutrition_repository.dart';
import 'package:fitness/data/repositories/plan_repository.dart';
import 'package:fitness/data/repositories/profile_repository.dart';
import 'package:fitness/data/repositories/progress_repository.dart';
import 'package:fitness/data/repositories/ranking_repository.dart';
import 'package:fitness/data/repositories/workout_repository.dart';
import 'package:fitness/data/services/training_plan_api_service.dart';
import 'package:fitness/data/services/workout_api_service.dart';

/// Composition root. Builds the repository graph once and shares it with the
/// router and the tab shell. In a larger app register these in a DI container
/// such as `get_it`.
class AppRepositories {
  AppRepositories()
      : workout = WorkoutRepository(api: WorkoutApiService()),
        plan = PlanRepository(api: TrainingPlanApiService()),
        progress = ProgressRepository(),
        nutrition = NutritionRepository(),
        profile = ProfileRepository(),
        ranking = RankingRepository();

  final WorkoutRepository workout;
  final PlanRepository plan;
  final ProgressRepository progress;
  final NutritionRepository nutrition;
  final ProfileRepository profile;
  final RankingRepository ranking;
}

/// Shared instance used across the app.
final AppRepositories appRepositories = AppRepositories();
