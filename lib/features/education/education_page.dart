import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/education_provider.dart';
import 'education_detail_page.dart';
import 'widgets/education_card.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EducationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Educación')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.articles.isEmpty
          ? const Center(child: Text('No hay contenido disponible.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.articles.length,
              itemBuilder: (context, index) {
                final article = provider.articles[index];
                return EducationCard(
                  article: article,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EducationDetailPage(article: article),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
