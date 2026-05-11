import 'package:flutter/material.dart';

class DisclaimerPage extends StatelessWidget {
  const DisclaimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 80,
            color: Colors.orange.shade700,
          ),
          const SizedBox(height: 32),
          Text(
            'Importante',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'Esta aplicación es una herramienta de apoyo al autocuidado.\n\n'
            'No reemplaza la atención médica profesional, ni realiza '
            'diagnósticos.\n\n'
            'Ante cualquier duda sobre tu salud, consulta siempre con '
            'un profesional.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.6),
          ),
        ],
      ),
    );
  }
}