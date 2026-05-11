import 'package:flutter/material.dart';
import '../../shared/widgets/section_card.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Hábitos')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          SectionCard(
            title: 'Registro de hábitos',
            icon: Icons.check_circle,
            content: const Text('Próximamente podrás registrar tus hábitos diarios aquí.'),
          ),
        ],
      ),
    );
  }
}