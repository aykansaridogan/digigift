import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment_model.dart'; // Model yolunu güncelleyin
import 'package:shared_preferences/shared_preferences.dart';

class PaymentsService {
  final String _paymentsUrl = 'https://www.digitalgift.com.tr/api/myPaymentsGet';

  Future<PaymentResponse> getPayments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token'); // Token'ı al

    if (token == null) {
      throw Exception('Token bulunamadı. Lütfen giriş yapınız.');
    }

    final response = await http.post(
      Uri.parse(_paymentsUrl),
      headers: {
       'Authorization': 'Bearer $token',
   // 'Authorization': 'Bearer 63|BIie1KKWoniVy078DnFO4em8yu6EfQ5My4lr87SJ4e64cdf2',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      return PaymentResponse.fromJson(responseJson);
    } else {
      throw Exception('Siparişler alınamadı. API yanıt kodu: ${response.statusCode}');
    }
  }
}
