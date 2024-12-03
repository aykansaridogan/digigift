import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
  preferredSize: Size.fromHeight(kToolbarHeight),
  child: AppBar(
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple,
            Colors.pink,
            Colors.orange,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    title: Text(
      'Geri Bildirim',
      style: TextStyle(color: Colors.white),
    ),
    centerTitle: true,
    elevation: 0,
  ),
),

      body:  SingleChildScrollView( // Scroll ekleniyor
        child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0), // Yuvarlatılmış köşeler
                child: Image.asset(
                  'assets/Sarkiyapp.png', // Uygulama logosu
                  width: screenSize.width * 0.3, // Genişlik ekran boyutuna göre ayarlanır
                  height: screenSize.width * 0.3, // Yükseklik ekran boyutuna göre ayarlanır
                  fit: BoxFit.cover, // Görüntüyü tam olarak gösterir
                ),
              ),
              SizedBox(height: 30),
              Text(
                'WhatsApp Destek Hattı',
                style: TextStyle(
                  fontSize: screenSize.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '+905335261132',
                style: TextStyle(
                  fontSize: screenSize.width * 0.045,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 30),
   Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.pink,
                        Colors.orange,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final Uri whatsappUri = Uri(
                        scheme: 'https',
                        host: 'api.whatsapp.com',
                        path: 'send',
                        queryParameters: <String, String>{
                          'phone': '+905335261132',
                        },
                      );

                      if (await canLaunchUrl(whatsappUri)) {
                        await launchUrl(whatsappUri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('WhatsApp uygulaması bulunamadı')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.transparent, // Arka plan şeffaf
                      shadowColor: Colors.transparent, // Gölge kaldırıldı
                    ),
                    icon: Icon(Icons.chat, color: Colors.white),
                      label: Text(
      'Canlı Destek',
      style: TextStyle(color: Colors.white), // Yazı beyaz
    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FeedbackPage(),
  ));
}
