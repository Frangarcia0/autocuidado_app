import 'package:flutter/material.dart';
import '../../shared/widgets/section_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          SectionCard(
            title: 'Configuración',
            icon: Icons.settings,
            content: const Text('Aquí podrás configurar tu perfil y preferencias.'),
          ),
        ],
      ),
    );
  }
}