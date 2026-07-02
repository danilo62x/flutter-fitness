import 'package:flutter/foundation.dart';

import 'package:fitness/data/repositories/ranking_repository.dart';
import 'package:fitness/domain/models/ranked_user.dart';

/// Presentation state for the Ranking screen (MVVM).
class RankingViewModel extends ChangeNotifier {
  RankingViewModel({required RankingRepository repository})
      : _repository = repository {
    _users = _repository.seed();
  }

  final RankingRepository _repository;

  late List<RankedUser> _users;
  List<RankedUser> get users => List.unmodifiable(_users);

  final List<String> periods = const <String>['Semana', 'Mês', 'Geral'];
  int _selectedPeriod = 0;
  int get selectedPeriod => _selectedPeriod;

  void selectPeriod(int index) {
    _selectedPeriod = index;
    notifyListeners();
  }

  List<RankedUser> get podium => _users.take(3).toList();
  List<RankedUser> get rest => _users.skip(3).toList();
  RankedUser get me =>
      _users.firstWhere((u) => u.isMe, orElse: () => _users.first);

  Future<void> refresh() async {
    _users = await _repository.fetch();
    notifyListeners();
  }
}
