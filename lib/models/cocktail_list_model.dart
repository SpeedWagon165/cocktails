// Cocktail cocktailFromJson(String str) => Cocktail.fromJson(json.decode(str));
//
// String cocktailToJson(Cocktail data) => json.encode(data.toJson());
class CocktailResponseModel {
  final int count;
  final List<Cocktail> cocktails;

  CocktailResponseModel({required this.count, required this.cocktails});
}

class Cocktail {
  int id;
  int ingredientCount;
  List<Ingredient> ingredients;
  List<Tool> tools;
  bool isFavorite;
  String? imageUrl;
  String name;
  String description;
  Map<String, String>? instruction;
  bool isEnabled;
  String? photo;
  bool claimed;
  String moderationStatus;
  String? videoUrl;
  int user;
  bool isImageAvailable;

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
    required this.claimed,
    required this.moderationStatus,
    required this.videoUrl,
    required this.user,
    this.isImageAvailable = true,
  });

  Cocktail copyWith({
    int? id,
    int? ingredientCount,
    List<Ingredient>? ingredients,
    List<Tool>? tools,
    bool? isFavorite,
    String? imageUrl,
    String? name,
    String? description,
    Map<String, String>? instruction,
    bool? isEnabled,
    String? photo,
    bool? claimed,
    String? moderationStatus,
    String? videoUrl,
    int? user,
  }) {
    return Cocktail(
      id: id ?? this.id,
      ingredientCount: ingredientCount ?? this.ingredientCount,
      ingredients: ingredients ?? this.ingredients,
      tools: tools ?? this.tools,
      isFavorite: isFavorite ?? this.isFavorite,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      description: description ?? this.description,
      instruction: instruction ?? this.instruction,
      isEnabled: isEnabled ?? this.isEnabled,
      photo: photo ?? this.photo,
      claimed: claimed ?? this.claimed,
      moderationStatus: moderationStatus ?? this.moderationStatus,
      videoUrl: videoUrl ?? this.videoUrl,
      user: user ?? this.user,
    );
  }

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    return Cocktail(
      id: json["id"],
      ingredientCount: json["ingredient_count"] ?? 0,
      ingredients: (json["ingredients"] as List<dynamic>?)
              ?.map((item) => Ingredient.fromJson(item))
              .toList() ??
          [],
      tools: (json["tools"] as List<dynamic>?)
              ?.map((item) => Tool.fromJson(item))
              .toList() ??
          [],
      isFavorite: json["is_favorite"] ?? false,
      imageUrl: json["image"] as String?,
      name: json["title"] ?? '',
      description: json["description"] ?? '',
      instruction: json["instruction"] != null
          ? Map<String, String>.from(json["instruction"])
          : null,
      isEnabled: json["isEnabled"] ?? true,
      photo: json["photo"] as String?,
      claimed: json["claimed"] ?? false,
      moderationStatus: json["moderation_status"] ?? '',
      videoUrl: json["video_url"] as String?,
      user: json["user"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "ingredient_count": ingredientCount,
        "ingredients": ingredients.map((x) => x.toJson()).toList(),
        "tools": tools.map((x) => x.toJson()).toList(),
        "is_favorite": isFavorite,
        "image": imageUrl,
        "title": name,
        "description": description,
        "instruction": instruction,
        "isEnabled": isEnabled,
        "photo": photo,
        "claimed": claimed,
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

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      ingredientId: json["ingredient"] ?? 0,
      name: json["name"] ?? '',
      quantity: json["quantity"] ?? '',
      type: json["type"] ?? '',
    );
  }

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
  String name;
  String? description;
  String? history;
  String? howToUse;
  String? photo;
  List<dynamic>? links;

  Tool({
    required this.id,
    required this.name,
    this.description,
    this.history,
    this.howToUse,
    this.photo,
    this.links,
  });

  factory Tool.fromJson(Map<String, dynamic> json) {
    return Tool(
      id: json["id"],
      name: json["name"] ?? 'Unknown Tool',
      description: json["description"] ?? '',
      history: json["history"] ?? '',
      howToUse: json["how_to_use"] ?? '',
      photo: json["photo"] ?? '',
      links: json["links"] != null ? List<dynamic>.from(json["links"]) : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "history": history,
        "how_to_use": howToUse,
        "photo": photo,
        "links": links?.map((x) => x).toList(),
      };
}
