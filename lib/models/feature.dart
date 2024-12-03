class Feature {
  final int id;
  final String? picture;
  final String name;
  final String description;
  final double price;
  final DateTime createdAt;
  final DateTime updatedAt;

  Feature({
    required this.id,
    this.picture,
    required this.name,
    required this.description,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: json['id'],
      picture: json['picture'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
