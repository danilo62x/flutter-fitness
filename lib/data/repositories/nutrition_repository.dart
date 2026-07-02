import 'package:fitness/domain/models/macro.dart';
import 'package:fitness/domain/models/meal.dart';
import 'package:fitness/domain/models/nutrition_day.dart';

/// Provides the daily nutrition summary for the Nutrition screen.
class NutritionRepository {
  /// Synchronous demo data — keeps the initial render non-empty.
  NutritionDay seed() => const NutritionDay(
        caloriesConsumed: 1480,
        caloriesGoal: 2100,
        caloriesBurned: 420,
        macros: <Macro>[
          Macro(name: 'Proteína', grams: 96, goalGrams: 140, accent: 'primary'),
          Macro(
            name: 'Carboidrato',
            grams: 168,
            goalGrams: 230,
            accent: 'tertiary',
          ),
          Macro(name: 'Gordura', grams: 44, goalGrams: 70, accent: 'secondary'),
        ],
        meals: <Meal>[
          Meal(
            id: 'm1',
            name: 'Café da manhã',
            time: '07:30',
            kcal: 420,
            category: 'breakfast',
            items: 'Aveia, banana e whey',
          ),
          Meal(
            id: 'm2',
            name: 'Almoço',
            time: '12:15',
            kcal: 620,
            category: 'lunch',
            items: 'Frango, arroz integral e salada',
          ),
          Meal(
            id: 'm3',
            name: 'Lanche',
            time: '16:00',
            kcal: 210,
            category: 'snack',
            items: 'Iogurte e castanhas',
          ),
          Meal(
            id: 'm4',
            name: 'Jantar',
            time: '20:00',
            kcal: 230,
            category: 'dinner',
            items: 'Omelete e legumes',
          ),
        ],
        waterGlasses: 5,
        waterGoal: 8,
      );

  Future<NutritionDay> fetch() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return seed();
  }
}
