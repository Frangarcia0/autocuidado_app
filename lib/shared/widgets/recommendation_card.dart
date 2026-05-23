import 'package:flutter/material.dart';
import '../../../shared/models/recommendation_model.dart';

class RecommendationCard extends StatelessWidget {
  final RecommendationModel recommendation;

  const RecommendationCard({super.key, required this.recommendation});

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_walk':
        return Icons.directions_walk;
      case 'water_drop':
        return Icons.water_drop;
      case 'self_improvement':
        return Icons.self_improvement;
      default:
        return Icons.lightbulb_outline;
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

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'alimentacion':
        return 'Alimentación';
      case 'ejercicio':
        return 'Ejercicio';
      case 'hidratacion':
        return 'Hidratación';
      case 'bienestar':
        return 'Bienestar';
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(recommendation.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: color.withValues(alpha:0.15),
                  child: Icon(
                    _getIcon(recommendation.icon),
                    color: color,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    recommendation.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getCategoryLabel(recommendation.category),
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              recommendation.body,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
