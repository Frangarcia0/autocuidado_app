/// Modelo de usuario — sin datos clínicos sensibles.
/// Solo preferencias de autocuidado y configuración de la app.
class UserModel {
  final String name;
  final String condition; // 'diabetes' | 'hypertension' | 'both'
  final int age;

  const UserModel({
    required this.name,
    required this.condition,
    required this.age,
  });

  // Permite crear una copia modificada del usuario
  UserModel copyWith({String? name, String? condition, int? age}) {
    return UserModel(
      name: name ?? this.name,
      condition: condition ?? this.condition,
      age: age ?? this.age,
    );
  }

  // Convierte a/desde Map para almacenamiento local futuro
  Map<String, dynamic> toMap() => {'name': name, 'condition': condition, 'age': age};

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(name: map['name'], condition: map['condition'], age: map['age']);
  }
}