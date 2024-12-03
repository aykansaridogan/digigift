import 'package:flutter/material.dart';
import '../models/faq_model.dart';
import '../repositories/faq_service.dart';

class SSSPage extends StatefulWidget {
  @override
  _SSSPageState createState() => _SSSPageState();
}

class _SSSPageState extends State<SSSPage> {
  late Future<FAQResponse> _faqsFuture;

  @override
  void initState() {
    super.initState();
    _faqsFuture = FAQsService().getFAQs();
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
      'Sık Sorulan Sorular',
      style: TextStyle(color: Colors.white),
    ),
    centerTitle: true,
    elevation: 0,
  ),
),

      body: Container(
        color: Colors.white,
        child: FutureBuilder<FAQResponse>(
          future: _faqsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.success) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 50),
                    SizedBox(height: 16),
                    Text(
                      'Hata: ${snapshot.data?.message ?? 'Bilgi yok'}',
                      style: TextStyle(color: Colors.black54, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else {
              final faqs = snapshot.data!.data.response;

              return ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Text(
                                  faq.order.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: Text(
                                  faq.question,
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.0),
                          AnimatedSize(
                            duration: Duration(milliseconds: 200),
                            child: Text(
                              faq.answer,
                              style: TextStyle(
                                fontSize: screenSize.width * 0.04,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
