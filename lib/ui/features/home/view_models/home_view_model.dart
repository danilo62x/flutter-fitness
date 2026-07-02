import 'package:flutter/foundation.dart';

import 'package:fitness/data/repositories/workout_repository.dart';
import 'package:fitness/domain/models/workout.dart';

/// A single day of activity used by the weekly bar chart.
@immutable
class DayActivity {
  const DayActivity({required this.label, required this.value});

  /// Short weekday label, e.g. `Seg`.
  final String label;

  /// Normalized 0..1 intensity for the bar height.
  final double value;
}

/// Presentation state for the home screen (MVVM).
///
/// Seeds its data synchronously in the constructor so the very first frame
/// already shows content. [refresh] models the real async reload path.
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required WorkoutRepository repository})
      : _repository = repository {
    _workouts = _repository.seed();
  }

  final WorkoutRepository _repository;

  List<Workout> _workouts = const <Workout>[];
  List<Workout> get workouts => List.unmodifiable(_workouts);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // --- Header ---------------------------------------------------------------
  final String greeting = 'Bom treino,';
  final String userName = 'Ana Souza';

  /// Current daily streak, shown as a small badge in the header.
  final int streakDays = 12;

  /// Initials for the avatar (no network image in the template).
  String get initials {
    final parts = userName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  // --- Daily goal -----------------------------------------------------------
  final int caloriesDone = 540;
  final int caloriesGoal = 750;
  double get goalProgress => caloriesDone / caloriesGoal; // 0.72

  // --- Quick stats ----------------------------------------------------------
  final String steps = '8.240';
  final String distance = '6,2 km';
  final String activeTime = '48 min';

  // --- Weekly activity ------------------------------------------------------
  final List<DayActivity> week = const <DayActivity>[
    DayActivity(label: 'Seg', value: 0.45),
    DayActivity(label: 'Ter', value: 0.62),
    DayActivity(label: 'Qua', value: 0.50),
    DayActivity(label: 'Qui', value: 0.80),
    DayActivity(label: 'Sex', value: 0.40),
    DayActivity(label: 'Sáb', value: 0.95),
    DayActivity(label: 'Dom', value: 0.30),
  ];

  /// Index of the highlighted (best) day.
  final int highlightedDay = 5;

  /// Real async reload through the repository/service.
  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    try {
      _workouts = await _repository.fetch();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
