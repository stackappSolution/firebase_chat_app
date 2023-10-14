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
import 'package:signal/pages/chating_page/chating_page.dart';
import 'package:signal/pages/chats/chat_profile/chat_profile_view_model.dart';
import 'package:signal/routes/routes_helper.dart';
import 'package:signal/service/users_service.dart';

import '../../../app/app/utills/theme_util.dart';
import '../../../service/network_connectivity.dart';

class ChatProfileScreen extends StatelessWidget {
  ChatProfileScreen({Key? key}) : super(key: key);
  ChatProfileController? controller;
  ChatProfileViewModel? chatProfileViewModel;

  @override
  Widget build(
      BuildContext context,
      ) {
    chatProfileViewModel ?? (chatProfileViewModel = ChatProfileViewModel(this));
    return GetBuilder<ChatProfileController>(
      init: ChatProfileController(),
      initState: (state) {
        NetworkConnectivity.checkConnectivity(context);
        chatProfileViewModel!.arguments = Get.arguments;
        chatProfileViewModel!
            .totalMember(chatProfileViewModel!.arguments['number']);

        Future.delayed(
          const Duration(milliseconds: 0),
          () async {
            controller = Get.find<ChatProfileController>();
            chatProfileViewModel!.isBlockedByLoggedUser =
                await UsersService.instance.isBlockedByLoggedInUser(
                    chatProfileViewModel!.arguments['number']
                        .toString()
                        .trim()
                        .removeAllWhitespace);
            controller!.update();
            chatProfileViewModel!.getAbout(chatProfileViewModel!.arguments['number']);
            logs(
                "reciewvwe---- > ${chatProfileViewModel!.arguments['number']}");
            logs(
                "is Blocked By user ---- > ${chatProfileViewModel!.isBlockedByLoggedUser}");
          },
        );
      },
      builder: (controller) {
        return WillPopScope(
          child: Builder(builder: (context) {
            MediaQueryData mediaQuery = MediaQuery.of(context);
            ThemeUtil.isDark = mediaQuery.platformBrightness == Brightness.dark;
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: getAppBar(),
              body: getBody(context, controller),
            );
          }),
          onWillPop: () async {
            Get.back();
            // Get.offAndToNamed(RouteHelper.getChattingScreen(), arguments: {
            //   'name': chatProfileViewModel!.arguments['name'],
            //   'number': chatProfileViewModel!.arguments['number'],
            //   'id': chatProfileViewModel!.arguments['id'],
            //   'isGroup': chatProfileViewModel!.arguments['isGroup'],
            //   'members': chatProfileViewModel!.arguments['members'],
            //   'about': chatProfileViewModel!.arguments['about'],
            // });

            return true;
          },
        );
      },
    );
  }

  getAppBar() {
    return AppAppBar(
      leading: IconButton(
          onPressed: () {
            Get.back();
            // Get.off(ChatingPage(), arguments: {
            //   'name': chatProfileViewModel!.arguments['name'],
            //   'number': chatProfileViewModel!.arguments['number'],
            //   'id': chatProfileViewModel!.arguments['id'],
            //   'isGroup': chatProfileViewModel!.arguments['isGroup'],
            //   'members': chatProfileViewModel!.arguments['members'],
            //   'about': chatProfileViewModel!.arguments['about'],
            // });
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
        if (!chatProfileViewModel!.arguments['isGroup'])
          Padding(
            padding: EdgeInsets.only(top: 10.px, bottom: 10.px),
            child: Center(
                child: AppText(
                    chatProfileViewModel!.about ,
                    fontSize: 18.px)),
          ),
        Divider(
          height: 2.px,
          color: Theme.of(context).colorScheme.secondary,
        ),
        buildProfileListView(context),
        Divider(
          height: 2.px,
          color: Theme.of(context).colorScheme.secondary,
        ),
        SizedBox(
          height: 20.px,
        ),
        Divider(
          height: 2.px,
          color: Theme.of(context).colorScheme.secondary,
        ),
        if (!chatProfileViewModel!.arguments['isGroup'])
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
            child: (!chatProfileViewModel!.arguments['isGroup'])
                ? AppText(
                    chatProfileViewModel!.arguments['name']
                        .substring(0, 1)
                        .toUpperCase(),
                    fontSize: 30.px)
                : AppText(
                    chatProfileViewModel!.arguments['groupName']
                        .substring(0, 1)
                        .toUpperCase(),
                    fontSize: 30.px),
          ),
        ),
        if (!chatProfileViewModel!.arguments['isGroup'])
          AppText(chatProfileViewModel!.arguments['name'],
              fontSize: 25.px, color: Theme.of(context).colorScheme.primary)
        else
          AppText(chatProfileViewModel!.arguments['groupName'],
              fontSize: 25.px, color: Theme.of(context).colorScheme.primary),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.px, horizontal: 10.px),
          alignment: Alignment.center,
          height: 30.px,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: chatProfileViewModel!.totalMembers.length,
            itemBuilder: (context, index) {
              return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 2.px),
                  padding: EdgeInsets.all(4.px),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6.px)),
                      color: AppColorConstant.yellowLight),
                  child: AppText(
                    chatProfileViewModel!.totalMembers[index].toString(),
                    color: AppColorConstant.appYellow,
                  ));
            },
          ),
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
              color: Theme.of(context).colorScheme.primary,
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
            AppText(S.of(context).audio,
                fontSize: 15, color: Theme.of(context).colorScheme.primary),
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
            color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  buildProfileListView(BuildContext context) {
    return Column(
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
    return (chatProfileViewModel!.isBlockedByLoggedUser)
        ? Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 10.px),
      child: ListTile(
        onTap: () {
          buildUnBlockDialog(context, controller);
          controller.update();
        },
        title: AppText(
            color: Theme.of(context).colorScheme.primary, 'unBlock'),
        leading: Icon(
          Icons.block_flipped,
          color: Theme.of(context).colorScheme.primary,
        ),
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
                    onTap: () async {
                      chatProfileViewModel!.blockedNumbers
                          .add(chatProfileViewModel!.arguments['number']);
                      UsersService.instance.blockUser(
                          chatProfileViewModel!.blockedNumbers,
                          chatProfileViewModel!.arguments['number']);

                      UsersService.instance.isBlockedByReceiver(
                          chatProfileViewModel!.arguments['number']);
                      chatProfileViewModel!.isBlockedByLoggedUser =
                          await UsersService.instance.isBlockedByLoggedInUser(
                              chatProfileViewModel!.arguments['number']);

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
                  'Are you sure you want to unblock ${chatProfileViewModel!.arguments['number']}?',
                  color: Theme.of(context).colorScheme.primary),
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
                    onTap: () async {
                      chatProfileViewModel!.blockedNumbers
                          .remove(chatProfileViewModel!.arguments['number']);
                      UsersService.instance.unblockUser(
                          chatProfileViewModel!.arguments['number']);
                      chatProfileViewModel!.isBlockedByLoggedUser =
                          await UsersService.instance.isBlockedByLoggedInUser(
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
}
