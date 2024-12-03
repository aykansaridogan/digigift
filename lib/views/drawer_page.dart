import 'package:flutter/material.dart';
import 'package:digitalgift/views/contract_page.dart';
import 'package:digitalgift/views/feedback_page.dart';
import 'package:digitalgift/views/my_past_order_page.dart';
import 'package:digitalgift/views/sss_page.dart';

import 'account_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent, // Arka planı şeffaf yapıyoruz
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0), // Kenar yuvarlatma
                    child: Container(
                      width: 80.0, // Dinamik genişlik
                      height: 80.0, // Dinamik yükseklik
                      decoration: BoxDecoration(
                        color: Colors.white, // Arka plan rengi
                        borderRadius: BorderRadius.circular(20.0), // Kenar yuvarlatma
                      ),
                      child: Image.asset(
                        'assets/Sarkiyapp.png', // Resim dosyasının yolu
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0), // Boşluk
                  Text(
                    'Şarkı Yapp',
                    style: TextStyle(
                      fontSize: 24.0, // Metin boyutu
                      fontWeight: FontWeight.bold, // Metin kalınlığı
                      color: Colors.white, // Metin rengi
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.white),
              title: const Text(
                'Bilgilerim',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.white),
              title: const Text(
                'Geçmiş Siparişlerim',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPastOrderPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.white),
              title: const Text(
                'Sıkça Sorulan Sorular',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SSSPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.white),
              title: const Text(
                'Üyelik Sözleşmesi',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContractPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback, color: Colors.white),
              title: const Text(
                'Geri Bildirim',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedbackPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
