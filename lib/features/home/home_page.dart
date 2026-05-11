import 'package:flutter/material.dart';
import '../../shared/widgets/section_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Autocuidado')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          SectionCard(
            title: 'Bienvenido',
            icon: Icons.favorite,
            iconColor: Colors.red,
            content: const Text(
              'Esta app te acompaña en tu autocuidado diario. '
              'Recuerda: no reemplaza la atención médica.',
            ),
          ),
          SectionCard(
            title: 'Consejo del día',
            icon: Icons.lightbulb,
            content: const Text(
              'Tomar agua regularmente ayuda a mantener una presión '
              'arterial más estable y mejora tu bienestar general.',
            ),
          ),
        ],
      ),
    );
  }
}