import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/user_provider.dart';
import '../../shared/data/recommendations_data.dart';
import '../../shared/models/recommendation_model.dart';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final condition = context.watch<UserProvider>().condition;
    final recommendations = RecommendationsData.forCondition(condition);
    final categories = RecommendationsData.categoriesFor(condition);

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recomendaciones'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: categories.map((cat) {
              return Tab(
                icon: Icon(_categoryIcon(cat), size: 18),
                text: _categoryLabel(cat),
              );
            }).toList(),
          ),
        ),
        body: Column(
          children: [
            // Banner especial solo para usuarios con ambas condiciones
            if (condition == 'both')
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.indigo.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.indigo.shade700, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Estos consejos están diseñados considerando '
                        'que tienes diabetes e hipertensión a la vez, '
                        'buscando el balance entre ambas.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.indigo.shade900,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Tabs con recomendaciones
            Expanded(
              child: TabBarView(
                children: categories.map((cat) {
                  final items = recommendations
                      .where((r) => r.category == cat)
                      .toList();
                  return _RecommendationList(items: items);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'alimentacion': return Icons.restaurant;
      case 'ejercicio': return Icons.directions_walk;
      case 'hidratacion': return Icons.water_drop;
      case 'bienestar': return Icons.self_improvement;
      default: return Icons.info_outline;
    }
  }

  String _categoryLabel(String category) {
    switch (category) {
      case 'alimentacion': return 'Alimentación';
      case 'ejercicio': return 'Ejercicio';
      case 'hidratacion': return 'Hidratación';
      case 'bienestar': return 'Bienestar';
      default: return category;
    }
  }
}

// ── Lista de recomendaciones por categoría ───────────────────

class _RecommendationList extends StatelessWidget {
  final List<RecommendationModel> items;
  const _RecommendationList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text('No hay recomendaciones para esta categoría.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _RecommendationCard(item: items[index]);
      },
    );
  }
}

// ── Tarjeta individual ────────────────────────────────────────

class _RecommendationCard extends StatefulWidget {
  final RecommendationModel item;
  const _RecommendationCard({required this.item});

  @override
  State<_RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<_RecommendationCard> {
  bool _expanded = false;

  Color _categoryColor(String category) {
    switch (category) {
      case 'alimentacion': return Colors.green;
      case 'ejercicio': return Colors.blue;
      case 'hidratacion': return Colors.lightBlue;
      case 'bienestar': return Colors.purple;
      default: return Colors.grey;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'alimentacion': return Icons.restaurant;
      case 'ejercicio': return Icons.directions_walk;
      case 'hidratacion': return Icons.water_drop;
      case 'bienestar': return Icons.self_improvement;
      default: return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(widget.item.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _categoryIcon(widget.item.category),
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Text(
                  widget.item.description,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}