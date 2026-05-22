import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  // Keys usuario
  static const _keyOnboardingCompleted = 'onboarding_completed';
  static const _keyUserName = 'user_name';
  static const _keyUserAge = 'user_age';
  static const _keyUserCondition = 'user_condition';

  // Keys hábitos
  static const _keyHabitsLastDate = 'habits_last_date';
  static const _keyHabitsCompleted = 'habits_completed';

  // Keys rachas
  static const _keyStreakDays = 'streak_days';
  static const _keyStreakBest = 'streak_best';
  static const _keyStreakLastActive = 'streak_last_active';

  // ── Onboarding ───────────────────────────────────────────────

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
  }

  // ── Perfil ───────────────────────────────────────────────────

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

  // ── Hábitos ──────────────────────────────────────────────────

  Future<void> saveCompletedHabits(List<String> completedIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyHabitsCompleted, completedIds);
    final today = _dateKey(DateTime.now());
    await prefs.setString(_keyHabitsLastDate, today);
  }

  Future<List<String>> loadCompletedHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString(_keyHabitsLastDate);
    final today = _dateKey(DateTime.now());

    if (lastDate != today) {
      await prefs.remove(_keyHabitsCompleted);
      await prefs.setString(_keyHabitsLastDate, today);
      return [];
    }

    return prefs.getStringList(_keyHabitsCompleted) ?? [];
  }

  // ── Rachas ───────────────────────────────────────────────────

  Future<Map<String, int>> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'current': prefs.getInt(_keyStreakDays) ?? 0,
      'best': prefs.getInt(_keyStreakBest) ?? 0,
    };
  }

  /// Actualiza la racha cuando el usuario completa al menos 1 hábito
  Future<Map<String, int>> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _dateKey(DateTime.now());
    final lastActive = prefs.getString(_keyStreakLastActive);

    int current = prefs.getInt(_keyStreakDays) ?? 0;
    int best = prefs.getInt(_keyStreakBest) ?? 0;

    if (lastActive == today) {
      // Ya se registró hoy — no cambiar
      return {'current': current, 'best': best};
    }

    final yesterday = _dateKey(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    if (lastActive == yesterday) {
      // Día consecutivo — incrementar racha
      current++;
    } else {
      // Se saltó un día — resetear racha
      current = 1;
    }

    // Actualizar récord si corresponde
    if (current > best) best = current;

    await prefs.setInt(_keyStreakDays, current);
    await prefs.setInt(_keyStreakBest, best);
    await prefs.setString(_keyStreakLastActive, today);

    return {'current': current, 'best': best};
  }

  /// Resetea la racha si el usuario no completó ningún hábito ayer
  Future<void> checkStreakBreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastActive = prefs.getString(_keyStreakLastActive);
    if (lastActive == null) return;

    final yesterday = _dateKey(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    final twoDaysAgo = _dateKey(
      DateTime.now().subtract(const Duration(days: 2)),
    );

    // Si la última actividad fue hace más de 1 día, rompe la racha
    if (lastActive != yesterday && lastActive != _dateKey(DateTime.now())) {
      if (lastActive.compareTo(twoDaysAgo) <= 0) {
        await prefs.setInt(_keyStreakDays, 0);
      }
    }
  }

  // ── Utilidades ───────────────────────────────────────────────

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
