class Example {
  final int id;
  final int productsId;
  final String file;
  final DateTime createdAt;
  final DateTime updatedAt;

  Example({
    required this.id,
    required this.productsId,
    required this.file,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Example.fromJson(Map<String, dynamic> json) {
    return Example(
      id: json['id'],
      productsId: json['products_id'],
      file: json['file'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
