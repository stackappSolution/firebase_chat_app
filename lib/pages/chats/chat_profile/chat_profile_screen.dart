import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_button.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/chat_profile_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/chats/chat_profile/chat_profile_view_model.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/database_service.dart';

// ignore: must_be_immutable
class ChatProfileScreen extends StatelessWidget {
  ChatProfileScreen({Key? key}) : super(key: key);
  ChatProfileController? controller;
  ChatProfileViewModel? chatProfileViewModel;

  @override
  Widget build(
    BuildContext context,
  ) {
    chatProfileViewModel ?? (chatProfileViewModel = ChatProfileViewModel(this));
    getBlockedUsersList();
    return GetBuilder<ChatProfileController>(
      init: ChatProfileController(),
      initState: (state) {
        chatProfileViewModel!.arguments = Get.arguments;

        Future.delayed(
          const Duration(milliseconds: 0),
          () {
            controller = Get.find<ChatProfileController>();

          },
        );
      },
      builder: (controller) {
        return WillPopScope(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: getAppBar(),
            body: getBody(context, controller),
          ),
          onWillPop: () async {
            return false;
          },
        );
      },
    );
  }

  getAppBar() {
    return AppAppBar(
      leading: IconButton(
          onPressed: () {
            Get.offAllNamed(RouteHelper.getChattingScreen(), arguments: {
              'name': chatProfileViewModel!.arguments['name'],
              'number': chatProfileViewModel!.arguments['number'],
              'id': chatProfileViewModel!.arguments['id'],
              'isGroup': chatProfileViewModel!.arguments['isGroup'],
              'members': chatProfileViewModel!.arguments['members'],
            });
          },
          icon: const Icon(Icons.arrow_back_outlined)),
    );
  }

  getBody(BuildContext context, ChatProfileController controller) {
    return ListView(
      children: [
        buildProfileView(context),
        SizedBox(
          height: 10.px,
        ),
        buildMenu(context),
        SizedBox(
          height: 10.px,
        ),
        Divider(
          height: 2.px,
          color: Theme.of(context).colorScheme.secondary,
        ),
        buildProfileListView(context),
        SizedBox(
          height: 20.px,
        ),
        Divider(
          height: 2.px,
          color: Theme.of(context).colorScheme.secondary,
        ),
        buildBlockUser(context, controller)
      ],
    );
  }

  buildProfileView(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.px,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            maxRadius: 40.px,
            backgroundColor: AppColorConstant.appYellow.withOpacity(0.5),
            child: AppText(
                chatProfileViewModel!.arguments['name']
                    .substring(0, 1)
                    .toUpperCase(),
                fontSize: 30.px),
          ),
        ),
        AppText(chatProfileViewModel!.arguments['name'], fontSize: 25.px),
        AppText(
          '${chatProfileViewModel!.arguments['number']}',
          fontSize: 15.px,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }

  buildMenu(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Container(
                height: 50.px,
                width: 50.px,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.px),
                    color: AppColorConstant.appYellow.withOpacity(0.5)),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: AppImageAsset(
                    image: AppAsset.video,
                    color: AppColorConstant.appBlack,
                  ),
                )),
            AppText(
              S.of(context).video,
              fontSize: 15,
            ),
          ],
        ),
        Column(
          children: [
            InkWell(
              onTap: () {
                chatProfileViewModel!
                    .launchPhoneURL(chatProfileViewModel!.arguments['number']);
              },
              child: Container(
                  height: 50.px,
                  width: 50.px,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.px),
                      color: AppColorConstant.appYellow.withOpacity(0.5)),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: AppImageAsset(
                      image: AppAsset.audio,
                    ),
                  )),
            ),
            AppText(
              S.of(context).audio,
              fontSize: 15,
            ),
          ],
        ),
        Column(
          children: [
            Container(
                height: 50.px,
                width: 50.px,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.px),
                    color: AppColorConstant.appYellow.withOpacity(0.5)),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: AppImageAsset(
                    image: AppAsset.mute,
                  ),
                )),
            AppText(
              S.of(context).mute,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 15,
            )
          ],
        ),
        Column(
          children: [
            Container(
                height: 50.px,
                width: 50.px,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.px),
                    color: AppColorConstant.appYellow.withOpacity(0.5)),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: AppImageAsset(
                    image: AppAsset.search,
                  ),
                )),
            AppText(
              color: Theme.of(context).colorScheme.primary,
              S.of(context).search,
              fontSize: 15,
            )
          ],
        ),
      ],
    );
  }

  chatSettingView(index, image, tittle, context) {
    return ListTile(
      onTap: () {
        chatProfileViewModel!.mainTap(index);
      },
      title: AppText(
        tittle,
        fontSize: 15.px,
        color: Theme.of(context).colorScheme.primary,
      ),
      leading: Container(
        height: 50.px,
        width: 50.px,
        padding: EdgeInsets.all(12.px),
        child: AppImageAsset(
          height: 10.px,
          width: 10.px,
          image: image,
        ),
      ),
    );
  }

  buildProfileListView(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        chatSettingView(
            1, AppAsset.audio, S.of(context).disappearingMessages, context),
        chatSettingView(
            2, AppAsset.search, S.of(context).chatColorAndWallpaper, context),
        chatSettingView(
            3, AppAsset.video, S.of(context).soundAndNotification, context),
        chatSettingView(
            4, AppAsset.mute, S.of(context).contactDetails, context),
        chatSettingView(
            5, AppAsset.audio, S.of(context).viewSafetyNumbers, context),
      ],
    );
  }

  buildBlockUser(BuildContext context, ChatProfileController controller) {
    controller.update();
    return (chatProfileViewModel!.blockedNumbers
            .contains(chatProfileViewModel!.arguments['number']))
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 10.px),
            child: ListTile(
              onTap: () {
                buildUnBlockDialog(context, controller);
                controller.update();
              },
              title: const AppText(color: AppColorConstant.appBlack, 'unBlock'),
              leading: const Icon(Icons.block_flipped,
                  color: AppColorConstant.appBlack),
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 10.px),
            child: ListTile(
              onTap: () {
                buildBlockDialog(context, controller);
                controller.update();
              },
              title: AppText(
                color: AppColorConstant.red,
                S.of(context).block,
              ),
              leading: const Icon(Icons.block, color: AppColorConstant.red),
            ),
          );
  }

  buildBlockDialog(BuildContext context, ChatProfileController controller) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.px)),
              actionsPadding:
                  EdgeInsets.symmetric(horizontal: 15.px, vertical: 15.px),
              backgroundColor: Theme.of(context).colorScheme.background,
              title: AppText(
                  'Are you sure you want to block ${chatProfileViewModel!.arguments['number']}?'),
              actions: [
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: AppText(S.of(context).cancel,
                        color: AppColorConstant.appYellow)),
                SizedBox(
                  width: 20.px,
                ),
                InkWell(
                    onTap: () {
                      chatProfileViewModel!.blockedNumbers
                          .add(chatProfileViewModel!.arguments['number']);
                      DatabaseService()
                          .blockUser(chatProfileViewModel!.blockedNumbers,chatProfileViewModel!.arguments['number']);
                      Get.back();
                      controller.update();
                    },
                    child: AppButton(
                      width: 80.px,
                      borderRadius: BorderRadius.circular(12.px),
                      height: 35.px,
                      color: AppColorConstant.appYellow,
                      stringChild: true,
                      child: AppText(
                        S.of(context).block,
                        color: AppColorConstant.appWhite,
                        fontSize: 12.px,
                      ),
                    ))
              ],
            );
          },
        );
      },
    );
  }

  buildUnBlockDialog(BuildContext context, ChatProfileController controller) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.px)),
              actionsPadding:
                  EdgeInsets.symmetric(horizontal: 15.px, vertical: 15.px),
              backgroundColor: Theme.of(context).colorScheme.background,
              title: AppText(
                  'Are you sure you want to unblock ${chatProfileViewModel!.arguments['number']}?'),
              actions: [
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: AppText(S.of(context).cancel,
                        color: AppColorConstant.appYellow)),
                SizedBox(
                  width: 20.px,
                ),
                InkWell(
                    onTap: () {
                      chatProfileViewModel!.blockedNumbers
                          .remove(chatProfileViewModel!.arguments['number']);
                      DatabaseService().unblockUser(
                          chatProfileViewModel!.arguments['number']);
                      controller.update();
                      Get.back();
                    },
                    child: AppButton(
                      width: 80.px,
                      borderRadius: BorderRadius.circular(12.px),
                      height: 35.px,
                      color: AppColorConstant.appYellow,
                      stringChild: true,
                      child: AppText(
                        'Unblock',
                        color: AppColorConstant.appWhite,
                        fontSize: 12.px,
                      ),
                    ))
              ],
            );
          },
        );
      },
    );
  }

  getBlockedUsersList() async {
    chatProfileViewModel!.blockedNumbers =
        await DatabaseService().getBlockedUsers();
    controller!.update();
    logs('blockkkkk-----------> ${chatProfileViewModel!.blockedNumbers}');
  }
}
