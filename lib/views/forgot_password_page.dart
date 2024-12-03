import 'package:flutter/material.dart';
import 'package:digitalgift/repositories/forgot_password_service.dart';

import 'forgot_password_sms_verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _phoneController = TextEditingController();
  final _forgotPasswordService = ForgotPasswordService();

  Future<void> _forgotPassword() async {
    final result = await _forgotPasswordService.forgotPassword(
      phone: _phoneController.text,
    );

    if (result['success']) {
      // Şifre sıfırlama başarılı, kullanıcıya mesaj göster
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Başarılı'),
          content: Text(result['message']),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // ForgotPasswordSmsVerificationPage sayfasına yönlendir
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ForgotPasswordSmsVerificationPage(
                      phoneNumber: _phoneController.text,
                    ),
                  ),
                );
              },
              child: Text('Tamam'),
            ),
          ],
        ),
      );
    } else {
      // Hata mesajını göster
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Hata'),
          content: Text(result['message']),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.green,
      body: Stack(
        children: [
          // Üst kısım
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.15, // Ekran uzunluğunun %15'i kadar yukarıdan
                left: screenSize.width * 0.1, // Ekran genişliğinin %10'u kadar soldan
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Şifremi unuttum',
                    style: TextStyle(
                      fontSize: screenSize.height * 0.05, // Dinamik font boyutu
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.01), // Dinamik boşluk
                  Text(
                    'Şifrenizi mi unuttunuz? Endişelenmeyin,\nhemen sıfırlayabilirsiniz!',
                    style: TextStyle(
                      fontSize: screenSize.height * 0.02, // Dinamik font boyutu
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Orta kısım
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenSize.width, // Genişlik ekran genişliği kadar
              height: screenSize.height * 0.3, // Yükseklik ekranın %30'u kadar
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(screenSize.height * 0.05)),
              ),
              child: Column(
                children: [
                  SizedBox(height: screenSize.height * 0.03), // Dinamik boşluk
                  TextField(
                    controller: _phoneController, // Telefon numarasını kontrol eden controller
                    decoration: InputDecoration(
                      labelText: 'Telefon Numaranız',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenSize.height * 0.03), // Dinamik oval kenarlar
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                      prefixIcon: Icon(
                        Icons.phone, // Telefon ikonu
                        color: Colors.green, // İkon rengi
                        size: screenSize.height * 0.03, // Dinamik ikon boyutu
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.03), // Dinamik boşluk
                  Container(
                    width: screenSize.width * 0.9, // Genişliği ekran genişliğinin %90'ı kadar yapar
                    margin: EdgeInsets.only(bottom: screenSize.height * 0.02), // Dinamik margin
                    child: ElevatedButton(
                      onPressed: _forgotPassword, // Şifre sıfırlama işlemi
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Buton rengi
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenSize.height * 0.05), // Dinamik oval kenarlar
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.08,
                          vertical: screenSize.height * 0.02,
                        ), // Dinamik buton boyutu
                      ),
                      child: Text(
                        'Şifremi Sıfırla', // Buton üzerindeki metin
                        style: TextStyle(
                          fontSize: screenSize.height * 0.025, // Dinamik yazı boyutu
                          color: Colors.white, // Yazı rengi
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
