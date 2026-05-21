/// Modelo de una recomendación de autocuidado.
/// No contiene información clínica — solo consejos generales.
class RecommendationModel {
  final String id;
  final String title;
  final String description;
  final String category; // 'alimentacion' | 'ejercicio' | 'bienestar' | 'hidratacion'
  final String condition; // 'diabetes' | 'hypertension' | 'both'

  const RecommendationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.condition,
  });
}