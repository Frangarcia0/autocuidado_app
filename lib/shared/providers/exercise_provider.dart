import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ExerciseLevel { sedentario, leve, moderado, vigoroso }

extension ExerciseLevelLabel on ExerciseLevel {
  String get label {
    switch (this) {
      case ExerciseLevel.sedentario:
        return 'Sedentario';
      case ExerciseLevel.leve:
        return 'Leve';
      case ExerciseLevel.moderado:
        return 'Moderado';
      case ExerciseLevel.vigoroso:
        return 'Vigoroso';
    }
  }

  String get description {
    switch (this) {
      case ExerciseLevel.sedentario:
        return 'Poca o ninguna actividad física';
      case ExerciseLevel.leve:
        return '1 - 2 días por semana';
      case ExerciseLevel.moderado:
        return '3 - 5 días por semana';
      case ExerciseLevel.vigoroso:
        return '6 - 7 días por semana';
    }
  }

  Color get color {
    switch (this) {
      case ExerciseLevel.sedentario:
        return const Color(0xFF9E9E9E);
      case ExerciseLevel.leve:
        return const Color(0xFF5B8DB8);
      case ExerciseLevel.moderado:
        return const Color(0xFF6B9E6B);
      case ExerciseLevel.vigoroso:
        return const Color(0xFFE07B54);
    }
  }

  int get goalDays {
    switch (this) {
      case ExerciseLevel.sedentario:
        return 1;
      case ExerciseLevel.leve:
        return 2;
      case ExerciseLevel.moderado:
        return 5;
      case ExerciseLevel.vigoroso:
        return 5;
    }
  }

  int get goalMinutes {
    switch (this) {
      case ExerciseLevel.sedentario:
        return 15;
      case ExerciseLevel.leve:
        return 20;
      case ExerciseLevel.moderado:
        return 30;
      case ExerciseLevel.vigoroso:
        return 45;
    }
  }
}

class ExerciseProvider extends ChangeNotifier {
  static const _keyLevel = 'exercise_level';
  static const _keyWeeklyMinutes = 'exercise_weekly_minutes';
  static const _keyWeekStart = 'exercise_week_start';
  static const _keyStreakCount = 'exercise_streak_count';
  static const _keyStreakLastDate = 'exercise_streak_last_date';
  static const _keyTodayMinutes = 'exercise_today_minutes';
  static const _keyTodayDate = 'exercise_today_date';

  ExerciseLevel _level = ExerciseLevel.moderado;
  int _weeklyMinutes = 0;
  int _streakCount = 0;
  int _todayMinutes = 0;

  ExerciseLevel get level => _level;
  int get weeklyMinutes => _weeklyMinutes;
  int get streakCount => _streakCount;
  int get todayMinutes => _todayMinutes;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final levelIndex = prefs.getInt(_keyLevel) ?? ExerciseLevel.moderado.index;
    _level = ExerciseLevel.values[levelIndex];

    await _checkWeekReset(prefs);
    await _checkStreakBreak(prefs);
    await _loadTodayMinutes(prefs);

    _weeklyMinutes = prefs.getInt(_keyWeeklyMinutes) ?? 0;
    _streakCount = prefs.getInt(_keyStreakCount) ?? 0;

    notifyListeners();
  }

  Future<void> setLevel(ExerciseLevel level) async {
    _level = level;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLevel, level.index);
  }

  Future<void> addMinutes(int minutes) async {
    if (minutes <= 0) return;
    final prefs = await SharedPreferences.getInstance();

    _weeklyMinutes += minutes;
    _todayMinutes += minutes;
    await prefs.setInt(_keyWeeklyMinutes, _weeklyMinutes);
    await prefs.setInt(_keyTodayMinutes, _todayMinutes);

    await _updateStreak(prefs);

    notifyListeners();
  }

  // ── Lógica interna ───────────────────────────────────────────────────────

  Future<void> _loadTodayMinutes(SharedPreferences prefs) async {
    final savedDate = prefs.getString(_keyTodayDate);
    final today = _dateKey(DateTime.now());
    if (savedDate == today) {
      _todayMinutes = prefs.getInt(_keyTodayMinutes) ?? 0;
    } else {
      _todayMinutes = 0;
      await prefs.setInt(_keyTodayMinutes, 0);
      await prefs.setString(_keyTodayDate, today);
    }
  }

  Future<void> _checkWeekReset(SharedPreferences prefs) async {
    final now = DateTime.now();
    // Semana empieza el lunes
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekKey = _dateKey(weekStart);
    final savedWeekKey = prefs.getString(_keyWeekStart);
    if (savedWeekKey != weekKey) {
      await prefs.setInt(_keyWeeklyMinutes, 0);
      await prefs.setString(_keyWeekStart, weekKey);
    }
  }

  Future<void> _checkStreakBreak(SharedPreferences prefs) async {
    final lastDateStr = prefs.getString(_keyStreakLastDate);
    if (lastDateStr == null) return;

    final lastDate = DateTime.parse(lastDateStr);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);

    // Busca si hay algún día laboral perdido entre lastDate y hoy
    DateTime cursor = lastDay.add(const Duration(days: 1));
    bool missed = false;
    while (cursor.isBefore(todayDate)) {
      // weekday: 1=lun ... 5=vie, 6=sáb, 7=dom
      if (cursor.weekday <= 5) {
        missed = true;
        break;
      }
      cursor = cursor.add(const Duration(days: 1));
    }

    if (missed) {
      await prefs.setInt(_keyStreakCount, 0);
    }
  }

  Future<void> _updateStreak(SharedPreferences prefs) async {
    final today = DateTime.now();
    // Solo contar días laborables (lun-vie)
    if (today.weekday > 5) return;

    final todayKey = _dateKey(today);
    final lastDateStr = prefs.getString(_keyStreakLastDate);

    if (lastDateStr == todayKey) return; // Ya se contó hoy

    int current = prefs.getInt(_keyStreakCount) ?? 0;
    current++;
    _streakCount = current;

    await prefs.setInt(_keyStreakCount, current);
    await prefs.setString(_keyStreakLastDate, todayKey);
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
