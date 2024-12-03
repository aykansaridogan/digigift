import 'package:flutter/material.dart';
import 'package:digitalgift/repositories/forgot_password_service.dart'; // ForgotPasswordService import edin
import 'package:digitalgift/views/login_page.dart'; // HomePage import edin

class ForgotNewPasswordPage extends StatefulWidget {
  final String phoneNumber;
  final String smsCode;

  ForgotNewPasswordPage({required this.phoneNumber, required this.smsCode});

  @override
  _ForgotNewPasswordPageState createState() => _ForgotNewPasswordPageState();
}

class _ForgotNewPasswordPageState extends State<ForgotNewPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ForgotPasswordService _forgotPasswordService = ForgotPasswordService();

  Future<void> _resetPassword() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifreler eşleşmiyor')),
      );
      return;
    }

    try {
      final result = await _forgotPasswordService.resetPassword(
        phone: widget.phoneNumber,
        smscode: widget.smsCode,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Şifre başarıyla güncellendi!')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İşlem başarısız: ${result['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İşlem sırasında bir hata oluştu: $e')),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.15,
                left: screenSize.width * 0.1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hoşgeldiniz!',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Text(
                    'Yeni şifrenizi oluşturun.',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenSize.width * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(screenSize.width * 0.1)),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Yeni Şifre',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Şifreyi Onayla',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  ElevatedButton(
                    onPressed: _resetPassword,
                    child: Text('Şifreyi Güncelle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
                      textStyle: TextStyle(
                        fontSize: screenSize.width * 0.05,
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
