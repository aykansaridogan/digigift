import 'dart:convert';
import 'package:http/http.dart' as http;

class ContractsService {
  final String _contractsUrl = 'https://www.digitalgift.com.tr/api/contractsGet';

  Future<Map<String, dynamic>> getContracts() async {
    final response = await http.post(
      Uri.parse(_contractsUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      print('API Yanıtı: ${responseJson}'); // Yanıtı yazdır

      if (responseJson['success']) {
        return {
          'success': true,
          'message': responseJson['message'],
          'data': responseJson['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseJson['message'],
        };
      }
    } else {
      return {
        'success': false,
        'message': 'Veri alınamadı. API yanıt kodu: ${response.statusCode}',
      };
    }
  }
}
