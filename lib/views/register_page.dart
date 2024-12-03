import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:digitalgift/views/login_page.dart';
import 'package:digitalgift/views/sms_verification_page.dart';
import 'package:digitalgift/repositories/register_service.dart'; // RegisterService'i import et

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();
  final RegisterService _registerService = RegisterService();
  bool _isSmsPermissionGranted = false;

  String? phoneChar;
  String? phoneCode;

  bool _isPhoneNumberValid(String phoneNumber) {
    final phoneRegex = RegExp(r'^\+?\d{8,}$'); // "+" ile başlayan en az 8 haneli numara
    return phoneRegex.hasMatch(phoneNumber);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hata'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Tamam'),
          ),
        ],
      ),
    );
  }

  Future<void> _register() async {
    if (!_isSmsPermissionGranted) {
      _showErrorDialog('SMS doğrulama iznini kabul etmelisiniz.');
      return;
    }

    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final repassword = _repasswordController.text.trim();
    final phoneNumber = phoneCode ?? '';
    final countryCode = phoneChar ?? '';

    if (name.isEmpty ||
        surname.isEmpty ||
        phoneNumber.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        repassword.isEmpty) {
      _showErrorDialog('Lütfen tüm alanları doldurun.');
      return;
    }

    if (!_isPhoneNumberValid(phoneNumber)) {
      _showErrorDialog('Telefon numarası 11 haneli ve "05" ile başlamalıdır.');
      return;
    }

    if (password != repassword) {
      _showErrorDialog('Şifreler eşleşmiyor.');
      return;
    }

    try {
      final result = await _registerService.register(
        name: name,
        surname: surname,
        phone: phoneNumber,
        phoneCode: countryCode,
        phoneChar: countryCode,
        password: password,
        repassword: repassword,
        email: email,
      );

      if (result['success']) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SMSVerificationPage(
              phoneNumber: phoneNumber, // Telefon numarasını geçir
            ),
          ),
        );
      } else {
        _showErrorDialog(result['message']);
      }
    } catch (e) {
      _showErrorDialog('Kayıt işlemi sırasında bir hata oluştu');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;

    return Scaffold(
      backgroundColor: Colors.green,
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          return Stack(
            children: [
              // Üst kısım
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.06,
                    left: screenSize.width * 0.08,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kayıt Ol',
                        style: TextStyle(
                          fontSize: isTablet ? 60 : 30, // Dinamik font boyutu
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      Text(
                        'Kayıt olarak şarkı/şiir siparişi vererek\nsevdiklerinizi mutlu edin.',
                        style: TextStyle(
                          fontSize: isTablet ? 36 : 18, // Dinamik font boyutu
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double buttonFontSize = constraints.maxWidth > 600 ? 28 : 14;
                    final double containerHeight =
                        isPortrait ? constraints.maxHeight * 0.7 : constraints.maxHeight * 0.75;

                    return Container(
                      width: constraints.maxWidth,
                      height: containerHeight,
                      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(constraints.maxWidth * 0.08)),
                      ),
                      child: SingleChildScrollView(
                        // Kaydırılabilir hale getirdik
                        child: Column(
                          children: [
                            SizedBox(height: screenSize.height * 0.02),
                            Container(
                              width: constraints.maxWidth * 0.9,
                              //  height: screenSize.height * 0.08,
                              padding: EdgeInsets.all(screenSize.width * 0.02),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(screenSize.width * 0.08),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => LoginPage()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[200],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(screenSize.width * 0.08),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenSize.width * 0.05,
                                      ),
                                    ),
                                    child: Text(
                                      'Giriş Yap',
                                      style: TextStyle(
                                        fontSize: buttonFontSize, // Dinamik font boyutu
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Kayıt olma işlemi
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(screenSize.width * 0.08),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenSize.width * 0.05,
                                      ),
                                    ),
                                    child: Text(
                                      'Kayıt Ol',
                                      style: TextStyle(
                                        fontSize: buttonFontSize, // Dinamik font boyutu
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            _buildTextField(_nameController, 'İsminiz', Icons.person, screenSize, isTablet),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            _buildTextField(_surnameController, 'Soyisminiz', Icons.person, screenSize, isTablet),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            _buildTextField(_emailController, 'E-posta', Icons.email, screenSize, isTablet),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            IntlPhoneField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'Telefon Numaranız',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(screenSize.width * 0.08),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05,
                                  vertical: isTablet ? screenSize.height * 0.02 : screenSize.height * 0.015,
                                ),
                              ),
                              initialCountryCode: 'TR', // Varsayılan olarak Türkiye
                              onChanged: (phone) {
                                setState(() {
                                  phoneChar = phone.countryCode; // Ülke kodu (ör. +90)
                                  phoneCode = phone.number; // Telefon numarası
                                });
                              },

                              onCountryChanged: (country) {
                                setState(() {
                                  phoneChar = '+${country.dialCode}'; // Ülke kodunu güncelle
                                });
                              },
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            _buildTextField(_passwordController, 'Şifre', Icons.lock, screenSize, isTablet,
                                obscureText: true),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            _buildTextField(_repasswordController, 'Şifre Tekrar', Icons.lock, screenSize, isTablet,
                                obscureText: true),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isSmsPermissionGranted,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isSmsPermissionGranted = value ?? false;
                                    });
                                  },
                                ),
                                Flexible(
                                  child: Text(
                                    'SMS doğrulaması için ileti gönderilmesine izin veriyorum.',
                                    style: TextStyle(
                                      fontSize: isTablet ? 20 : 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            Container(
                              width: screenSize.width * 0.9,
                              height: screenSize.height * 0.07, // Dinamik buton boyutu
                              child: ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(screenSize.width * 0.08),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.01,
                                    vertical: screenSize.height * 0.005,
                                  ),
                                ),
                                child: Text(
                                  'Kayıt Ol',
                                  style: TextStyle(
                                    fontSize: isTablet ? 28 : 20, // Dinamik font boyutu
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, Size screenSize, bool isTablet,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenSize.width * 0.08),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.05,
          vertical: isTablet ? screenSize.height * 0.02 : screenSize.height * 0.015,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.green,
          size: screenSize.width * 0.06, // Dinamik ikon boyutu
        ),
      ),
    );
  }
}
