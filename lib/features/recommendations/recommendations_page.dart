import 'package:flutter/material.dart';
import '../../shared/widgets/section_card.dart';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recomendaciones')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          SectionCard(
            title: 'Alimentación',
            icon: Icons.restaurant,
            content: const Text('Recomendaciones generales de alimentación saludable según tu condición.'),
          ),
          SectionCard(
            title: 'Actividad física',
            icon: Icons.directions_walk,
            content: const Text('Consejos de actividad física adaptados a tu ritmo de vida.'),
          ),
        ],
      ),
    );
  }
}