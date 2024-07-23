import 'dart:convert';

List<Cocktail> cocktailFromJson(String str) =>
    List<Cocktail>.from(json.decode(str).map((x) => Cocktail.fromJson(x)));

class Cocktail {
  int id;
  bool isFavorite;
  String name;
  String description;
  String instruction;
  final String? imageUrl; // Изменено на String?
  final int ingredientCount;
  bool isEnabled;
  String moderationStatus;
  dynamic videoUrl;
  int user;
  List<int> ingredients;
  List<dynamic> tools;

  Cocktail({
    required this.id,
    required this.isFavorite,
    required this.name,
    required this.description,
    required this.instruction,
    required this.isEnabled,
    required this.ingredientCount,
    required this.imageUrl,
    required this.moderationStatus,
    required this.videoUrl,
    required this.user,
    required this.ingredients,
    required this.tools,
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) => Cocktail(
        id: json["id"],
        isFavorite: json["is_favorite"],
        name: json["title"],
        description: json["description"],
        instruction: json["instruction"],
        isEnabled: json["isEnabled"],
        imageUrl: json['image'],
        // Может быть null
        ingredientCount: json['ingredients'].length,
        moderationStatus: json["moderation_status"],
        videoUrl: json["video_url"],
        user: json["user"],
        ingredients: List<int>.from(json["ingredients"].map((x) => x)),
        tools: List<dynamic>.from(json["tools"].map((x) => x)),
      );
}
