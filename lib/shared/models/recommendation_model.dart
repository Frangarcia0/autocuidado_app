class RecommendationModel {
  final String id;
  final String category;
  final String title;
  final String body;
  final String icon;
  final String? condition;

  static const Map<String, String> _defaultIcons = {
    'alimentacion': 'restaurant',
    'ejercicio': 'directions_walk',
    'hidratacion': 'water_drop',
    'bienestar': 'self_improvement',
  };

  RecommendationModel({
    required this.id,
    required this.category,
    required this.title,
    String? body,
    String? description,
    this.condition,
    String? icon,
  })  : body = body ?? description ?? '',
        icon = icon ?? _defaultIcons[category] ?? 'lightbulb_outline';

  factory RecommendationModel.fromMap(Map<String, dynamic> map) {
    return RecommendationModel(
      id: map['id'] as String,
      category: map['category'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      icon: map['icon'] as String,
      condition: map['condition'] as String?,
    );
  }

}
