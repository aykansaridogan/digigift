import 'package:flutter/material.dart';
import 'package:digitalgift/views/payment_page.dart';
import '../repositories/product_detail_service.dart';
import '../models/api_response.dart';

class ProductPage extends StatefulWidget {
  final int productId;

  const ProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<ApiResponse> _apiResponse;
  final Map<int, String> textInputAnswers = {};
  final Map<int, int?> selectedAnswers = {}; // Nullable int için
  List<int> selectedFeatures = []; // Seçilen özellikleri izleme
  double? calculatedPrice;

  @override
  void initState() {
    super.initState();
    _apiResponse = ProductDetailService().fetchProductData(widget.productId);
  }

  Future<void> _submitAnswers() async {
    try {
      await _calculatePrice();
      // Seçilen özellikleri ve cevapları hazırlıyoruz
      final List<int> features = selectedFeatures;
      final Map<int, String?> textAnswers = {};
      final Map<int, int?> selectAnswers = {};

      // API'ye istek atıyoruz ve orderCode'u alıyoruz
      final String? orderCode = await ProductDetailService().submitAnswers(
        widget.productId,
        features,
        textAnswers,
        selectAnswers,
      );

      if (orderCode != null) {
        // Başarılı mesajı gösteriyoruz
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cevaplarınız başarıyla kaydedildi! Sipariş kodu: $orderCode')),
        );

        // Ödeme sayfasına yönlendiriyoruz
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPage(
              price: calculatedPrice ?? 0.0, // Varsayılan fiyat kullanılıyor
              textInputAnswers: textInputAnswers,
              selectedAnswers: selectedAnswers,
              orderCode: orderCode,
            ),
          ),
        );
      } else {
        throw Exception('Sipariş kodu alınamadı.');
      }
    } catch (e) {
      // Hata mesajı gösteriyoruz
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: ${e.toString()}')),
      );
    }
  }

  Future<void> _calculatePrice() async {
    try {
      final double price = await ProductDetailService().calculatePrice(
        widget.productId,
        selectedFeatures,
      );

      setState(() {
        calculatedPrice = price;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fiyat başarıyla hesaplandı: $price TL')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: ${e.toString()}')),
      );
    }
  }

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
          'Ürün Detayları',
          style: TextStyle(color: Colors.white), // Beyaz metin
        ),
      ),
      body: FutureBuilder<ApiResponse>(
        future: _apiResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.success) {
            return Center(child: Text('Veri bulunamadı.'));
          }

          final data = snapshot.data!.data;
          final product = data.response; // ResponseData erişimi
          final features = data.features; // List<Feature>
          final questionsListArr = data.questionsListArr; // List<Question>

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  product.description,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Fiyat: ${calculatedPrice != null ? calculatedPrice.toString() + ' TL' : product.price.toString() + ' TL'}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Özellikler:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...features.map((feature) {
                  return ListTile(
                    title: Text(
                      feature.name,
                      style: TextStyle(color: Colors.black), // Yeşil metin
                    ),
                    subtitle: Text(
                      feature.description,
                      style: TextStyle(color: Colors.black), // Yeşil metin
                    ),
                    trailing: Checkbox(
                      value: selectedFeatures.contains(feature.id),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedFeatures.add(feature.id);
                          } else {
                            selectedFeatures.remove(feature.id);
                          }
                        });
                        _calculatePrice(); // Fiyatı yeniden hesapla
                      },
                    ),
                  );
                }).toList(),
                SizedBox(height: 16),
                Text(
                  'Sorular:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...questionsListArr.map((question) {
                  if (question.type == 'input') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.question,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Cevabınızı girin',
                              hintStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 1.0),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                textInputAnswers[question.id] = value;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  } else if (question.type == 'select') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.question,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            value: selectedAnswers[question.id],
                            items: question.answers?.map((answer) {
                                  return DropdownMenuItem<int>(
                                    value: answer.id,
                                    child: Text(answer.answer),
                                  );
                                }).toList() ??
                                [],
                            onChanged: (value) {
                              setState(() {
                                selectedAnswers[question.id] = value;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox(); // Boş bir alan döndürmek daha iyi olabilir
                  }
                }).toList(),
                SizedBox(height: 16),
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
                    borderRadius: BorderRadius.circular(8), // Butonun köşelerini yuvarla
                  ),
                  child: ElevatedButton(
                    onPressed: _submitAnswers,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      backgroundColor: Colors.transparent, // Butonun arka plan rengini şeffaf yap
                      shadowColor: Colors.transparent, // Gölgeyi kaldır
                    ),
                    child: Text(
                      'Kaydet Ve Ödeme Sayfasına Geç',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Metin rengini beyaz yap
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
