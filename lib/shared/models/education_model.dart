class EducationModel {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String category;

  const EducationModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
  });

  factory EducationModel.fromMap(Map<String, dynamic> map) {
    return EducationModel(
      id: map['id'] as String,
      title: map['title'] as String,
      summary: map['summary'] as String,
      content: map['content'] as String,
      category: map['category'] as String,
    );
  }
}
