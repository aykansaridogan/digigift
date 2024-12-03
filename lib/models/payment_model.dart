
// PaymentResponse model class
class PaymentResponse {
  final bool success;
  final PaymentData data;
  final String message;

  PaymentResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      success: json['success'] ?? false,
      data: PaymentData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

// PaymentData model class
class PaymentData {
  final int totalCount;
  final int activePage;
  final List<Payment> response;

  PaymentData({
    required this.totalCount,
    required this.activePage,
    required this.response,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    var list = json['response'] as List? ?? [];
    List<Payment> payments = list.map((i) => Payment.fromJson(i)).toList();

    return PaymentData(
      totalCount: json['totalCount'] ?? 0,
      activePage: json['activePage'] ?? 0,
      response: payments,
    );
  }
}

// Payment model class
class Payment {
  final String orderCode;
  final int userId;
  final int productId;
  final double price;
  final String createdAt;
  final String updatedAt;
  final String userName;
  final String productName;
  final String productPicture;
  final String productDescription;
  final double productPrice;
  final String? featuresDetail;
  final String? questionsDetail;
  final String? answerFile;
  final String? answerPicture;
  final String? answerText;
  final String createdDate;

  Payment({
    required this.orderCode,
    required this.userId,
    required this.productId,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
    required this.productName,
    required this.productPicture,
    required this.productDescription,
    required this.productPrice,
    this.featuresDetail,
    this.questionsDetail,
    this.answerFile,
    this.answerPicture,
    this.answerText,
    required this.createdDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      orderCode: json['order_code'] ?? '',
      userId: json['user_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      price: json['price']?.toDouble() ?? 0.0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      userName: json['userName'] ?? '',
      productName: json['productName'] ?? '',
      productPicture: json['productPicture'] ?? '',
      productDescription: json['productDescription'] ?? '',
      productPrice: json['productPrice']?.toDouble() ?? 0.0,
      featuresDetail: json['features_detail'],
      questionsDetail: json['questionsDetail'],
      answerFile: json['answerFile'],
      answerPicture: json['answerPicture'],
      answerText: json['answerText'],
      createdDate: json['createdDate'] ?? '',
    );
  }
}
