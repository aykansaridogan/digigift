import 'package:flutter/material.dart';
import 'package:digitalgift/repositories/product_service.dart';
import 'package:digitalgift/views/product_page.dart';
import 'account_page.dart';
import 'drawer_page.dart';
import 'music_player.dart';
import '../models/product_response.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: {
        '/account': (context) => AccountPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Seçili olan ikonun indeksi
  late Future<ProductResponse> _futureProductData;

  @override
  void initState() {
    super.initState();
    _futureProductData = ProductService().fetchProducts(); // API'den veri çek
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AccountPage()),
      );
    }
  }

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      label: 'Hesap',
    ),
  ];

  void _onContainerTapped(int productId) {
    print('Tapped Product ID: $productId');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(productId: productId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ANA SAYFA',
          style: TextStyle(fontSize: screenSize.width * 0.05), // Dinamik yazı boyutu
        ),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            icon: const Icon(Icons.menu), // Drawer simgesi
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Drawer'ı açma
            },
          ),
        ),
      ),
      drawer: const CustomDrawer(), // Drawer olarak DrawerPage'i ekliyoruz
      body: LayoutBuilder(builder: (context, constraints) {
        return FutureBuilder<ProductResponse>(
          future: _futureProductData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              var products = snapshot.data!.products;

              if (products.isEmpty) {
                return Center(child: Text('No Products Available'));
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: screenSize.height * 0.02),
                    ...products.map((product) {
                      Color containerColor = _hexToColor(product.backColor ?? '#FFFFFF');
                      Color textColor = _hexToColor(product.foreColor ?? '#000000');
                      return Column(
                        children: [
                          _buildContainer(
                            "Yeni Sipariş Oluştur",
                            '${product.name} Siparişi',
                            // 'Ortalama ${product.description} Günde Teslim',
                            product.description,
                            containerColor,
                            textColor,
                            product.id,
                          ),
                          SizedBox(height: 5),
                          _buildSectionTitle(product.name, screenSize),
                          _buildListView(
                            product.examples.map((example) {
                              return _buildExampleItem(
                                product.name,
                                example.file,
                                example.iconColor,
                                screenSize,
                              );
                            }).toList(),
                            screenSize,
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No Data Available'));
            }
          },
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildContainer(
      String title, String subtitle, String description, Color backColor, Color foreColor, int productId) {
    final screenSize = MediaQuery.of(context).size;
    final bool isPortrait = screenSize.height > screenSize.width;

    // Ekran boyutuna göre dinamik yükseklik ve genişlik
    double containerHeight = isPortrait ? screenSize.height * 0.19 : screenSize.height * 0.5;
    double containerPadding = isPortrait ? screenSize.width * 0.03 : screenSize.width * 0.02;
    double fontSizeTitle = isPortrait ? screenSize.width * 0.045 : screenSize.width * 0.035;
    double fontSizeSubtitle = isPortrait ? screenSize.width * 0.04 : screenSize.width * 0.03;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      child: GestureDetector(
        onTap: () => _onContainerTapped(productId),
        child: Container(
          width: double.infinity,
          height: containerHeight,
          decoration: BoxDecoration(
            color: backColor,
            borderRadius: BorderRadius.circular(screenSize.width * 0.04),
          ),
          child: Padding(
            padding: EdgeInsets.all(containerPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: foreColor,
                    fontSize: fontSizeTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.005),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: foreColor,
                    fontSize: fontSizeSubtitle,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.005),
                Flexible(
                  child: Text(
                    description, // Metni burada Text widget'ında gösterebilirsiniz
                    maxLines: 4, // İsteğe bağlı: metnin maksimum kaç satır gösterileceğini belirler
                    overflow: TextOverflow.ellipsis, // Uzun metni '...' ile keser
                    softWrap: true,
                    style: TextStyle(color: foreColor, fontSize: screenSize.width * 0.03),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _hexToColor(String hexCode) {
    if (hexCode == null || hexCode.isEmpty) {
      return Colors.grey;
    }
    return Color(int.parse(hexCode.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Widget _buildSectionTitle(String title, Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenSize.width * 0.045,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListView(List<Widget> items, Size screenSize) {
    return SizedBox(
      height: screenSize.height * 0.2,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
        children: items,
      ),
    );
  }

  Widget _buildExampleItem(String name, String fileUrl, String? iconColor, Size screenSize) {
    return ListTile(
      title: Text(
        'Deneme ${name}', // URL'nin son kısmını gösteriyoruz
        style: TextStyle(
          fontSize: screenSize.width * 0.045,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.play_circle, color: _hexToColor(iconColor ?? '#000000'), size: screenSize.width * 0.07),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MusicPlayerPage(musicPath: fileUrl),
            ),
          );
        },
      ),
    );
  }
}
