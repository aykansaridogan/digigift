import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:digitalgift/repositories/login_service.dart'; // LoginService import edin
import 'package:digitalgift/views/forgot_password_page.dart';
import 'package:digitalgift/views/register_page.dart';
import 'package:digitalgift/views/home_page.dart'; // HomePage import edin
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginService _loginService = LoginService();
  bool _isChecked = true; // Başlangıç durumu
  SharedPreferences? _prefs;

  String? phoneChar; // Telefon numarasını saklamak için
  String? phoneCode; // Ülke kodunu saklamak için

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    final rememberToken = _prefs?.getString('remember_token'); // rememberToken'ı al

    if (rememberToken != null) {
      _autoLogin(rememberToken); // rememberToken ile otomatik giriş yap
    }
  }

  Future<void> _autoLogin(String token) async {
    try {
      final result = await _loginService.autoLogin(token);
      if (result['success']) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      print("Otomatik giriş başarısız: $e");
    }
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

  bool _isPhoneNumberValid(String phone) {
    final phoneRegex = RegExp(r'^5\d{9}$'); // "5" ile başlayan ve toplam 11 haneli numara
    return phoneRegex.hasMatch(phone);
  }

  Future<void> _login() async {
    final phone = phoneChar != null && phoneCode != null
        ? '$phoneChar$phoneCode' // Telefon numarası birleşik şekilde
        : '';
    final password = _passwordController.text;

    if (!_isPhoneNumberValid(phone)) {
      _showErrorDialog('Telefon numarası 10 haneli ve "5" ile başlamalıdır.');
      return;
    }
    if (password.isEmpty) {
      _showErrorDialog('Lütfen şifre alanını doldurun.');
      return;
    }

    try {
      final result = await _loginService.login(
        phone: phone,
        password: password,
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Giriş başarılı!')),
        );

        if (_isChecked) {
          await _prefs?.setString('bearerToken', result['token']);
        }

        // Başarıyla giriş yaptıktan sonra yönlendirme
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()), // Ana sayfaya yönlendirme
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Giriş başarısız')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş sırasında bir hata oluştu')),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;

    return Scaffold(
      backgroundColor: Colors.green, // Arka plan rengi
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
                    top: screenSize.height * 0.12,
                    left: screenSize.width * 0.08,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hoşgeldiniz!',
                        style: TextStyle(
                          fontSize: isTablet ? 60 : 30, // Dinamik font boyutu
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.01), // Dinamik boşluk
                      Text(
                        'Giriş yap ve hemen siparişini oluştur!',
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
                        isPortrait ? constraints.maxHeight * 0.5 : constraints.maxHeight * 0.7;

                    return Container(
                      width: constraints.maxWidth,
                      height: containerHeight,
                      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(constraints.maxWidth * 0.08)),
                      ),
                      child: SingleChildScrollView(
                        // Scroll için eklendi
                        child: Column(
                          children: [
                            SizedBox(height: constraints.maxHeight * 0.02),
                            Container(
                              width: constraints.maxWidth * 0.9,
                              padding: EdgeInsets.all(constraints.maxWidth * 0.02),
                              decoration: BoxDecoration(
                                color: Colors.grey[200], // Gri arka plan rengi
                                borderRadius: BorderRadius.circular(constraints.maxWidth * 0.08),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: ElevatedButton(
                                      onPressed: _login, // Giriş yapma işlemi
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white, // Buton rengi
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(constraints.maxWidth * 0.08),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: constraints.maxWidth * 0.05,
                                        ),
                                      ),
                                      child: FittedBox(
                                        //  fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Giriş Yap',
                                          style: TextStyle(fontSize: buttonFontSize, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: constraints.maxWidth * 0.02), // Butonlar arasında boşluk
                                  Flexible(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => RegisterPage()),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.grey[200], // Buton rengi
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(constraints.maxWidth * 0.08),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: constraints.maxWidth * 0.05,
                                        ),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Kayıt Ol',
                                          style: TextStyle(fontSize: buttonFontSize, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            IntlPhoneField(
                              decoration: InputDecoration(
                                labelText: 'Telefon Numarası',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(screenSize.width * 0.08),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05,
                                  vertical: isTablet ? screenSize.height * 0.02 : screenSize.height * 0.015,
                                ),
                              ),
                              initialCountryCode: 'TR',
                              onChanged: (phone) {
                                setState(() {
                                  phoneChar = phone.number;
                                  phoneCode = phone.countryCode;
                                });
                              },
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            TextField(
                              controller: _passwordController,
                              obscureText: true, // Şifre girişini gizler
                              decoration: InputDecoration(
                                labelText: 'Şifre',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(screenSize.width * 0.08), // Kenarları ovalleştir
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.05,
                                  vertical: isTablet ? screenSize.height * 0.02 : screenSize.height * 0.015,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock, // Kilit ikonu
                                  color: Colors.green, // İkon rengi
                                  size: screenSize.width * 0.06,
                                ),
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _isChecked = value!;
                                        });
                                      },
                                      activeColor: Colors.green, // Checkbox'ın tik rengi
                                      checkColor: Colors.white, // Tik işaretinin rengi
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    Text(
                                      'Beni hatırla',
                                      style: TextStyle(fontSize: isTablet ? 28 : 20),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                                    );
                                  },
                                  child: Text(
                                    'Şifremi unuttum',
                                    style: TextStyle(
                                      fontSize: isTablet ? 28 : 20,
                                      color: Colors.green, // Yazı rengi
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
                                onPressed: _login, // Giriş Yap işlemi
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green, // Buton rengi
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(screenSize.width * 0.08),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.01,
                                    vertical: screenSize.height * 0.005,
                                  ),
                                ),
                                child: Text(
                                  'Giriş Yap', // Buton üzerindeki metin
                                  style: TextStyle(
                                    fontSize: isTablet ? 28 : 20, // Dinamik yazı boyutu
                                    color: Colors.white, // Yazı rengi
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
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
}
