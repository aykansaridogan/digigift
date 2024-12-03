class ResponseData {
  final int id;
  final int categoriesId;
  final String? picture;
  final String name;
  final String description;
  final double price;
  final String features;
  final String questions;
  final DateTime createdAt;
  final DateTime updatedAt;

  ResponseData({
    required this.id,
    required this.categoriesId,
    this.picture,
    required this.name,
    required this.description,
    required this.price,
    required this.features,
    required this.questions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      id: json['id'],
      categoriesId: json['categories_id'],
      picture: json['picture'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      features: json['features'],
      questions: json['questions'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
