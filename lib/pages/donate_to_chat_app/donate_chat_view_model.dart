

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/app/utills/toast_util.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textForm_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/donate_to_chat_controller.dart';
import 'package:signal/modal/transaction_model.dart';
import 'package:signal/pages/donate_to_chat_app/donate_to_chat_page.dart';
import 'package:signal/routes/app_navigation.dart';
import 'package:signal/service/users_service.dart';

class DonateChatViewModel{
  DonateToChatPage? donateToChatPage;
  TextEditingController amountController = TextEditingController();
  double paymentAmount = 0.0;
  int totalAmount = 0;
  List<TransactionsModel> transactionList = [];
  String? currentPaymentId;
  final Razorpay razorpay = Razorpay();
  DonateChatViewModel(this.donateToChatPage);

  DonateToChatController? donateToChatController;

  enterAmount(context, DonateToChatController controller)  {
      return  showDialog(context: context, builder: (context) =>  AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title:  AppText('Give A Payment To Chat App',fontSize: 15,color: Theme.of(context).colorScheme.primary,),
        actions: [
          Column(
            children: [
              AppTextFormField(
                controller: amountController,
                hintText: StringConstant.enteramount,
                style: TextStyle(
                  fontSize: 22.px,
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: TextInputType.number,
                fontSize: 20.px,
              ),
              const SizedBox(height: 20,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 50.px),
                child: AppElevatedButton(
                  onPressed: () async {
                    amountController.text;
                    controller.update();
                    startPayment(amountController.text);
                    amountController.clear();
                    await UsersService.instance.getTransactionHistory();
                    goToDonateScreen();
                  },
                  buttonColor: AppColorConstant.appYellowBorder,
                  buttonHeight: 50.px,
                  widget:  AppText('Payment',color: Theme.of(context).colorScheme.primary,fontSize: 20),
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ],
      ));
  }
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
    donateToChatController!.update();
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
    donateToChatController!.update();
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: 'paymentWallet', backgroundColor: Colors.blue);
    ToastUtil.messageToast("paymentWallet");
    debugPrint('External wallet selected: ${response.walletName}');
    totalAmount.toString();
  }
}