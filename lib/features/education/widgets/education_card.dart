import 'package:flutter/material.dart';
import '../../../shared/models/education_model.dart';

class EducationCard extends StatelessWidget {
  final EducationModel article;
  final VoidCallback onTap;

  const EducationCard({super.key, required this.article, required this.onTap});

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'alimentacion':
        return Colors.green;
      case 'ejercicio':
        return Colors.blue;
      case 'bienestar':
        return Colors.purple;
      case 'general':
        return Colors.teal;
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
      case 'bienestar':
        return 'Bienestar';
      case 'general':
        return 'General';
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(article.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getCategoryLabel(article.category),
                      style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                article.summary,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
