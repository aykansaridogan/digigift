import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/faq_model.dart'; // Model yolunu güncelleyin

class FAQsService {
  final String _faqsUrl = 'https://www.digitalgift.com.tr/api/faqsGet';

  Future<FAQResponse> getFAQs() async {
    final response = await http.post(Uri.parse(_faqsUrl));

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      return FAQResponse.fromJson(responseJson);
    } else {
      throw Exception('FAQ verileri alınamadı. API yanıt kodu: ${response.statusCode}');
    }
  }
}
