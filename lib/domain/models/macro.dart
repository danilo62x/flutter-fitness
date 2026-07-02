/// A macronutrient bar (protein / carbs / fat) on the Nutrition screen.
class Macro {
  const Macro({
    required this.name,
    required this.grams,
    required this.goalGrams,
    required this.accent,
  });

  final String name;
  final int grams;
  final int goalGrams;

  /// UI-agnostic accent tag mapped to a color by the view.
  final String accent;

  double get progress =>
      goalGrams == 0 ? 0 : (grams / goalGrams).clamp(0.0, 1.0);
}
