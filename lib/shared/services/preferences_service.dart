import 'package:shared_preferences/shared_preferences.dart';

/// Servicio centralizado para acceso a preferencias locales.
/// Toda la app pasa por aquí — evita usar SharedPreferences directamente
/// en otros archivos.
class PreferencesService {
  static const _keyOnboardingCompleted = 'onboarding_completed';
  static const _keyUserName = 'user_name';
  static const _keyUserAge = 'user_age';
  static const _keyUserCondition = 'user_condition';

  // --- Onboarding ---
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
  }

  // --- Perfil de usuario ---
  Future<void> saveUserProfile({
    required String name,
    required int age,
    required String condition,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
    await prefs.setInt(_keyUserAge, age);
    await prefs.setString(_keyUserCondition, condition);
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyUserName);
    if (name == null) return null;
    return {
      'name': name,
      'age': prefs.getInt(_keyUserAge) ?? 0,
      'condition': prefs.getString(_keyUserCondition) ?? 'both',
    };
  }

  // Útil para desarrollo: resetear todo
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}