import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../repositories/product_detail_service.dart';

class PurchasePage extends StatefulWidget {

    final String orderCode;

   const PurchasePage({Key? key, required this.orderCode}) : super(key: key);

  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final List<String> _productIds = [
    'sarki_999_standart',
    'sarki_1999_premium',
    'sarki_5999_premiumplus'
  ];


  late InAppPurchase _inAppPurchase;
  bool _loading = true;
  List<ProductDetails> _products = [];
  String googleApiKey = "goog_FIOSYCinbeNZasEyQdtHQXXkZZw";
 final ProductDetailService _productDetailService = ProductDetailService();

  @override
  void initState() {
    super.initState();
    _initializeInAppPurchase();
        // Satın alma işlemi dinleyicisi ekle
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    purchaseUpdated.listen((purchaseDetailsList) {
      _handlePurchaseUpdates(purchaseDetailsList);
    });
  }

  Future<void> _initializeInAppPurchase() async {
     try {
    _inAppPurchase = InAppPurchase.instance;
    final isAvailable = await _inAppPurchase.isAvailable();
    if (isAvailable) {
      // Fetch products from Google Play
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(_productIds.toSet());

      if (response.error != null) {
        print("Ürün sorgulama hatası: ${response.error}");
      }

      if (response.productDetails.isEmpty) {
        print("Hiçbir ürün bulunamadı");
      }
      setState(() {
        _loading = false;
        _products = response.productDetails;
      });
    } else {
            print("Uygulama içi satın alma kullanılabilir değil");

      setState(() {
        _loading = false;
      });
    }
     }
    catch (error) {
    print("Hata oluştu: $error");
    setState(() {
      _loading = false;
    });
  }
  }

  void _buyProduct(ProductDetails product) {
    final purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }
 void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        // Satın alma başarılı oldu, API'ye order_code gönderiyoruz
        await _productDetailService.sendPaymentTransactionEnd(widget.orderCode);
        
        // Sipariş başarılı olduğunda kullanıcıya mesaj gösteriyoruz
        _showSuccessDialog();
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        print("Satın alma işlemi başarısız oldu: ${purchaseDetails.error}");
      }
    }
  }

void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Sipariş Başarılı!'),
      content: Text('Siparişiniz başarıyla alınmıştır.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dialog'u kapat
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', // İlk sayfanın route adı
              (Route<dynamic> route) => false, // Tüm route'ları temizler
            );
          },
          child: Text('Tamam'),
        ),
      ],
    ),
  );
}



void _simulateSuccessfulPurchase() async {
  // Satın alma işlemi başarılı olarak simüle ediliyor
  PurchaseDetails simulatedPurchase = PurchaseDetails(
    productID: 'android.test.purchased',
    status: PurchaseStatus.purchased,
    verificationData: PurchaseVerificationData(
      localVerificationData: 'SimulatedData',
      serverVerificationData: 'SimulatedServerData',
      source: 'google_play', // Satın alma kaynağını manuel olarak ayarlayın
    ),
    transactionDate: DateTime.now().millisecondsSinceEpoch.toString(),
  );

  // Satın alma işlemi dinleyicisine sahte satın alma işlemi gönderiliyor
   _handlePurchaseUpdates([simulatedPurchase]);

  // Satın alma işlemi başarılı olduğunda API'ye orderCode gönderiliyor
  await _productDetailService.sendPaymentTransactionEnd(widget.orderCode);

  // API çağrısı başarılı olduktan sonra kullanıcıya mesaj gösteriyoruz
  _showSuccessDialog();
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {Navigator.of(context).pop();},
              icon: Icon(
                Icons.chevron_left,
                size: 32,
                color: Colors.white,
              )),
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
          title: Text('Paketlerimiz' , style: TextStyle(color: Colors.white)),
      ),
       body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                    return ListTile(
  title: Text(product.title),
  subtitle: Text(product.description),
  trailing: Container(
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
      borderRadius: BorderRadius.circular(8), // Köşeleri yuvarla
    ),
    child: ElevatedButton(
      onPressed: () => _buyProduct(product),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // Butonun varsayılan arka planını kaldır
        shadowColor: Colors.transparent, // Gölgeyi kaldır
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Text(
          'Satın Al',
          style: TextStyle(
            color: Colors.white, // Metin rengini beyaz yap
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ),
);

                    },
                  ),
                ),
              /*  // Simülasyon butonunu ekliyoruz
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _simulateSuccessfulPurchase,
                    child: Text('Satın Almayı Simüle Et'),
                  ),
                ), */
              ],
            ),
    );
  }
}