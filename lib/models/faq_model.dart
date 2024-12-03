class FAQ {
  final int id;
  final int order;
  final String question;
  final String answer;
  final String createdAt;
  final String updatedAt;

  FAQ({
    required this.id,
    required this.order,
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON'dan Dart nesnesine dönüştürme
  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['id'],
      order: json['order'],
      question: json['question'],
      answer: json['answer'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Dart nesnesinden JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order': order,
      'question': question,
      'answer': answer,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class FAQResponse {
  final bool success;
  final String message;
  final FAQData data;

  FAQResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  // JSON'dan Dart nesnesine dönüştürme
  factory FAQResponse.fromJson(Map<String, dynamic> json) {
    return FAQResponse(
      success: json['success'],
      message: json['message'],
      data: FAQData.fromJson(json['data']),
    );
  }

  // Dart nesnesinden JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class FAQData {
  final int totalCount;
  final int activePage;
  final List<FAQ> response;
  final bool status;

  FAQData({
    required this.totalCount,
    required this.activePage,
    required this.response,
    required this.status,
  });

  // JSON'dan Dart nesnesine dönüştürme
  factory FAQData.fromJson(Map<String, dynamic> json) {
    return FAQData(
      totalCount: json['totalCount'],
      activePage: json['activePage'],
      response: (json['response'] as List)
          .map((item) => FAQ.fromJson(item))
          .toList(),
      status: json['status'],
    );
  }

  // Dart nesnesinden JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'activePage': activePage,
      'response': response.map((faq) => faq.toJson()).toList(),
      'status': status,
    };
  }
}
