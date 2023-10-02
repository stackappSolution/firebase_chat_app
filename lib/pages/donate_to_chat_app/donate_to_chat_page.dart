import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/donate_to_chat_controller.dart';
import 'package:signal/pages/donate_to_chat_app/donate_chat_view_model.dart';
import 'package:signal/routes/app_navigation.dart';

class DonateToChatPage extends StatelessWidget {
  DonateToChatPage({super.key});

  DonateChatViewModel? donateChatViewModel;
  DonateToChatController? donateToChatController;

  @override
  Widget build(BuildContext context) {
    donateChatViewModel ?? (donateChatViewModel = DonateChatViewModel(this));
    return GetBuilder(
      init: DonateToChatController(),
      initState: (state) {
        Future.delayed(const Duration(milliseconds: 300), () async {
          donateToChatController = Get.find<DonateToChatController>();
        });
        donateChatViewModel!.razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
            donateChatViewModel!.handlePaymentSuccess);
        donateChatViewModel!.razorpay.on(
            Razorpay.EVENT_PAYMENT_ERROR, donateChatViewModel!.handlePaymentError);
        donateChatViewModel!.razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
            donateChatViewModel!.handleExternalWallet);
      },
      dispose: (state) {
        donateChatViewModel!.razorpay.clear();
      },
      builder: (DonateToChatController controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: const AppAppBar(),
          body: buildBody(context, controller),
          floatingActionButton: FloatingActionButton(
            heroTag: 'History',
            backgroundColor: AppColorConstant.appYellow,
            child: const Icon(Icons.history,size: 50),
            onPressed: () {
            goToDonateScreen();
            controller.update();
          },),
        );
      },
    );
  }

  buildBody(
    context,
    DonateToChatController controller,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 50.px,
          ),
          Center(
            child: Container(
              height: 130.px,
              width: 130.px,
              decoration: BoxDecoration(
                  color: AppColorConstant.grey,
                  borderRadius: BorderRadius.circular(70)),
              child:  Center(
                  child: AppText(
                'N',
                fontSize: 60,
                    color: Theme.of(context).colorScheme.primary,
              )),
            ),
          ),
          SizedBox(
            height: 15.px,
          ),
          AppText(
            StringConstant.privacyOverprofit,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 20.px,
          ),
          SizedBox(
            height: 15.px,
          ),
           AppText(
            textAlign: TextAlign.center,
            StringConstant.privacyOverprofitdis,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
          ),
          SizedBox(
            height: 15.px,
          ),
          AppElevatedButton(
            buttonWidth: 40,
            buttonColor: AppColorConstant.appYellow,
            buttonHeight: 40,
            widget:  const AppText(StringConstant.donatetochatapp,
              color: AppColorConstant.appWhite),
            onPressed: () {
              donateChatViewModel!.enterAmount(context, controller);
            },
          ),
          SizedBox(
            height: 10.px,
          ),
          const Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 15.px,
          ),
          Row(
            children: [
              SizedBox(
                width: 20.px,
              ),
               AppText(StringConstant.otherwayto,color: Theme.of(context).colorScheme.primary,),
            ],
          ),
          SizedBox(
            height: 18.px,
          ),
          Row(
            children: [
              SizedBox(width: 22.px),
              const Icon(Icons.card_giftcard),
              SizedBox(width: 22.px),
               AppText(StringConstant.donatefriend,color: Theme.of(context).colorScheme.primary,),
            ],
          ),
        ],
      ),
    );
  }
}
