import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_response.dart';



class ProductService {
  final String baseUrl = 'https://www.digitalgift.com.tr/api/productsGet';

  Future<ProductResponse> fetchProducts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token'); // Token'ı al
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token', // Bearer token'ı başlığa ekle
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return ProductResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load products');
    }
  }
}
