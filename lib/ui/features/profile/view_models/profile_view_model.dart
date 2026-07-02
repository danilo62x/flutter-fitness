import 'package:flutter/foundation.dart';

import 'package:fitness/data/repositories/profile_repository.dart';
import 'package:fitness/domain/models/user_profile.dart';

/// Presentation state for the Profile screen (MVVM).
class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({required ProfileRepository repository})
      : _repository = repository {
    _profile = _repository.seed();
  }

  final ProfileRepository _repository;

  late UserProfile _profile;
  UserProfile get profile => _profile;

  Future<void> refresh() async {
    _profile = await _repository.fetch();
    notifyListeners();
  }
}
