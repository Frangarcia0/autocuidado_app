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
