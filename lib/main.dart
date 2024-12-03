import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:digitalgift/repositories/purchase_api.dart';
import 'package:digitalgift/views/home_page.dart';
import 'package:digitalgift/views/login_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Purchases.configure(PurchasesConfiguration(google_api_key));

  runApp(
    DevicePreview(
      builder: (context) => MyApp(), // Uygulamanız burada başlatılır
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Gift',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/', // Uygulamanın başlangıç rotası
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
