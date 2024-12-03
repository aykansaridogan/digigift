import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  final String _baseUrl = 'https://www.digitalgift.com.tr/api/frontRegister';
  final String _verifySmsCodeUrl = 'https://www.digitalgift.com.tr/api/smsCodeCheck';
  final String _resendSmsCodeUrl = 'https://www.digitalgift.com.tr/api/smsCodeResend';

  Future<Map<String, dynamic>> register({
    required String name,
    required String surname,
    required String phone,
    required String phoneCode, // Yeni eklenen phoneCode
    required String phoneChar, // Yeni eklenen phoneChar
    required String password,
    required String repassword,
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'surname': surname,
        'phone': phone,
        'phoneCode': phoneCode, // Yeni parametre
        'phoneChar': phoneChar, // Yeni parametre
        'password': password,
        'repassword': repassword,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      if (responseJson['success']) {
        return {
          'success': true,
          'message': responseJson['message'],
        };
      } else {
        return {
          'success': false,
          'message': responseJson['message'],
        };
      }
    } else {
      throw Exception('Kayıt başarısız. API yanıt kodu: ${response.statusCode}');
    }
  }

  Future<void> verifySmsCode({
    required String phone,
    required String smsCode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_verifySmsCodeUrl),
        body: jsonEncode({
          'phone': phone,
          'smsCode': smsCode,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print('Verify SMS code response status: ${response.statusCode}');
      print('Verify SMS code response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to verify SMS code');
      }
    } catch (e) {
      print('Error during SMS code verification: $e');
    }
  }

  Future<Map<String, dynamic>> resendSmsCode({
    required String phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_resendSmsCodeUrl),
        body: jsonEncode({
          'phone': phone,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print('Resend SMS code response status: ${response.statusCode}');
      print('Resend SMS code response body: ${response.body}');

      final responseJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseJson['success']) {
          return {
            'success': true,
            'message': responseJson['message'],
          };
        } else {
          return {
            'success': false,
            'message': responseJson['message'],
          };
        }
      } else {
        throw Exception('Failed to resend SMS code. API yanıt kodu: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during SMS code resend: $e');
      return {
        'success': false,
        'message': 'SMS kodu gönderilemedi.',
      };
    }
  }
}
