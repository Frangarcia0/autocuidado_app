import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/habits_provider.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'alimentacion':
        return Icons.restaurant;
      case 'ejercicio':
        return Icons.directions_walk;
      case 'hidratacion':
        return Icons.water_drop;
      case 'bienestar':
        return Icons.self_improvement;
      default:
        return Icons.check_circle_outline;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'alimentacion':
        return Colors.green;
      case 'ejercicio':
        return Colors.blue;
      case 'hidratacion':
        return Colors.lightBlue;
      case 'bienestar':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitsProvider = context.watch<HabitsProvider>();
    final habits = habitsProvider.habits;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Hábitos')),
      body: habits.isEmpty
          ? const Center(child: Text('No hay hábitos configurados.'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            label: 'Completados',
                            value: '${habitsProvider.completedToday}',
                            color: Colors.green,
                          ),
                          _StatItem(
                            label: 'Pendientes',
                            value: '${habitsProvider.total - habitsProvider.completedToday}',
                            color: Colors.orange,
                          ),
                          _StatItem(
                            label: 'Total',
                            value: '${habitsProvider.total}',
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      final habit = habits[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: habit.completedToday
                                ? Colors.green.shade100
                                : _getCategoryColor(habit.category).withOpacity(0.15),
                            child: Icon(
                              habit.completedToday
                                  ? Icons.check
                                  : _getCategoryIcon(habit.category),
                              color: habit.completedToday
                                  ? Colors.green
                                  : _getCategoryColor(habit.category),
                            ),
                          ),
                          title: Text(
                            habit.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              decoration: habit.completedToday
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: habit.completedToday ? Colors.grey : null,
                            ),
                          ),
                          trailing: Checkbox(
                            value: habit.completedToday,
                            activeColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (_) {
                              context.read<HabitsProvider>().toggleHabit(habit.id);
                            },
                          ),
                          onTap: () {
                            context.read<HabitsProvider>().toggleHabit(habit.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }
}
