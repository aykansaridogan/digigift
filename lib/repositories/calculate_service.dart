import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<double?> calculateOrder(String baseUrl, Map<String, dynamic> body) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token'); // Bearer token'ı al

  if (token == null) {
    throw Exception('Token bulunamadı, lütfen tekrar giriş yapın.');
  }

  final url = Uri.parse('$baseUrl/calculateOrder');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] && data['data']['status']) {
        return data['data']['response'];
      } else {
        throw Exception(data['data']['message']);
      }
    } else {
      throw Exception('Hesaplama işlemi başarısız oldu.');
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
