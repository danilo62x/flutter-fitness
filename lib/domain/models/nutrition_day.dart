import 'package:fitness/domain/models/macro.dart';
import 'package:fitness/domain/models/meal.dart';

/// The full nutrition summary for a single day.
class NutritionDay {
  const NutritionDay({
    required this.caloriesConsumed,
    required this.caloriesGoal,
    required this.caloriesBurned,
    required this.macros,
    required this.meals,
    required this.waterGlasses,
    required this.waterGoal,
  });

  final int caloriesConsumed;
  final int caloriesGoal;
  final int caloriesBurned;
  final List<Macro> macros;
  final List<Meal> meals;
  final int waterGlasses;
  final int waterGoal;

  int get caloriesRemaining => caloriesGoal - caloriesConsumed;

  double get calorieProgress =>
      caloriesGoal == 0 ? 0 : (caloriesConsumed / caloriesGoal).clamp(0.0, 1.0);

  double get waterProgress =>
      waterGoal == 0 ? 0 : (waterGlasses / waterGoal).clamp(0.0, 1.0);
}
