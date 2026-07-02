/// A logged meal on the Nutrition screen.
class Meal {
  const Meal({
    required this.id,
    required this.name,
    required this.time,
    required this.kcal,
    required this.category,
    required this.items,
  });

  final String id;
  final String name;
  final String time;
  final int kcal;

  /// UI-agnostic category tag mapped to an icon by the view.
  final String category;

  /// Short summary of the plate, e.g. `Aveia, banana, whey`.
  final String items;
}
