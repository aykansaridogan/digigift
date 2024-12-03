class ProductResponse {
  final bool success;
  final List<Product> products;

  ProductResponse({required this.success, required this.products});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']['response'] as List;
    List<Product> productsList = list.map((i) => Product.fromJson(i)).toList();

    return ProductResponse(
      success: json['success'],
      products: productsList,
    );
  }
}

class Product {
  final int id;
  final int categoryId;
  final String name;
  final String description;
  final double price;
  final String? iconType;
  final String? backColor;
  final String? foreColor;
  final String? iconColor;
  final List<Example> examples;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    this.iconType,
    this.backColor,
    this.foreColor,
    this.iconColor,
    required this.examples,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var list = json['examples'] as List? ?? [];
    List<Example> exampleList = list.map((i) => Example.fromJson(i)).toList();

    return Product(
      id: json['id'],
      categoryId: json['categories_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      iconType: json['icon_type'],
      backColor: json['backColor'],
      foreColor: json['foreColor'],
      iconColor: json['iconColor'],
      examples: exampleList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categories_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'icon_type': iconType,
      'backColor': backColor,
      'foreColor': foreColor,
      'iconColor': iconColor,
      'examples': examples.map((e) => e.toJson()).toList(),
    };
  }
}

class Example {
  final int id;
  final int productId;
  final String file;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? backColor;
  final String? foreColor;
  final String? iconColor;

  Example({
    required this.id,
    required this.productId,
    required this.file,
    required this.createdAt,
    required this.updatedAt,
    this.backColor,
    this.foreColor,
    this.iconColor,
  });

  factory Example.fromJson(Map<String, dynamic> json) {
    return Example(
      id: json['id'],
      productId: json['products_id'],
      file: json['file'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      backColor: json['backColor'],
      foreColor: json['foreColor'],
      iconColor: json['iconColor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products_id': productId,
      'file': file,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'backColor': backColor,
      'foreColor': foreColor,
      'iconColor': iconColor,
    };
  }
}
