import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final String _loginUrl = 'https://www.digitalgift.com.tr/api/frontLogin';

  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone': phone,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        print('API Yanıtı: ${responseJson}'); // Yanıtı yazdır

        if (responseJson['success']) {
          final token = responseJson['data']['token']; // Token'ı doğru yerden al
          final rememberToken = responseJson['data']['remember_token']; // Remember Token'ı al

          if (token == null || token is! String || rememberToken == null || rememberToken is! String) {
            return {
              'success': false,
              'message': 'Geçersiz token alındı.',
            };
          }

          // Token'ı SharedPreferences'a kaydet
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token); // Token'ı kaydet
          await prefs.setString('remember_token', rememberToken); // Remember Token'ı kaydet

          return {
            'success': true,
            'message': responseJson['data']['message'], // Mesajı doğru yerden al
            'token': token, // Token bilgisi varsa
            'remember_token': rememberToken, // Remember Token bilgisi varsa

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
          'message': 'Giriş başarısız. API yanıt kodu: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Bir hata oluştu: $e',
      };
    }
  }
  Future<Map<String, dynamic>> autoLogin(String rememberToken) async {
    try {

      final response = await http.post(
        Uri.parse(_loginUrl), // Doğru uç nokta kullanın
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'remember_token': rememberToken, // remember_token gönder
        }),
      );

      if (response.statusCode == 200) {
        // Sadece API yanıtını yazdır
        print('Otomatik giriş API yanıtı: ${response.body}');
        return json.decode(response.body);
      } else {
        // API'den gelen hata kodunu ve mesajını yazdır
        print('Otomatik giriş API yanıt kodu: ${response.statusCode}');
        print('Otomatik giriş API hata mesajı: ${response.reasonPhrase}');
        return {
          'success': false,
          'message': 'Otomatik giriş başarısız. API yanıt kodu: ${response.statusCode}',
        };
      }
    } catch (e) {
      // Hata durumunu yazdır
      print('Hata: $e');
      return {
        'success': false,
        'message': 'Bir hata oluştu: $e',
      };
    }
  }

}
