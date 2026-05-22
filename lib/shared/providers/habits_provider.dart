import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../services/preferences_service.dart';

=======

/// Representa un hábito individual
>>>>>>> 5ee850ee38f487473e9db5bcbe8b5157d187fb34
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

<<<<<<< HEAD
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

    // Verificar si se rompió la racha
    await _prefs.checkStreakBreak();

    // Cargar hábitos completados
    final completedIds = await _prefs.loadCompletedHabits();
    for (final habit in _habits) {
      habit.completedToday = completedIds.contains(habit.id);
    }

    // Cargar racha guardada
    final streak = await _prefs.loadStreak();
    _streakCurrent = streak['current'] ?? 0;
    _streakBest = streak['best'] ?? 0;

    notifyListeners();
  }

  Future<void> toggleHabit(String id) async {
=======
/// Gestiona el estado de los hábitos en toda la app.
class HabitsProvider extends ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  /// Hábitos completados hoy
  int get completedToday =>
      _habits.where((h) => h.completedToday).length;

  /// Total de hábitos
  int get total => _habits.length;

  /// Porcentaje de completitud hoy (0.0 a 1.0)
  double get todayProgress =>
      _habits.isEmpty ? 0.0 : completedToday / total;

  /// Carga hábitos base según la condición del usuario
  void loadHabitsForCondition(String condition) {
    _habits = _getDefaultHabits(condition);
    notifyListeners();
  }

  /// Marca o desmarca un hábito como completado
  void toggleHabit(String id) {
>>>>>>> 5ee850ee38f487473e9db5bcbe8b5157d187fb34
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      _habits[index].completedToday = !_habits[index].completedToday;
      notifyListeners();
<<<<<<< HEAD

      final completedIds = _habits
          .where((h) => h.completedToday)
          .map((h) => h.id)
          .toList();

      await _prefs.saveCompletedHabits(completedIds);

      // Actualizar racha si hay al menos 1 hábito completado
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
=======
    }
  }

  /// Hábitos predefinidos según condición — contenido culturalmente adaptado
  List<Habit> _getDefaultHabits(String condition) {
    final all = [
      // Hábitos para diabetes
>>>>>>> 5ee850ee38f487473e9db5bcbe8b5157d187fb34
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
<<<<<<< HEAD
=======
      // Hábitos para hipertensión
>>>>>>> 5ee850ee38f487473e9db5bcbe8b5157d187fb34
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
    ];

    if (condition == 'both') return all;
    return all.where((h) => h.condition == condition).toList();
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 5ee850ee38f487473e9db5bcbe8b5157d187fb34
