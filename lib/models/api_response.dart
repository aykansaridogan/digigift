import 'package:digitalgift/models/question.dart';

import 'example.dart';
import 'feature.dart';

class ApiResponse {
  final bool success;
  final Data data;
  final bool status;
  final String message;

  ApiResponse({
    required this.success,
    required this.data,
    required this.status,
    required this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    // Null kontrolü ekleyin ve varsayılan değerler kullanın
    bool success = json['success'] ?? false;
    bool status = json['status'] ?? false;
    String message = json['message'] ?? '';

    // Data objesinin null olup olmadığını kontrol edin
    var dataJson = json['data'] as Map<String, dynamic>?;

    return ApiResponse(
      success: success,
      data: dataJson != null ? Data.fromJson(dataJson) : Data.empty(), // Empty Data oluşturulabilir
      status: status,
      message: message,
    );
  }
}

class Data {
  final List<Example> examples;
  final List<Feature> features;
  final List<Question> questionsListArr;
  final ResponseData response;

  Data({
    required this.examples,
    required this.features,
    required this.questionsListArr,
    required this.response,
  });

  // Data için boş bir constructor ekleyin
  factory Data.empty() {
    return Data(
      examples: [],
      features: [],
      questionsListArr: [],
      response: ResponseData.empty(),
    );
  }

  factory Data.fromJson(Map<String, dynamic> json) {
    var examplesJson = json['examples'] as List? ?? [];
    var featuresJson = json['features'] as List? ?? [];
    var questionsListArrJson = json['questionsListArr'] as List? ?? [];

    List<Example> examplesList = examplesJson.map((i) => Example.fromJson(i)).toList();
    List<Feature> featuresList = featuresJson.map((i) => Feature.fromJson(i)).toList();
    List<Question> questionsList = questionsListArrJson.map((i) => Question.fromJson(i)).toList();

    // Null kontrolü ekleyin
    var responseJson = json['response'] as Map<String, dynamic>?;

    return Data(
      examples: examplesList,
      features: featuresList,
      questionsListArr: questionsList,
      response: responseJson != null ? ResponseData.fromJson(responseJson) : ResponseData.empty(),
    );
  }
}

class ResponseData {
  final int id;
  final int categoriesId;
  final String? picture;
  final String name;
  final String description;
  final double price;
  final String features;
  final String questions;

  ResponseData({
    required this.id,
    required this.categoriesId,
    this.picture,
    required this.name,
    required this.description,
    required this.price,
    required this.features,
    required this.questions,
  });

  // Boş bir constructor ekleyin
  factory ResponseData.empty() {
    return ResponseData(
      id: 0,
      categoriesId: 0,
      picture: null,
      name: '',
      description: '',
      price: 0.0,
      features: '',
      questions: '',
    );
  }

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      id: json['id'] ?? 0,
      categoriesId: json['categories_id'] ?? 0,
      picture: json['picture'] as String?,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      features: json['features'] ?? '',
      questions: json['questions'] ?? '',
    );
  }
}
