import 'package:flutter/material.dart';
import 'package:digitalgift/views/music_player.dart';
import '../models/payment_model.dart';
import '../repositories/payment_service.dart';

class MyPastOrderPage extends StatefulWidget {
  @override
  _MyPastOrderPageState createState() => _MyPastOrderPageState();
}

class _MyPastOrderPageState extends State<MyPastOrderPage> {
  late Future<PaymentResponse> _paymentsFuture;

  @override
  void initState() {
    super.initState();
    _paymentsFuture = PaymentsService().getPayments();
  }

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
            'Geçmiş Siparişlerim',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: FutureBuilder<PaymentResponse>(
          future: _paymentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 50),
                    SizedBox(height: 16),
                    Text(
                      'Geçmiş Siparişler Bulunamadı.',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: screenSize.width * 0.045,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final paymentResponse = snapshot.data!;
              if (!paymentResponse.success) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 50),
                      SizedBox(height: 16),
                      Text(
                        'Hata: ${paymentResponse.message ?? 'Bilgi yok'}',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: screenSize.width * 0.045,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              } else {
                final payments = paymentResponse.data.response;

                return ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final payment = payments[index];
                    return Card(
                      elevation: 6,
                      margin: EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    payment.productName,
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.05,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  payment.createdDate,
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.035,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Divider(color: Colors.grey[300], thickness: 1),
                            SizedBox(height: 8.0),
                            Text(
                              'Fiyat: ${payment.price} TL',
                              style: TextStyle(
                                fontSize: screenSize.width * 0.045,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (payment.answerFile != null ||
                                payment.answerPicture != null ||
                                payment.answerText != null) ...[
                              SizedBox(height: 16.0),
                              if (payment.answerFile != null)
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MusicPlayerPage(musicPath: payment.answerFile!),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.music_note, color: Colors.white),
                                  label: Text('Siparişi Dinle'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                              if (payment.answerText != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      'Yanıt: ${payment.answerText}',
                                      style: TextStyle(
                                        fontSize: screenSize.width * 0.04,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              if (payment.answerPicture != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.network(
                                      payment.answerPicture!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: screenSize.width * 0.5,
                                    ),
                                  ),
                                ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              return Center(
                child: Text(
                  'Bilgi yok',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: screenSize.width * 0.045,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
