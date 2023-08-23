import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/chat_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/chats/chat_profile/chat_profile_view_model.dart';

class ChatProfileScreen extends StatelessWidget {
  ChatProfileScreen({Key? key}) : super(key: key);

  ChatProfileViewModel? chatProfileViewModel;

  @override
  Widget build(BuildContext context) {
    chatProfileViewModel ?? (chatProfileViewModel = ChatProfileViewModel(this));
    return GetBuilder<ChatController>(
      init: ChatController(),
      initState: (state) {
        chatProfileViewModel!.parameter = Get.parameters;
        logs("phone--> ${chatProfileViewModel!.parameter['phoneNo']}");
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColorConstant.appWhite,
          appBar: getAppBar(),
          body: getBody(),
        );
      },
    );
  }

  getAppBar() {
    return const AppAppBar();
  }

  getBody() {
    return ListView(
      children: [
        buildProfileView(),
        SizedBox(
          height: 10.px,
        ),
        buildMenu(),
        SizedBox(
          height: 10.px,
        ),
        Divider(
          height: 2.px,
          color: AppColorConstant.grey,
        ),
        buildProfileListView(),
        SizedBox(
          height: 20.px,
        ),
        Divider(
          height: 2.px,
          color: AppColorConstant.grey,
        ),
        buildSafetyNumberView()
      ],
    );
  }

  buildProfileView() {
    return Column(
      children: [
        SizedBox(
          height: 20.px,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            maxRadius: 40.px,
            backgroundColor: AppColorConstant.appTheme.withOpacity(0.2),
            child: AppText('SJ', fontSize: 30.px),
          ),
        ),
        AppText('Shyam Jethva', fontSize: 25.px),
        AppText('+91 9904780294',
            fontSize: 15.px, color: AppColorConstant.grey),
      ],
    );
  }

  buildMenu() {
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
                    color: AppColorConstant.appTheme.withOpacity(0.2)),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: AppImageAsset(
                    image: AppAsset.video,
                  ),
                )),
            AppText(
              S.of(Get.context!).video,
              fontSize: 15,
            ),
          ],
        ),
        Column(
          children: [
            InkWell(
              onTap: () {
                chatProfileViewModel!
                    .launchPhoneURL(chatProfileViewModel!.parameter['phoneNo']);
              },
              child: Container(
                  height: 50.px,
                  width: 50.px,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.px),
                      color: AppColorConstant.appTheme.withOpacity(0.2)),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: AppImageAsset(
                      image: AppAsset.audio,
                    ),
                  )),
            ),
            AppText(
              S.of(Get.context!).audio,
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
                    color: AppColorConstant.appTheme.withOpacity(0.2)),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: AppImageAsset(
                    image: AppAsset.mute,
                  ),
                )),
            AppText(
              S.of(Get.context!).mute,
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
                    color: AppColorConstant.appTheme.withOpacity(0.2)),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: AppImageAsset(
                    image: AppAsset.search,
                  ),
                )),
            AppText(
              S.of(Get.context!).search,
              fontSize: 15,
            )
          ],
        ),
      ],
    );
  }

  chatSettingView(
    index,
    image,
    tittle,
  ) {
    return ListTile(
      onTap: () {
        chatProfileViewModel!.mainTap(index);
      },
      title: AppText(
        tittle,
        fontSize: 15.px,
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

  buildProfileListView() {
    return ListView(
      shrinkWrap: true,
      children: [
        chatSettingView(
          1,
          AppAsset.audio,
          S.of(Get.context!).disappearingMessages,
        ),
        chatSettingView(
          2,
          AppAsset.search,
          S.of(Get.context!).chatColorAndWallpaper,
        ),
        chatSettingView(
          3,
          AppAsset.video,
          S.of(Get.context!).soundAndNotification,
        ),
        chatSettingView(
          4,
          AppAsset.mute,
          S.of(Get.context!).contactDetails,
        ),
        chatSettingView(
          5,
          AppAsset.audio,
          S.of(Get.context!).viewSafetyNumbers,
        ),
      ],
    );
  }

  buildSafetyNumberView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 10.px),
      child: ListTile(
        title: AppText(
          S.of(Get.context!).viewSafetyNumbers,
        ),
        leading: AppImageAsset(
          image: AppAsset.help,
          height: 20.px,
          width: 20.px,
        ),
      ),
    );
  }
}
