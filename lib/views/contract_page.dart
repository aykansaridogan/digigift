import 'package:flutter/material.dart';
import '../models/contract_model.dart'; // Veri modelini doğru yolla ekleyin
import '../repositories/contracts_service.dart'; // Servis yolunu güncelleyin
import 'package:html/parser.dart' as html_parser;

class ContractPage extends StatefulWidget {
  @override
  _ContractPageState createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  late Future<Map<String, dynamic>> _contractsFuture;

  @override
  void initState() {
    super.initState();
    _contractsFuture = ContractsService().getContracts(); // Verileri al
  }

  String _parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text('Üyelik Sözleşmesi', style: TextStyle(color: Colors.white)),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _contractsFuture,
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
            final data = snapshot.data!['data'];
            final contracts = (data['response'] as List)
                .map((item) => Contract.fromJson(item))
                .toList();

            return ListView.builder(
              itemCount: contracts.length,
              itemBuilder: (context, index) {
                final contract = contracts[index];
                final plainTextDescription = _parseHtmlString(contract.description);

                return ListTile(
                  title: Text(contract.name),
                  subtitle: Text(plainTextDescription),
                );
              },
            );
          }
        },
      ),
    );
  }
}
