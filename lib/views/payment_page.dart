import 'package:flutter/material.dart';
import 'purchase_page.dart'; 
class PaymentPage extends StatelessWidget {

  final double price;
  final Map<int, String?> textInputAnswers;
  final Map<int, int?> selectedAnswers;
  final String orderCode; 
  const PaymentPage({
    Key? key,
    required this.price,
    required this.textInputAnswers,
    required this.selectedAnswers,
    required this.orderCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          'Ödeme Ekranı',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Yazı rengini beyaz yapıyoruz
          ),
        ),
        centerTitle: true,
      
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductDetails(),
            Divider(color: Colors.black, thickness: 1), // İnce ayırıcı
            _buildAnswersSection('Girdiğiniz Cevaplar', textInputAnswers, selectedAnswers),
            Spacer(),
            _buildCompletePaymentButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Siparişiniz',
          style: TextStyle(
            color: Colors.black, // Yeşil metin
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Fiyat: $price TL',
          style: TextStyle(
            color: Colors.black, // Yeşil metin
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAnswersSection(
      String title,
      Map<int, String?> textInputAnswers,
      Map<int, int?> selectedAnswers,
      ) {
    return Expanded(
      child: ListView(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black, // Yeşil metin
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          ..._buildAnswerTiles(textInputAnswers),
          ..._buildSelectedAnswerTiles(selectedAnswers),
        ],
      ),
    );
  }

  List<Widget> _buildAnswerTiles(Map<int, String?> textInputAnswers) {
    return textInputAnswers.entries.map((entry) {
      return ListTile(
        title: Text(
          'Soru ${entry.key}:',
          style: TextStyle(
            color: Colors.black, // Yeşil metin
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          entry.value ?? "Boş",
          style: TextStyle(color: Colors.black), // Yeşil metin
        ),
      );
    }).toList();
  }

  List<Widget> _buildSelectedAnswerTiles(Map<int, int?> selectedAnswers) {
    return selectedAnswers.entries.map((entry) {
      return ListTile(
        title: Text(
          'Soru ${entry.key}:',
          style: TextStyle(
            color: Colors.black, // Yeşil metin
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          entry.value?.toString() ?? "Seçilmedi",
          style: TextStyle(color: Colors.black), // Yeşil metin
        ),
      );
    }).toList();
  }
/*
Widget _buildCompletePaymentButton(BuildContext context) {
  return Container(
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
      borderRadius: BorderRadius.circular(10), // Köşeleri yuvarla
    ),
    child: ElevatedButton.icon(
      onPressed: () {
        // Ödeme işlemini başlat
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ödeme başlatıldı!')),
        );
      },
      icon: Icon(Icons.payment, color: Colors.white),
label: Text(
  'Ödemeyi Tamamla',
  style: TextStyle(color: Colors.white), // Metin rengini beyaz yap
),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Colors.transparent, // Butonun arka planını şeffaf yap
        shadowColor: Colors.transparent, // Gölgeyi kaldır
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Düğme köşelerini yuvarlama
        ),
      ),
    ),
  );
}

}
*/
  Widget _buildCompletePaymentButton(BuildContext context) {
    return Container(
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
        borderRadius: BorderRadius.circular(10), // Köşeleri yuvarla
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          // Ödeme işlemi için PurchasePage'e yönlendir
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PurchasePage(orderCode: orderCode),
            ),
          );
        },
        icon: Icon(Icons.payment, color: Colors.white),
        label: Text(
          'Ödemeyi Tamamla',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}