import 'package:flutter/foundation.dart';

import 'package:fitness/data/repositories/nutrition_repository.dart';
import 'package:fitness/domain/models/nutrition_day.dart';

/// Presentation state for the Nutrition screen (MVVM).
class NutritionViewModel extends ChangeNotifier {
  NutritionViewModel({required NutritionRepository repository})
      : _repository = repository {
    _day = _repository.seed();
    _water = _day.waterGlasses;
  }

  final NutritionRepository _repository;

  late NutritionDay _day;
  NutritionDay get day => _day;

  final String dateLabel = 'Hoje, 30 jun';

  late int _water;
  int get water => _water;
  int get waterGoal => _day.waterGoal;

  void addWater() {
    if (_water < _day.waterGoal) {
      _water++;
      notifyListeners();
    }
  }

  void removeWater() {
    if (_water > 0) {
      _water--;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _day = await _repository.fetch();
    _water = _day.waterGlasses;
    notifyListeners();
  }
}
