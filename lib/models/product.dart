import 'dart:convert';

class ProductResponse {
  final bool success;
  final Data data;
  final String message;

  ProductResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      success: json['success'],
      data: Data.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class Data {
  final int totalCount;
  final int activePage;
  final List<Product> response;
  final bool status;

  Data({
    required this.totalCount,
    required this.activePage,
    required this.response,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      totalCount: json['totalCount'],
      activePage: json['activePage'],
      response: List<Product>.from(json['response'].map((x) => Product.fromJson(x))),
      status: json['status'],
    );
  }
}

class Product {
  final int id;
  final int categoriesId;
  final String? picture;
  final String name;
  final String description;
  final double price;
  final List<int> features;
  final List<int> questions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Example> examples;

  Product({
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
    required this.examples,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      categoriesId: json['categories_id'],
      picture: json['picture'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      features: List<int>.from(jsonDecode(json['features'])),
      questions: List<int>.from(jsonDecode(json['questions'])),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      examples: List<Example>.from(json['examples'].map((x) => Example.fromJson(x))),
    );
  }
}

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
