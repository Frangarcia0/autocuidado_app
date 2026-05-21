import 'package:flutter/material.dart';

/// Representa un hábito individual
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
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      _habits[index].completedToday = !_habits[index].completedToday;
      notifyListeners();
    }
  }

  /// Hábitos predefinidos según condición — contenido culturalmente adaptado
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
    ];

    if (condition == 'both') return all;
    return all.where((h) => h.condition == condition).toList();
  }
}