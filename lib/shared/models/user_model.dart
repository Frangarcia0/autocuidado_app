class UserModel {
  final String name;
  final String condition;
  final int age;
  final double? height; // en centímetros
  final double? weight; // en kilogramos

  const UserModel({
    required this.name,
    required this.condition,
    required this.age,
    this.height,
    this.weight,
  });

  UserModel copyWith({
    String? name,
    String? condition,
    int? age,
    double? height,
    double? weight,
  }) {
    return UserModel(
      name: name ?? this.name,
      condition: condition ?? this.condition,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'condition': condition,
    'age': age,
    if (height != null) 'height': height,
    if (weight != null) 'weight': weight,
  };

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      condition: map['condition'] as String,
      age: map['age'] as int,
      height: map['height'] != null ? (map['height'] as num).toDouble() : null,
      weight: map['weight'] != null ? (map['weight'] as num).toDouble() : null,
    );
  }
}
