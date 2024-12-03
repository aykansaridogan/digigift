import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ForgotPasswordService {
  final String _forgotPasswordUrl = 'https://www.digitalgift.com.tr/api/frontForgotPassword';
  final String _resetPasswordUrl = 'https://www.digitalgift.com.tr/api/forgotPasswordReset';
  final String _verifySmsCodeUrl = 'https://www.digitalgift.com.tr/api/forgotSmsCheck'; // SMS doğrulama URL'si

  Future<Map<String, dynamic>> forgotPassword({required String phone}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token'); // Bearer token'ı al

    final response = await http.post(
      Uri.parse(_forgotPasswordUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'phone': phone,
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
      throw Exception('Şifre sıfırlama başarısız. API yanıt kodu: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> verifySmsCode({
    required String phone,
    required String smsCode,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token'); // Bearer token'ı al

    print('Token: $token');
    print('Phone: $phone');
    print('SMS Code: $smsCode');

    final response = await http.post(
      Uri.parse(_verifySmsCodeUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'phone': phone,
        'smsCode': smsCode,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

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
      throw Exception('SMS kodu doğrulama başarısız. API yanıt kodu: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String phone,
    required String smscode,
    required String password,
    required String confirmPassword,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token'); // Bearer token'ı al

    final response = await http.post(
      Uri.parse(_resetPasswordUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'

      },
      body: jsonEncode({
        'phone': phone,
        'smsCode': smscode,
        'password': password,
        'rePassword': confirmPassword,
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
      throw Exception('Şifre sıfırlama başarısız oldu. API yanıt kodu: ${response.statusCode}');
    }
  }
}
