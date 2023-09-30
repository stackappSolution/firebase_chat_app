import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/toast_util.dart';
import 'package:signal/pages/donate_amount_page/donate_page.dart';
import 'package:signal/service/users_service.dart';

import '../../modal/transaction_model.dart';

class DonateViewModel {
  DonatePage? donatePage;
  int totalAmount = 0;
  final Razorpay razorpay = Razorpay();
  List<TransactionsModel> transactionList = [];
  String? currentPaymentId;
  final TextEditingController amountController = TextEditingController();
  double paymentAmount = 0.0;
  double totalHistoryAmount = 0.00;

  DonateViewModel(this.donatePage);

  void startPayment(String enteredAmount) {
    try {
      double amount = double.tryParse(enteredAmount) ?? 0.0;
      if (amount <= 0.0) {
        print('Invalid amount entered.');
        return;
      }
      paymentAmount = double.parse(amount.toString());
      Map<String, dynamic> options = {
        'key': 'rzp_test_2i5UDQ1QbbE3lg',
        'amount': (amount * 100).toInt(),
        'name': 'Naimishtanti',
        'description': 'watch',
        'prefill': {
          'contact': FirebaseAuth.instance.currentUser!.phoneNumber,
          'email': 'hello@razorpay@gmail.com',
        },
      };
      razorpay.open(options);
    } catch (e) {
      print("Error while making payment: $e");
    }
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm a');
    return formatter.format(dateTime);
  }

  Future<void> handlePaymentSuccess(PaymentSuccessResponse response) async {
    ToastUtil.successToast("Success");
    debugPrint('Payment successful: ${response.paymentId}');
    String paymentId = response.paymentId.toString();
    String status = "Payment Successful";
    paymentAmount = paymentAmount;
    logs('paymentAmount-->$paymentAmount');
    DateTime dateTime = DateTime.now().toLocal();
    TransactionsModel entry = TransactionsModel(
      paymentId: paymentId,
      status: status,
      amount: paymentAmount,
      time: formatDateTime(dateTime),
    );
    transactionList.add(entry);
    await UsersService.instance.saveTransactionToFirestore(entry);
    donatePage!.donateController!.update();
  }

  Future<void> handlePaymentError(PaymentFailureResponse response) async {
    ToastUtil.warningToast("Payment Error");
    debugPrint('Payment failed: ${response.code} - ${response.message}');
    String paymentId = currentPaymentId ?? "";
    double paymentAmount = 0.0;
    String status = " Payment Failed";
    DateTime dateTime = DateTime.now().toLocal();
    TransactionsModel entry = TransactionsModel(
        paymentId: paymentId,
        status: status,
        amount: paymentAmount,
        time: formatDateTime(dateTime));
    transactionList.add(entry);
    await UsersService.instance.saveTransactionToFirestore(entry);
    donatePage!.donateController!.update();
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: 'paymentWallet', backgroundColor: Colors.blue);
    ToastUtil.messageToast("paymentWallet");
    debugPrint('External wallet selected: ${response.walletName}');
    totalAmount.toString();
  }
}
