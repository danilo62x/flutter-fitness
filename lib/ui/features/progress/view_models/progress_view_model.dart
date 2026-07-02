import 'package:flutter/foundation.dart';

import 'package:fitness/data/repositories/progress_repository.dart';
import 'package:fitness/domain/models/achievement.dart';
import 'package:fitness/domain/models/metric_series.dart';

/// Presentation state for the Progress screen (MVVM).
class ProgressViewModel extends ChangeNotifier {
  ProgressViewModel({required ProgressRepository repository})
      : _repository = repository {
    _series = _repository.seedSeries();
    _achievements = _repository.seedAchievements();
  }

  final ProgressRepository _repository;

  late List<MetricSeries> _series;
  late List<Achievement> _achievements;

  List<MetricSeries> get series => List.unmodifiable(_series);
  List<Achievement> get achievements => List.unmodifiable(_achievements);

  final List<String> ranges = const <String>['Semana', 'Mês', 'Ano'];
  int _selectedRange = 1;
  int get selectedRange => _selectedRange;

  void selectRange(int index) {
    _selectedRange = index;
    notifyListeners();
  }

  MetricSeries _byId(String id) => _series.firstWhere((s) => s.id == id);
  MetricSeries get weight => _byId('weight');
  MetricSeries get calories => _byId('calories');
  MetricSeries get distance => _byId('distance');

  int get unlockedMedals =>
      _achievements.where((a) => a.unlocked).length;

  Future<void> refresh() async {
    _series = await _repository.fetchSeries();
    notifyListeners();
  }
}
