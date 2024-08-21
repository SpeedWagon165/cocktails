// Cocktail cocktailFromJson(String str) => Cocktail.fromJson(json.decode(str));
//
// String cocktailToJson(Cocktail data) => json.encode(data.toJson());

class Cocktail {
  int id;
  int ingredientCount;
  List<Ingredient>? ingredients;
  List<Tool> tools;
  bool isFavorite;
  dynamic imageUrl;
  String name;
  String description;
  Map<String, String>? instruction;
  bool isEnabled;
  dynamic photo;
  String moderationStatus;
  String? videoUrl;
  int user;

  Cocktail({
    required this.id,
    required this.ingredientCount,
    required this.ingredients,
    required this.tools,
    required this.isFavorite,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.instruction,
    required this.isEnabled,
    required this.photo,
    required this.moderationStatus,
    required this.videoUrl,
    required this.user,
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) => Cocktail(
        id: json["id"],
        ingredientCount: json["ingredient_count"],
        tools: List<Tool>.from(json["tools"].map((x) => Tool.fromJson(x))),
        isFavorite: json["is_favorite"],
        imageUrl: json["image"],
        name: json["title"],
        description: json["description"],
        instruction: json["instruction"] == null
            ? {'1': '1'}
            : Map.from(json["instruction"])
                .map((k, v) => MapEntry<String, String>(k, v)),
        isEnabled: json["isEnabled"],
        photo: json["photo"],
        moderationStatus: json["moderation_status"],
        videoUrl: json["video_url"],
        user: json["user"],
        ingredients: json["ingredients"] != null
            ? List<Ingredient>.from(
                json["ingredients"].map((x) => Ingredient.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ingredient_count": ingredientCount,
        "ingredients": ingredients != null
            ? List<dynamic>.from(ingredients!.map((x) => x.toJson()))
            : null,
        "tools": List<dynamic>.from(tools.map((x) => x.toJson())),
        "is_favorite": isFavorite,
        "image": imageUrl,
        "title": name,
        "description": description,
        "instruction": Map.from(instruction!)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "isEnabled": isEnabled,
        "photo": photo,
        "moderation_status": moderationStatus,
        "video_url": videoUrl,
        "user": user,
      };
}

class Ingredient {
  int ingredientId;
  String name;
  String quantity;
  String type;

  Ingredient({
    required this.ingredientId,
    required this.name,
    required this.quantity,
    required this.type,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        ingredientId: json["ingredient"],
        name: json["name"],
        quantity: json["quantity"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "ingredient": ingredientId,
        "name": name,
        "quantity": quantity,
        "type": type,
      };

  @override
  String toString() {
    return '$name: $quantity $type';
  }
}

class Tool {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String description;
  String history;
  String howToUse;
  String photo;
  List<dynamic> links;

  Tool({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
    required this.history,
    required this.howToUse,
    required this.photo,
    required this.links,
  });

  factory Tool.fromJson(Map<String, dynamic> json) => Tool(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        name: json["name"] ?? '',
        // Обработка null
        description: json["description"] ?? '',
        // Обработка null
        history: json["history"] ?? '',
        // Обработка null
        howToUse: json["how_to_use"] ?? '',
        // Обработка null
        photo: json["photo"] ?? '',
        // Обработка null
        links: List<dynamic>.from(json["links"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "name": name,
        "description": description,
        "history": history,
        "how_to_use": howToUse,
        "photo": photo,
        "links": List<dynamic>.from(links.map((x) => x)),
      };
}
