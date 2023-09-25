import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:signal/pages/donate_amount_page/donate_page.dart';

class DonateViewModel{
  DonatePage? donatePage;
  final Razorpay razorpay = Razorpay();
  TextEditingController amountController = TextEditingController();
  DonateViewModel(this.donatePage);

  void startPayment(String enteredAmount) {
    try {
      double amount = double.tryParse(enteredAmount) ?? 0.0;
      if (amount <= 0.0) {
        print('Invalid amount entered.');
        return;
      }
      Map<String, dynamic> options = {
        'key': 'rzp_test_K1o4LePmukoNh8',
        'amount': (amount * 100).toInt(),
        'name': 'Firebase chat app',
        'description': 'Payment for an item',
        'prefill': {
          'contact': '9988776655',
          'email': 'test@razorpay.com',
        },
      };
      razorpay.open(options);
    } catch (e) {
      print("Error while making payment: $e");
    }
  }
}