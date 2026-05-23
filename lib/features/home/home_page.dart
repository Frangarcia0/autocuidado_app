import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/user_provider.dart';
import '../../shared/providers/habits_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos d�as';
    if (hour < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const days = [
      'Lunes',
      'Martes',
      'Mi�rcoles',
      'Jueves',
      'Viernes',
      'S�bado',
      'Domingo',
    ];
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${days[now.weekday - 1]} ${now.day} de ${months[now.month - 1]}';
  }

  String _getTip(String condition) {
    if (condition == 'diabetes') {
      return 'Recuerda mantener horarios regulares de comida. '
          'Pequeñas porciones distribuidas en el día ayudan '
          'a mantener niveles de glucosa estables.';
    }
    if (condition == 'hypertension') {
      return 'Reducir el sodio en tus comidas es uno de los '
          'cambios más efectivos para tu presión arterial. '
          'Prueba condimentar con limón o hierbas aromáticas.';
    }
    if (condition == 'insulin_resistance') {
      return 'El ejercicio y el sueño son tus mejores aliados. '
          'Cada caminata post-comida y cada noche de buen descanso '
          'mejoran directamente la respuesta de tu cuerpo a la insulina.';
    }
    return 'Mantener hábitos saludables constantes es más '
        'importante que cambios drásticos. '
        'Cada pequeño paso cuenta.';
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final habits = context.watch<HabitsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/branding/eira_isotype.png', height: 36),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _GreetingCard(
            greeting: _getGreeting(),
            name: user.displayName,
            date: _getFormattedDate(),
          ),
          const SizedBox(height: 12),
          _ProgressCard(
            completed: habits.completedToday,
            total: habits.total,
            progress: habits.todayProgress,
          ),
          const SizedBox(height: 12),
          _TipCard(tip: _getTip(user.condition)),
          const SizedBox(height: 12),
          const _DisclaimerCard(),
        ],
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final String greeting;
  final String name;
  final String date;

  const _GreetingCard({
    required this.greeting,
    required this.name,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting, $name ??',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(date, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final int completed;
  final int total;
  final double progress;

  const _ProgressCard({
    required this.completed,
    required this.total,
    required this.progress,
  });

  String _getProgressMessage(int completed, int total) {
    if (total == 0) return 'Configura tus h�bitos para comenzar';
    if (completed == 0) return '�Empieza tu d�a marcando un h�bito!';
    if (completed == total) return '�Completaste todos tus h�bitos hoy! ??';
    return 'Vas muy bien, �sigue as�!';
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'H�bitos de hoy',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '$completed / $total',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getProgressMessage(completed, total),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String tip;
  const _TipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Consejo del d�a',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(tip, style: const TextStyle(fontSize: 15, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Esta app apoya tu autocuidado. No reemplaza '
                'la atenci�n m�dica profesional.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.orange.shade900,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
