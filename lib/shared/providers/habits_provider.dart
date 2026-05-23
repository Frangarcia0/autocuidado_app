import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class Habit {
  final String id;
  final String title;
  final String category;
  final String condition;
  bool completedToday;

  Habit({
    required this.id,
    required this.title,
    required this.category,
    required this.condition,
    this.completedToday = false,
  });
}

class HabitsProvider extends ChangeNotifier {
  final PreferencesService _prefs = PreferencesService();
  List<Habit> _habits = [];

  int _streakCurrent = 0;
  int _streakBest = 0;

  List<Habit> get habits => _habits;
  int get streakCurrent => _streakCurrent;
  int get streakBest => _streakBest;
  int get completedToday => _habits.where((h) => h.completedToday).length;
  int get total => _habits.length;
  double get todayProgress => _habits.isEmpty ? 0.0 : completedToday / total;

  Future<void> loadHabitsForCondition(String condition) async {
    _habits = _getDefaultHabits(condition);

    await _prefs.checkStreakBreak();

    final completedIds = await _prefs.loadCompletedHabits();
    for (final habit in _habits) {
      habit.completedToday = completedIds.contains(habit.id);
    }

    final streak = await _prefs.loadStreak();
    _streakCurrent = streak['current'] ?? 0;
    _streakBest = streak['best'] ?? 0;

    notifyListeners();
  }

  Future<void> toggleHabit(String id) async {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      _habits[index].completedToday = !_habits[index].completedToday;
      notifyListeners();

      final completedIds = _habits
          .where((h) => h.completedToday)
          .map((h) => h.id)
          .toList();

      await _prefs.saveCompletedHabits(completedIds);

      if (completedIds.isNotEmpty) {
        final streak = await _prefs.updateStreak();
        _streakCurrent = streak['current'] ?? 0;
        _streakBest = streak['best'] ?? 0;
        notifyListeners();
      }
    }
  }

  List<Habit> _getDefaultHabits(String condition) {
    final all = [
      // Hábitos para diabetes
      Habit(
        id: 'h1',
        title: 'Tomar agua (8 vasos)',
        category: 'hidratacion',
        condition: 'diabetes',
      ),
      Habit(
        id: 'h2',
        title: 'Caminar 30 minutos',
        category: 'ejercicio',
        condition: 'diabetes',
      ),
      Habit(
        id: 'h3',
        title: 'Evitar azúcar añadida hoy',
        category: 'alimentacion',
        condition: 'diabetes',
      ),
      Habit(
        id: 'h4',
        title: 'Comer a horarios regulares',
        category: 'alimentacion',
        condition: 'diabetes',
      ),
      // Hábitos para hipertensión
      Habit(
        id: 'h5',
        title: 'Reducir sal en comidas',
        category: 'alimentacion',
        condition: 'hypertension',
      ),
      Habit(
        id: 'h6',
        title: 'Ejercicio suave 20 minutos',
        category: 'ejercicio',
        condition: 'hypertension',
      ),
      Habit(
        id: 'h7',
        title: 'Momento de relajación',
        category: 'bienestar',
        condition: 'hypertension',
      ),
      Habit(
        id: 'h8',
        title: 'Tomar agua (8 vasos)',
        category: 'hidratacion',
        condition: 'hypertension',
      ),
      // Hábitos para resistencia a la insulina
      Habit(
        id: 'h9',
        title: 'Caminar 30 minutos',
        category: 'ejercicio',
        condition: 'insulin_resistance',
      ),
      Habit(
        id: 'h10',
        title: 'Evitar azúcar y harinas refinadas',
        category: 'alimentacion',
        condition: 'insulin_resistance',
      ),
      Habit(
        id: 'h11',
        title: 'Tomar agua (8 vasos)',
        category: 'hidratacion',
        condition: 'insulin_resistance',
      ),
      Habit(
        id: 'h12',
        title: 'Dormir 7-8 horas esta noche',
        category: 'bienestar',
        condition: 'insulin_resistance',
      ),
    ];

    if (condition == 'both') return all.where((h) => h.condition == 'diabetes' || h.condition == 'hypertension').toList();
    return all.where((h) => h.condition == condition).toList();
  }
}
