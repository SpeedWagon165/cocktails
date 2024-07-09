class Cocktail {
  final int id;
  final String name;
  final String description;
  final String? imageUrl; // Изменено на String?
  final int ingredientCount;
  final String instruction;

  Cocktail({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl, // Изменено на String?
    required this.ingredientCount,
    required this.instruction,
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    return Cocktail(
      id: json['id'],
      name: json['title'],
      description: json['description'],
      imageUrl: json['image'],
      // Может быть null
      ingredientCount: json['ingredients'].length,
      instruction: json['instruction'],
    );
  }
}
