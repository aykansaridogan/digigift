import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_response.dart';

class ProductDetailService {
  final String apiUrl = 'https://www.digitalgift.com.tr/api/productsGet';
  final String submitApiUrl = 'https://www.digitalgift.com.tr/api/paymentsTransactionAdd';
  final String calculateOrderUrl = 'https://www.digitalgift.com.tr/api/calculateOrder';
  final String paymentFinalApiUrl = "https://www.digitalgift.com.tr/api/paymentsTransactionEnd";

  Future<ApiResponse> fetchProductData(int id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token bulunamadı.');
      }
print(token);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
        },
        body: {
          'id': id.toString(),
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

        // Yanıtın 'data' anahtarını kontrol et
        final data = decodedResponse['data'] as Map<String, dynamic>;

        // 'response' anahtarının içeriğini kontrol et
        final product = data['response'] as Map<String, dynamic>;
        final features = data['features'] as List<dynamic>;
        final questionsListArr = data['questionsListArr'] as List<dynamic>;

        // ApiResponse nesnesini döndür
        return ApiResponse.fromJson({
          'success': decodedResponse['success'],
          'data': {
            'response': product,
            'features': features,
            'questionsListArr': questionsListArr,
          },
          'message': decodedResponse['message']
        });
      } else {
        print('Hata: ${response.statusCode}');
        print('Yanıt gövdesi: ${response.body}');
        throw Exception('API isteği başarısız oldu.');
      }
    } catch (e) {
      print('Hata oluştu: $e');
      rethrow;
    }
  }
  Future<String?> submitAnswers(
      int productId,
      List<int> features,
      Map<int, String?> textAnswers,
      Map<int, int?> selectAnswers
      ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token bulunamadı.');
      }

      // Cevapları bir dizi olarak dönüştür
      final answers = {
        ...textAnswers.map((key, value) => MapEntry(key.toString(), value)),
        ...selectAnswers.map((key, value) => MapEntry(key.toString(), value.toString())),
      };

      final response = await http.post(
        Uri.parse(submitApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'product_id': productId.toString(), // productId'yi product_id olarak değiştirdik
          'features': features,  // features listesini ekledik
          'answers': answers,   // answers'ı ekledik
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String? orderCode = responseData['data']['order_code'];  // order_code'a erişim

        if (orderCode != null) {
          // Order kodunu SharedPreferences'ta saklayın
          await prefs.setString('order_code', orderCode);
          print('Sipariş başarıyla alındı ve kaydedildi: $orderCode');
          return orderCode;  // orderCode'u döndürün

        } else {
          throw Exception('Order code bulunamadı.');
        }
      } else {
        print('Yanıt Kodu: ${response.statusCode}');
        print('Yanıt Gövdesi: ${response.body}');
        throw Exception('API isteği başarısız oldu: ${response.statusCode}');
      }
    } catch (e) {
      print('Hata oluştu: $e');
      rethrow;
    }
  }
  Future<double> calculatePrice(int productId, List<int> features) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token bulunamadı.');
      }

      final response = await http.post(
        Uri.parse(calculateOrderUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'product_id': productId.toString(),
          'features': features,
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final data = decodedResponse['data'] as Map<String, dynamic>;

        if (data['status'] == true) {
          return data['response'] as double;
        } else {
          throw Exception('Fiyat hesaplanamadı: ${data['message']}');
        }
      } else {
        print('Hata: ${response.statusCode}');
        print('Yanıt gövdesi: ${response.body}');
        throw Exception('API isteği başarısız oldu.');
      }
    } catch (e) {
      print('Hata oluştu: $e');
      rethrow;
    }
  }
   Future<void> sendPaymentTransactionEnd(String orderCode) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token bulunamadı.');
      }

      // İstek gövdesi (order_code'yi gönderiyoruz)
      final body = jsonEncode({
        'order_code': orderCode,
        
      });

      // Bearer token ile isteği hazırlıyoruz
      final response = await http.post(
        Uri.parse(paymentFinalApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print("İşlem başarıyla tamamlandı: ${response.body}");
      } else {
        print("Hata oluştu: ${response.statusCode} - ${response.body}");
      }
    } catch (error) {
      print("Hata: $error");
    }
  }

}
