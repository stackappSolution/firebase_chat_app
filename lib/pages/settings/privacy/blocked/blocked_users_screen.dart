import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/settings_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/settings/privacy/blocked/blocked_users_view_model.dart';
import 'package:signal/service/users_service.dart';

// ignore: must_be_immutable
class BlockedUsersScreen extends StatelessWidget {
  BlockedUsersScreen({Key? key}) : super(key: key);

  BlockedUsersViewModel? blockedUsersViewModel;
  SettingsController? controller;

  @override
  Widget build(BuildContext context) {
    blockedUsersViewModel ??
        (blockedUsersViewModel = (BlockedUsersViewModel(this)));

    return GetBuilder(
      init: SettingsController(),
      initState: (state) {
        Future.delayed(
          const Duration(milliseconds: 100),
          () {
            controller = Get.find<SettingsController>();
          },
        );
        getBlockedUsersList();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: getAppbar(context),
          body: getBody(context),
        );
      },
    );
  }

  getAppbar(BuildContext context) {
    return AppAppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: AppText( S.of(context).blockedUsers,
          fontSize: 18.px, color: Theme.of(context).colorScheme.primary),
    );
  }

  getBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildAddBlockView(context),
        Padding(
          padding: EdgeInsets.all(20.px),
          child: AppText(
           S.of(context).blockedUsers,
            fontSize: 15.px,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        buildBlockedListView(),
      ],
    );
  }

  buildAddBlockView(BuildContext context) {
    return ListTile(
      title: AppText(S.of(context).addBlockUsers,
          fontSize: 15.px, color: Theme.of(context).colorScheme.primary),
      subtitle: AppText(
          S.of(context).blockedUserCannotSendMessage,
          fontSize: 12.px,
          color: Theme.of(context).colorScheme.secondary),
    );
  }

  buildBlockedListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: blockedUsersViewModel!.blockedUsersList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: AppText(blockedUsersViewModel!.blockedUsersList[index]),
          leading: CircleAvatar(
              backgroundColor: AppColorConstant.appYellow,
              child: AppText(
                blockedUsersViewModel!.blockedUsersList[index]
                    .substring(0, 1)
                    .toUpperCase(),
                color: AppColorConstant.appWhite,
              )),
        );
      },
    );
  }

  getBlockedUsersList() async {
    blockedUsersViewModel!.blockedUsersList =
        await UsersService().getBlockedUsers();
    controller!.update();
    logs('blockkkkk-----------> ${blockedUsersViewModel!.blockedUsersList}');
  }
}
