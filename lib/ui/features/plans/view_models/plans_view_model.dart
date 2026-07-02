import 'package:flutter/foundation.dart';

import 'package:fitness/data/repositories/plan_repository.dart';
import 'package:fitness/domain/models/training_plan.dart';

/// Presentation state for the Plans screen (MVVM).
class PlansViewModel extends ChangeNotifier {
  PlansViewModel({required PlanRepository repository})
      : _repository = repository {
    _plans = _repository.seed();
  }

  final PlanRepository _repository;

  late List<TrainingPlan> _plans;

  final List<String> filters = const <String>[
    'Todos',
    'Iniciante',
    'Intermediário',
    'Avançado',
  ];
  int _selectedFilter = 0;
  int get selectedFilter => _selectedFilter;

  void selectFilter(int index) {
    _selectedFilter = index;
    notifyListeners();
  }

  List<TrainingPlan> get plans {
    if (_selectedFilter == 0) return List.unmodifiable(_plans);
    final level = filters[_selectedFilter];
    return _plans.where((p) => p.level == level).toList();
  }

  Future<void> refresh() async {
    _plans = await _repository.fetch();
    notifyListeners();
  }
}
