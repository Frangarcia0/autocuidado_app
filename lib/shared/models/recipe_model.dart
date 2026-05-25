class RecipeModel {
  final String id;
  final String title;
  final String category;
  final String condition;
  final int prepTime;
  final String difficulty;
  final String tag;
  final String image;
  final List<String> ingredients;
  final List<String> steps;
  final String nutritionalNote;
  final String source;

  const RecipeModel({
    required this.id,
    required this.title,
    required this.category,
    required this.condition,
    required this.prepTime,
    required this.difficulty,
    required this.tag,
    required this.image,
    required this.ingredients,
    required this.steps,
    required this.nutritionalNote,
    required this.source,
  });

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['id'] as String,
      title: map['title'] as String,
      category: map['category'] as String,
      condition: map['condition'] as String,
      prepTime: map['prepTime'] as int,
      difficulty: map['difficulty'] as String,
      tag: map['tag'] as String,
      image: map['image'] as String,
      ingredients: List<String>.from(map['ingredients'] as List),
      steps: List<String>.from(map['steps'] as List),
      nutritionalNote: map['nutritionalNote'] as String,
      source: map['source'] as String,
    );
  }
}
