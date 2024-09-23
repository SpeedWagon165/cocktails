class Ingredients {
  final int id;
  final String name;
  final String description;
  final bool isAlcoholic;

  Ingredients({
    required this.id,
    required this.name,
    required this.description,
    required this.isAlcoholic,
  });

  factory Ingredients.fromJson(Map<String, dynamic> json) {
    return Ingredients(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isAlcoholic: json['is_alcoholic'],
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
    return Section(
      id: json['id'],
      name: json['name'],
      categories: (json['categories'] as List)
          .map((categoryJson) => Category.fromJson(categoryJson))
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

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      isMain: json['is_main'],
      isAlcoholic: json['is_alcoholic'],
      ingredients: (json['ingredients'] as List)
          .map((ingredientJson) => Ingredients.fromJson(ingredientJson))
          .toList(),
    );
  }
}
