import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre tus datos')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _Section(
            icon: Icons.shield_outlined,
            title: 'Tu privacidad importa',
            content:
                'Eira almacena tu información únicamente en tu dispositivo. '
                'No enviamos tus datos a servidores externos ni los compartimos '
                'con terceros.',
          ),
          _Section(
            icon: Icons.data_usage_outlined,
            title: '¿Qué información guardamos?',
            content:
                'Guardamos tu nombre, edad y condición de salud seleccionada, '
                'junto con el registro de tus hábitos diarios. '
                'No solicitamos datos clínicos como niveles de glucosa, '
                'presión arterial ni medicamentos.',
          ),
          _Section(
            icon: Icons.medical_services_outlined,
            title: 'Propósito de la app',
            content:
                'Eira es una herramienta de apoyo al autocuidado. '
                'No realiza diagnósticos médicos ni reemplaza la atención '
                'de profesionales de la salud. '
                'Ante cualquier duda sobre tu salud, consulta siempre '
                'con tu médico.',
          ),
          _Section(
            icon: Icons.delete_outline,
            title: '¿Cómo eliminar mis datos?',
            content:
                'Puedes eliminar todos tus datos en cualquier momento '
                'desde la opción "Resetear app" en tu perfil, '
                'o desinstalando la aplicación de tu dispositivo.',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Versión 1.0.0 — Proyecto de título, Informática Biomédica',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _Section({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
