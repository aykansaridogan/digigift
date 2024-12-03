import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/user_profile_service.dart';
import 'login_page.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Future<Map<String, dynamic>> _profileFuture;
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _token;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('remember_token');
    
    if (_token == null) {
      // Token bulunamazsa giriş yapması için kullanıcıyı uyar
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lütfen Giriş Yapın'),
            content: Text('Hesap bilgilerinize erişebilmek için giriş yapmanız gerekmektedir.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dialog'u kapat
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Giriş Yap'),
              ),
            ],
          );
        },
      );
    } else {
      // Token varsa profil bilgilerini getir
      _profileFuture = ProfileService().getProfile();
      setState(() {});
    }
  }

  Future<void> _updateProfile() async {
    final profileService = ProfileService();
    final result = await profileService.updateProfile(
      name: _nameController.text,
      surname: _surnameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    );

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
      setState(() {
        _profileFuture = ProfileService().getProfile();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Güncelleme başarısız: ${result['message']}')),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      final profileService = ProfileService();
      final result = await profileService.logout();

      if (result['success']) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('remember_token');

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Oturum kapatma başarısız: ${result['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Oturum kapatma sırasında bir hata oluştu: $e')),
      );
    }
  }

  void _showUpdateProfileDialog(Map<String, dynamic> data) {
    _nameController.text = data['name'];
    _surnameController.text = data['surname'];
    _emailController.text = data['email'];
    _phoneController.text = data['phone'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Profil Güncelle'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Ad',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _surnameController,
                  decoration: InputDecoration(
                    labelText: 'Soyad',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-posta',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
       
        actions: [
  TextButton(
    onPressed: () {
      Navigator.of(context).pop();
    },
    child: Text('İptal'),
  ),
  
  // Güncelle Butonu
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
      borderRadius: BorderRadius.circular(8),
    ),
    child: ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        _updateProfile();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // Arka plan şeffaf
        shadowColor: Colors.transparent, // Gölgeyi kaldırıyoruz
      ),
      child: Text(
        'Güncelle',
        style: TextStyle(color: Colors.white), // Yazıyı beyaz yapıyoruz
      ),
    ),
  ),
],

        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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
          title: Text('Profil Bilgileri', style: TextStyle(color: Colors.white)),
        ),
      ),

      body: _token == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder<Map<String, dynamic>>(
              future: _profileFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || snapshot.data == null || !(snapshot.data!['success'] ?? false)) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 50),
                        SizedBox(height: 16),
                        Text(
                          'Hata: ${snapshot.data?['message'] ?? 'Bilgi yok'}',
                          style: TextStyle(color: Colors.black54, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else {
                  final data = snapshot.data!['data']['response'];
                  return ListView(
                    padding: EdgeInsets.all(16.0),
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset(
                            'assets/Sarkiyapp.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      ListTile(
                        leading: Icon(Icons.account_circle, color: Colors.black),
                        title: Text(
                          'Adı: ${data['name']} ${data['surname']}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      ListTile(
                        leading: Icon(Icons.phone, color: Colors.black),
                        title: Text(
                          'Telefon: ${data['phone']}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      ListTile(
                        leading: Icon(Icons.email, color: Colors.black),
                        title: Text(
                          'E-posta: ${data['email']}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
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
    borderRadius: BorderRadius.circular(8),
  ),
  child: ElevatedButton.icon(
    onPressed: () => _showUpdateProfileDialog(data),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Colors.transparent, // Arka plan şeffaf
      shadowColor: Colors.transparent, // Gölge kaldırıldı
    ),
    icon: Icon(Icons.edit, color: Colors.white),
    label: Text(
      'Profil Bilgilerini Güncelle',
      style: TextStyle(color: Colors.white),
    ),
  ),
),

                      SizedBox(height: screenHeight * 0.02),
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
    borderRadius: BorderRadius.circular(8),
  ),
  child: ElevatedButton.icon(
    onPressed: () => _logout(context),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Colors.transparent, // Arka plan şeffaf
      shadowColor: Colors.transparent, // Gölge kaldırıldı
    ),
    icon: Icon(Icons.logout, color: Colors.white),
    label: Text(
      'Oturumu Kapat',
      style: TextStyle(color: Colors.white),
    ),
  ),
),
                    ],
                  );
                }
              },
            ),
    );
  }
}
