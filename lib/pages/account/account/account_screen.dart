import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/acccount_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/service/network_connectivity.dart';

import '../../../app/app/utills/theme_util.dart';
import 'account_view_model.dart';

// ignore: must_be_immutable
class AccountScreen extends StatelessWidget {
  AccountViewModel? accountViewModel;

  AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    accountViewModel ?? (accountViewModel = AccountViewModel(this));

    return GetBuilder<AttachmentController>(
      init: AttachmentController(),
      initState: (state) {},
      builder: (controller) {
        return  Builder(builder: (context) {
          MediaQueryData mediaQuery = MediaQuery.of(context);
          ThemeUtil.isDark = mediaQuery.platformBrightness == Brightness.dark;
          return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: getAppBar(context),
          body: getBody(context, controller),
        );});
      },
    );
  }

  getAppBar(BuildContext context) {
    return AppAppBar(
      title: AppText(
        S.of(context).account,
        fontSize: 22.px,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  getBody(
    context,
    AttachmentController controller,
  ) {
    Color primaryTheme = Theme.of(context).colorScheme.primary;
    Color secondaryTheme = Theme.of(context).colorScheme.secondary;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.px, right: 20.px, top: 10.px),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  S.of(context).chaAppPin,
                  fontSize: 15.px,
                  fontWeight: FontWeight.bold,
                  color: primaryTheme,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.px),
                  child: InkWell(
                    onTap: () {
                      accountViewModel!.changePinTap();
                    },
                    child: AppText(
                      S.of(context).changeYourPin,
                      color: primaryTheme,
                    ),
                  ),
                ),
                AppText(S.of(context).pinReminders, color: primaryTheme),
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        S.of(context).youWillBeAsked,
                        color: secondaryTheme,
                        fontSize: 13.px,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 13.px),
                      child: InkWell(
                        onTap: () {
                          accountViewModel!.pinReminderTap(context, controller);
                        },
                        child:
                            customSwitch(accountViewModel!.isPinReminderActive),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 32.px),
                  child: AppText(S.of(context).registrationLock,
                      color: primaryTheme),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        S.of(context).requireYourChatApp,
                        color: secondaryTheme,
                        fontSize: 13.px,
                        maxLines: 3,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 13.px),
                      child: InkWell(
                        onTap: () {
                          accountViewModel!
                              .registrationLockTap(context, controller);
                        },
                        child: customSwitch(
                            accountViewModel!.isRegistrationLockActive),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.px),
                  child: InkWell(
                    onTap: () {
                      accountViewModel!.onAdvancePinSettingTap();
                    },
                    child: AppText(S.of(context).advancePinSetting,
                        color: primaryTheme),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 2.px,
            width: double.infinity,
            color: AppColorConstant.darkSecondary.withOpacity(0.2),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.px, right: 20.px, bottom: 20.px),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.px),
                  child: AppText(
                    S.of(context).account,
                    fontWeight: FontWeight.bold,
                    color: primaryTheme,
                  ),
                ),
                InkWell(
                    onTap: () {
                      accountViewModel!.changePhoneTap();
                    },
                    child: AppText(S.of(context).changePhoneNumber,
                        color: primaryTheme)),
                Padding(
                  padding: EdgeInsets.only(top: 32.px),
                  child: AppText(S.of(context).transferAccount,
                      color: primaryTheme),
                ),
                AppText(
                  S.of(context).transferAccountTo,
                  color: secondaryTheme,
                  fontSize: 13.px,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.px),
                  child: AppText(S.of(context).yourAccountData,
                      color: primaryTheme),
                ),
                InkWell(
                  onTap: () async {
                    accountViewModel!.deleteAccountTap(controller,context);
                  },
                  child: AppText(
                    S.of(context).deleteAccount,
                    color: AppColorConstant.red,
                  ),
                ),
              ],
            ),
          )
        ],
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
