import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/routes/routes_helper.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: getAppbar(context),
      body: getBody(context),
    );
  }

  getAppbar(BuildContext context) {
    return AppAppBar(
      title: AppText(S.of(context).privacy, fontSize: 20.px),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      children: [
        buildBlockView(context),
        Divider(
          height: 2.px,
          color: Theme.of(context).colorScheme.secondary,
        ),
        buildMessagingView(context),
        buildMessageDisappearingView(context),
        buildApSecurityView(context),
        buildPaymentView(context),
        buildAdvanceView(context),
      ],
    );
  }

  buildBlockView(context) {
    return Padding(
      padding: EdgeInsets.all(12.px),
      child: ListTile(onTap: () {
        Get.toNamed(RouteHelper.getBlockedUsersScreen());
      },
        title: AppText(
          S.of(context).blocked,
          color: Theme.of(context).colorScheme.primary,
        ),
        subtitle: AppText('0 ${S.of(context).contacts}',
            color: Theme.of(context).colorScheme.secondary, fontSize: 12.px),
      ),
    );
  }

  buildMessagingView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20.px),
          child: AppText(
            S.of(context).messaging,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 15.px,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.px),
          child: ListTile(
            title: AppText(S.of(context).readReceipts,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 15.px,
                fontWeight: FontWeight.w300),
            subtitle: AppText(S.of(context).receiptsDescription,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 12.px),
            trailing: customSwitch(true),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.px),
          child: ListTile(
            title: AppText(S.of(context).typingIndicators,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 15.px,
                fontWeight: FontWeight.w300),
            subtitle: AppText(S.of(context).indicatorsDescription,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 12.px),
            trailing: customSwitch(true),
          ),
        ),
        SizedBox(
          height: 20.px,
        ),
        Divider(
          height: 2.px,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }

  buildMessageDisappearingView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20.px),
          child: AppText(
            S.of(context).disappearingMessages,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 15.px,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.px),
          child: ListTile(onTap: () {
            Get.toNamed(RouteHelper.getDisappearingScreen());
          },
            title: AppText(S.of(context).defaultTimerForNewChats,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 15.px,
                fontWeight: FontWeight.w300),
            subtitle: AppText(
                S.of(context).disappearingDescription,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 12.px),
            trailing: AppText(S.of(context).off),
          ),
        ),
        SizedBox(
          height: 15.px,
        ),
        Divider(
          height: 2.px,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }

  buildApSecurityView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20.px),
          child: AppText(
            S.of(context).appSecurity,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 15.px,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.px),
          child: ListTile(
            title: AppText(S.of(context).screenLock,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 15.px,
                fontWeight: FontWeight.w300),
            subtitle: AppText(
               S.of(context).screenLockDescription,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 12.px),
            trailing: customSwitch(false),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.px),
          child: ListTile(
            title: AppText(S.of(context).screenLockTimeout,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 15.px,
                fontWeight: FontWeight.w300),
            subtitle: AppText(
              'None',
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 12.px,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.px),
          child: ListTile(
            title: AppText(S.of(context).screenSecurity,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 15.px,
                fontWeight: FontWeight.w300),
            subtitle: AppText(
             S.of(context).blockScreenshots,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 12.px,
            ),
            trailing: customSwitch(true),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.px),
          child: ListTile(
            title: AppText(S.of(context).incognitoKeyboard,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 15.px,
                fontWeight: FontWeight.w300),
            subtitle: AppText(
             S.of(context).keyboardDisable,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 12.px,
            ),
            trailing: customSwitch(false),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(30.px),
          child: AppText(
           S.of(context).settingGuarantee,
            fontSize: 12.px,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Divider(
          height: 2.px,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }

  buildPaymentView(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20.px),
          child: AppText(
          S.of(context).payments ,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 15.px,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.px),
          child: ListTile(
            title: AppText(S.of(context).paymentLock,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 15.px,
                fontWeight: FontWeight.w300),
            subtitle: AppText(
                S.of(context).fingerprintTransfer,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 12.px),
            trailing: customSwitch(false),
          ),
        ),
        Divider(
          height: 2.px,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }




  buildAdvanceView(BuildContext context){
    return  Padding(
      padding: EdgeInsets.all(10.px),
      child: ListTile(
        title: AppText( S.of(context).advance,
            color: Theme.of(context).colorScheme.primary,
            fontSize: 15.px,
            fontWeight: FontWeight.w300),
        subtitle: AppText(
            S.of(context).advanceDescription,
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 12.px),

      ),
    );
  }

  customSwitch(isActive) {
    return Container(
      padding: (isActive) ? EdgeInsets.all(3.px) : EdgeInsets.all(5.px),
      alignment: (isActive) ? Alignment.centerRight : Alignment.centerLeft,
      height: 30.px,
      width: 55.px,
      decoration: BoxDecoration(
          color: (isActive)
              ? AppColorConstant.appYellow
              : AppColorConstant.blackOff.withOpacity(0.2),
          borderRadius: BorderRadius.circular(27.px),
          border: Border.all(color: Colors.grey.shade600, width: 1.px)),
      child: Container(
        height: (isActive) ? 23.px : 19.px,
        width: (isActive) ? 23.px : 19.px,
        decoration: BoxDecoration(
            color: (isActive)
                ? AppColorConstant.appWhite
                : AppColorConstant.blackOff,
            shape: BoxShape.circle),
      ),
    );
  }
}
