import 'package:flutter/foundation.dart';

import 'package:fitness/data/repositories/workout_repository.dart';
import 'package:fitness/domain/models/workout.dart';

/// Presentation state for the workout detail screen (MVVM).
///
/// Seeds synchronously from the repository so the first frame shows content.
class WorkoutDetailViewModel extends ChangeNotifier {
  WorkoutDetailViewModel({
    required WorkoutRepository repository,
    String? workoutId,
  }) : _repository = repository {
    _workout = _repository.seedById(workoutId);
  }

  final WorkoutRepository _repository;

  late Workout _workout;
  Workout get workout => _workout;

  bool _favorite = false;
  bool get favorite => _favorite;

  void toggleFavorite() {
    _favorite = !_favorite;
    notifyListeners();
  }

  /// Real async reload through the repository/service.
  Future<void> refresh() async {
    final all = await _repository.fetch();
    _workout = all.firstWhere(
      (w) => w.id == _workout.id,
      orElse: () => _workout,
    );
    notifyListeners();
  }
}
