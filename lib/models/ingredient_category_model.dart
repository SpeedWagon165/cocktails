class Ingredients {
  final int id;
  final String name;
  final String description;
  final bool isAlcoholic;
  final int sectionId; // Добавляем sectionId для каждого ингредиента

  Ingredients({
    required this.id,
    required this.name,
    required this.description,
    required this.isAlcoholic,
    required this.sectionId, // Требуется при создании объекта
  });

  factory Ingredients.fromJson(Map<String, dynamic> json, int sectionId) {
    return Ingredients(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      isAlcoholic: json['is_alcoholic'],
      sectionId: sectionId, // Передаем sectionId при создании
    );
  }
}

class Section {
  final int id;
  final String name;
  final List<Category> categories;

  Section({
    required this.id,
    required this.name,
    required this.categories,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    int modifiedId = json['id'];

    // Заменяем ID 4, 5, 6 на 1, 2, 3
    if (json['id'] == 4) modifiedId = 3;
    if (json['id'] == 5) modifiedId = 2;
    if (json['id'] == 6) modifiedId = 1;
    return Section(
      id: modifiedId,
      name: json['name'] ?? '',
      categories: (json['categories'] as List)
          .map((categoryJson) => Category.fromJson(categoryJson, modifiedId))
          .toList(),
    );
  }
}

class Category {
  final int id;
  final String name;
  final bool isMain;
  final bool isAlcoholic;
  final List<Ingredients> ingredients;

  Category({
    required this.id,
    required this.name,
    required this.isMain,
    required this.isAlcoholic,
    required this.ingredients,
  });

  factory Category.fromJson(Map<String, dynamic> json, int sectionId) {
    return Category(
      id: json['id'],
      name: json['name'] ?? '',
      isMain: json['is_main'],
      isAlcoholic: json['is_alcoholic'],
      ingredients: (json['ingredients'] as List)
          .map((ingredientJson) => Ingredients.fromJson(ingredientJson,
              sectionId)) // Передаем sectionId при создании ингредиента
          .toList(),
    );
  }
}
