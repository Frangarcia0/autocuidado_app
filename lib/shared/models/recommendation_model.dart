<<<<<<< HEAD
class RecommendationModel {
  final String id;
  final String category;
  final String title;
  final String body;
  final String icon;

  const RecommendationModel({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.icon,
  });

  factory RecommendationModel.fromMap(Map<String, dynamic> map) {
    return RecommendationModel(
      id: map['id'] as String,
      category: map['category'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      icon: map['icon'] as String,
    );
  }
}
=======
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
>>>>>>> 5ee850ee38f487473e9db5bcbe8b5157d187fb34
