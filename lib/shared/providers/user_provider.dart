import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/preferences_service.dart';

class UserProvider extends ChangeNotifier {
  final PreferencesService _prefs = PreferencesService();

  UserModel? _user;
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  String get displayName => _user?.name ?? 'Usuario';
  String get condition => _user?.condition ?? 'both';
  double? get height => _user?.height;
  double? get weight => _user?.weight;
  String? get gender => _user?.gender;
  String? get birthDate => _user?.birthDate;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    final map = await _prefs.getUserProfile();
    if (map != null) {
      _user = UserModel.fromMap(map);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(UserModel updated) async {
    await _prefs.saveUserProfile(
      name: updated.name,
      age: updated.age,
      condition: updated.condition,
      height: updated.height,
      weight: updated.weight,
      gender: updated.gender,
      birthDate: updated.birthDate,
    );
    _user = updated;
    notifyListeners();
  }
}
