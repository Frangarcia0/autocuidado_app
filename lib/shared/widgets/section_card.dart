import 'package:flutter/material.dart';

/// Widget reutilizable para secciones de contenido.
/// Úsalo en cualquier pantalla para mantener consistencia visual.
class SectionCard extends StatelessWidget {
  final String title;
  final Widget content;
  final IconData? icon;
  final Color? iconColor;

  const SectionCard({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: iconColor ?? Theme.of(context).colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }
}