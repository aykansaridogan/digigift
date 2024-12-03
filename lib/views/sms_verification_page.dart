import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // TextInputFormatter kullanımı için
import 'package:digitalgift/repositories/register_service.dart';
import 'package:digitalgift/views/login_page.dart';

class SMSVerificationPage extends StatefulWidget {
  final String phoneNumber;
  SMSVerificationPage({required this.phoneNumber});

  @override
  _SMSVerificationPageState createState() => _SMSVerificationPageState();
}

class _SMSVerificationPageState extends State<SMSVerificationPage> {
  // TextEditingController'lar her bir kutu için
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final RegisterService _registerService = RegisterService();

  Future<void> _verifySmsCode() async {
    final smsCode = _controllers.map((controller) => controller.text).join();
    if (smsCode.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen 4 haneli kodu girin.')),
      );
      return;
    }

    try {
      await _registerService.verifySmsCode(
        phone: widget.phoneNumber, // Telefon numarasını kullan
        smsCode: smsCode,
      );
      // Başarı mesajı göster veya başka bir sayfaya yönlendir
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('SMS kodu doğrulandı!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Doğrulama sırasında bir hata oluştu: $e')),
      );
    }
  }

  Future<void> _resendSmsCode() async {
    try {
      final result = await _registerService.resendSmsCode(
        phone: widget.phoneNumber,
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kod tekrar gönderildi!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kod gönderilirken bir hata oluştu: ${result['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tekrar gönderme sırasında bir hata oluştu: $e')),
      );
    }
  }

  @override
  void dispose() {
    // Controller'ları serbest bırak
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final textSize = screenSize.width * 0.05; // Dinamik yazı boyutu
    final containerHeight = screenSize.height * 0.1; // Dinamik yükseklik
    final buttonWidth = screenSize.width * 0.8; // Dinamik buton genişliği
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white, // Arka plan rengi
      appBar: AppBar(
        backgroundColor: Colors.green, // AppBar rengi
        elevation: 0, // Gölgeyi kaldır
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenSize.width * 0.05), // Dinamik padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Numaranızı Onaylayın',
              style: TextStyle(
                fontSize: textSize * 1.5, // Dinamik yazı boyutu
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenSize.height * 0.01), // Metinler arasında boşluk
            Text(
              'Lütfen size gönderdiğimiz dört haneli kodu giriniz.',
              style: TextStyle(
                fontSize: textSize,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenSize.height * 0.02), // Metin ile kutular arasına boşluk
            Text(
              'Numaranız: ${widget.phoneNumber}', // Telefon numarasını göster
              style: TextStyle(
                fontSize: textSize,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenSize.height * 0.03), // Metin ile kutular arasına boşluk
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: screenSize.width * 0.15, // Kutuların genişliği
                  height: containerHeight, // Kutuların yüksekliği
                  child: TextField(
                    controller: _controllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: textSize * 1.2, // Dinamik yazı boyutu
                      color: Colors.green, // Yazı rengi
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenSize.width * 0.04), // Oval kenarlar
                        borderSide: BorderSide(color: Colors.green), // Çerçeve rengi
                      ),
                      contentPadding: EdgeInsets.zero, // İç boşluğu kaldır
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Sadece rakamları kabul eder
                    ],
                    onChanged: (value) {
                      if (value.length == 1) {
                        int nextIndex = index + 1;
                        if (nextIndex < _controllers.length) {
                          // Bir sonraki kutuya geç
                          FocusScope.of(context).nextFocus();
                        } else {
                          // Son kutudaysak, klavyeyi kapat
                          FocusScope.of(context).unfocus();
                        }
                      }
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: screenSize.height * 0.03), // Kutular ile butonlar arasında boşluk

            Center(
              child: Text(
                'Kodu almadıysanız,',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: textSize,
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.02), // Kutular ile buton arasında boşluk
            Center(
              child: TextButton(
                onPressed: _resendSmsCode,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green, // Yazı rengi
                ),
                child: Text(
                  'Tekrar Gönder',
                  style: TextStyle(
                    fontSize: textSize,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.02), // Buton ile onayla butonu arasında boşluk
            Center(
              child: SizedBox(
                width: buttonWidth, // Buton genişliği
                child: ElevatedButton(
                  onPressed: _verifySmsCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Buton rengi
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenSize.width * 0.04), // Oval kenarlar
                    ),
                    padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02), // Buton boyutunu ayarlamak için
                  ),
                  child: Text(
                    'Onayla',
                    style: TextStyle(
                      fontSize: textSize,
                      color: Colors.white, // Yazı rengi
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: bottomPadding), // Klavye açıkken ek boşluk bırak
          ],
        ),
      ),
    );
  }
}
