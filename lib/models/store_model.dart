class Product {
  final int id;
  final String? name;
  final String? description;
  final String? photo;
  final Map<String, dynamic>? links;

  Product({
    required this.id,
    this.name,
    this.description,
    this.photo,
    this.links,
  });

  // Фабричный метод для создания экземпляра из JSON-данных
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      // id обязательно
      name: json['name'],
      // может быть null
      description: json['description'],
      // может быть null
      photo: json['photo'],
      // может быть null
      links: json['links'] ?? {}, // может быть null
    );
  }
}
