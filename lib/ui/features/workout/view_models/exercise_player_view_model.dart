import 'package:flutter/foundation.dart';

import 'package:fitness/data/repositories/workout_repository.dart';
import 'package:fitness/domain/models/exercise.dart';
import 'package:fitness/domain/models/workout.dart';

/// Presentation state for the exercise player screen (MVVM).
///
/// The timer values are static seed data so the screenshot renders a realistic
/// "mid-set" moment without needing a running [Ticker].
class ExercisePlayerViewModel extends ChangeNotifier {
  ExercisePlayerViewModel({
    required WorkoutRepository repository,
    String? workoutId,
  }) : _repository = repository {
    _workout = _repository.seedById(workoutId);
  }

  final WorkoutRepository _repository;

  late Workout _workout;
  Workout get workout => _workout;

  /// Index of the current exercise (starts mid-workout for a rich screenshot).
  int _index = 1;
  int get index => _index;
  int get total => _workout.exercises.length;

  /// 1-based current set number.
  int _currentSet = 2;
  int get currentSet => _currentSet;

  Exercise get current => _workout.exercises[_index];
  Exercise? get upcoming =>
      _index + 1 < total ? _workout.exercises[_index + 1] : null;

  bool _paused = false;
  bool get paused => _paused;

  // Static timer snapshot (seconds).
  final int elapsedSec = 27;
  final int totalSec = 45;
  double get timerProgress => totalSec == 0 ? 0 : elapsedSec / totalSec;

  String get remainingLabel {
    final remaining = (totalSec - elapsedSec).clamp(0, totalSec);
    final m = (remaining ~/ 60).toString().padLeft(2, '0');
    final s = (remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void togglePause() {
    _paused = !_paused;
    notifyListeners();
  }

  void nextExercise() {
    if (_index + 1 < total) {
      _index++;
      _currentSet = 1;
      notifyListeners();
    }
  }

  void previousExercise() {
    if (_index > 0) {
      _index--;
      _currentSet = 1;
      notifyListeners();
    }
  }
}
