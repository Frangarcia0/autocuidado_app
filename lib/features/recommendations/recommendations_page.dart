import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/recommendations_provider.dart';
import 'widgets/recommendation_card.dart';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({super.key});

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'todas':
        return 'Todas';
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
    final provider = context.watch<RecommendationsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Recomendaciones')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 64,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: provider.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = provider.categories[index];
                      final isSelected = provider.selectedCategory == category;
                      return FilterChip(
                        label: Text(_getCategoryLabel(category)),
                        selected: isSelected,
                        onSelected: (_) => provider.setCategory(category),
                        selectedColor: Theme.of(context).colorScheme.primaryContainer,
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: provider.recommendations.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No hay recomendaciones para esta categoría.'),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: provider.recommendations.length,
                          itemBuilder: (context, index) {
                            return RecommendationCard(
                              recommendation: provider.recommendations[index],
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
