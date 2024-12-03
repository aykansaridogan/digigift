import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  final String _profileUrl = 'https://www.digitalgift.com.tr/api/userProfileGet';
  final String _updateProfileUrl = 'https://www.digitalgift.com.tr/api/userProfileUpdate';
  final String _logoutUrl = 'https://www.digitalgift.com.tr/api/logout'; // Oturum kapatma URL'si

  Future<Map<String, dynamic>> getProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token'); // Token'ı al

    // Token'ı ekrana basma
    print('Token: $token');
    if (token == null) {
      return {
        'success': false,
        'message': 'Token bulunamadı. Lütfen giriş yapın.',
      };
    }

    final response = await http.post(
      Uri.parse(_profileUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Token'ı başlıkta gönder
      },
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      print('Profil API Yanıtı: ${responseJson}'); // Yanıtı yazdır

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
        'message': 'Profil bilgileri alınamadı. API yanıt kodu: ${response.statusCode}',
      };
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String surname,
    required String email,
    required String phone,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token'); // Token'ı al

    if (token == null) {
      return {
        'success': false,
        'message': 'Token bulunamadı. Lütfen giriş yapın.',
      };
    }

    final response = await http.post(
      Uri.parse(_updateProfileUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Token'ı başlıkta gönder
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'surname': surname,
        'email': email,
        'phone': phone,
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      print('Profil Güncelleme API Yanıtı: ${responseJson}'); // Yanıtı yazdır

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
      return {
        'success': false,
        'message': 'Profil güncellenemedi. API yanıt kodu: ${response.statusCode}',
      };
    }
  }
  Future<Map<String, dynamic>> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token'); // Bearer token'ı al

    final response = await http.post(
      Uri.parse(_logoutUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Token'ı temizle
      await prefs.remove('token');
      return jsonDecode(response.body);
    } else {
      throw Exception('Oturum kapatma başarısız oldu. API yanıt kodu: ${response.statusCode}');
    }
  }
}
