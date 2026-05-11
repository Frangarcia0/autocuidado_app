import 'package:flutter/material.dart';
import '../../shared/widgets/section_card.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Educación')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          SectionCard(
            title: '¿Qué es la diabetes?',
            icon: Icons.info_outline,
            content: const Text('Información educativa general sobre diabetes mellitus tipo 2.'),
          ),
          SectionCard(
            title: '¿Qué es la hipertensión?',
            icon: Icons.info_outline,
            content: const Text('Información educativa general sobre hipertensión arterial.'),
          ),
        ],
      ),
    );
  }
}