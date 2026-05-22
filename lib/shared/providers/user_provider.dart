import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/preferences_service.dart';

<<<<<<< HEAD
=======
/// Gestiona el estado del usuario en toda la app.
/// Cualquier pantalla puede leer o actualizar el perfil desde aquí.
>>>>>>> 5ee850ee38f487473e9db5bcbe8b5157d187fb34
class UserProvider extends ChangeNotifier {
  final PreferencesService _prefs = PreferencesService();

  UserModel? _user;
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

<<<<<<< HEAD
  String get displayName => _user?.name ?? 'Usuario';
  String get condition => _user?.condition ?? 'both';

=======
  // Nombre con fallback
  String get displayName => _user?.name ?? 'Usuario';

  // Condición con fallback
  String get condition => _user?.condition ?? 'both';

  /// Carga el perfil desde almacenamiento local al iniciar la app
>>>>>>> 5ee850ee38f487473e9db5bcbe8b5157d187fb34
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

<<<<<<< HEAD
=======
  /// Actualiza el perfil del usuario
>>>>>>> 5ee850ee38f487473e9db5bcbe8b5157d187fb34
  Future<void> updateUser(UserModel updated) async {
    await _prefs.saveUserProfile(
      name: updated.name,
      age: updated.age,
      condition: updated.condition,
    );
    _user = updated;
    notifyListeners();
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 5ee850ee38f487473e9db5bcbe8b5157d187fb34
