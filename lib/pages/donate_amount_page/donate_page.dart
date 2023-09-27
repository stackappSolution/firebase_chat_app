import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textForm_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/donate_controller.dart';
import 'package:signal/pages/donate_amount_page/donate_view_model.dart';

class DonatePage extends StatelessWidget {
  DonatePage({super.key});

  int totalAmount = 0;
  String enteredAmount = '';
  final Razorpay razorpay = Razorpay();
  final TextEditingController amountController = TextEditingController();
  final _razorpay = Razorpay();
  DonateViewModel? donateViewModel;

  @override
  Widget build(BuildContext context) {
    donateViewModel?? (donateViewModel = DonateViewModel(this));
    return GetBuilder(
      init: DonateController(),
      initState: (state) {
        _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
        _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
        _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      },
      dispose: (state) {
        _razorpay.clear();
      },
      builder: (DonateController controller) {
        return Scaffold(
          appBar: AppAppBar(),
          body: buildBody(),
        );
      },
    );
  }

  buildBody() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.px),
                    child: AppTextFormField(
                      controller: amountController,
                      hintText: StringConstant.enteramount,
                      style: TextStyle(
                        fontSize: 22.px,
                        fontWeight: FontWeight.w400,
                      ),
                      keyboardType: TextInputType.number,
                      fontSize: 20.px,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50.px,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 80.px),
          child: AppElevatedButton(
            onPressed: () {
              enteredAmount = amountController.text;
              donateViewModel!.startPayment(enteredAmount);
            },
            buttonColor: AppColorConstant.appYellowBorder,
            buttonHeight: 50,
            widget: AppText(StringConstant.payment),
          ),
        )
      ],
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: 'Success', backgroundColor: Colors.green);
    debugPrint('Payment successful: ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: 'payment error', backgroundColor: Colors.red);
    debugPrint('Payment failed: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: 'paymentWallet', backgroundColor: Colors.blue);
    debugPrint('External wallet selected: ${response.walletName}');
    totalAmount.toString();
  }
}
