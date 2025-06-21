import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedMethod;

  final List<Map<String, String>> paymentMethods = [
    {'label': 'Credit Card', 'value': 'credit_card'},
    {'label': 'QRIS Indonesia', 'value': 'qris'},
    {'label': 'Bank Transfer', 'value': 'bank_transfer'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Payment Method', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            ...paymentMethods.map((method) => RadioListTile<String>(
                  title: Text(method['label']!),
                  value: method['value']!,
                  groupValue: selectedMethod,
                  onChanged: (val) {
                    setState(() {
                      selectedMethod = val;
                    });
                  },
                )),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: selectedMethod == null
                    ? null
                    : () {
                        // Handle payment logic here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment successful!')),
                        );
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                child: const Text('Pay Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}