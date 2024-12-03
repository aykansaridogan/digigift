import 'package:flutter/material.dart';

import '../repositories/calculate_service.dart';

class OrderCalculationPage extends StatefulWidget {
  @override
  _OrderCalculationPageState createState() => _OrderCalculationPageState();
}

class _OrderCalculationPageState extends State<OrderCalculationPage> {
  double? calculatedAmount;
  bool isLoading = false;

  final TextEditingController _amountController = TextEditingController();

  void _calculateOrder() async {
    setState(() {
      isLoading = true;
    });

    final body = {
      'amount': _amountController.text,
      // Diğer gerekli parametreleri buraya ekleyin
    };

    calculatedAmount = await calculateOrder('https://www.digitalgift.com.tr/api', body);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ödeme Hesaplama'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Tutarı Girin',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _calculateOrder,
              child: isLoading
                  ? CircularProgressIndicator(
                color: Colors.white,
              )
                  : Text('Hesapla'),
            ),
            SizedBox(height: 32),
            if (calculatedAmount != null)
              Text(
                'Hesaplanan Tutar: ₺$calculatedAmount',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
