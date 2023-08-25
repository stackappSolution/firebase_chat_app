import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/chat_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/chating_page/chating_page.dart';
import 'package:signal/pages/chats/chat_profile/chat_profile_view_model.dart';

// ignore: must_be_immutable
class ChatProfileScreen extends StatelessWidget {
  ChatProfileScreen({Key? key}) : super(key: key);
  ChatController? controller;
  ChatProfileViewModel? chatProfileViewModel;

  @override
  Widget build(BuildContext context) {
    chatProfileViewModel ?? (chatProfileViewModel = ChatProfileViewModel(this));
    return GetBuilder<ChatController>(
      init: ChatController(),
      initState: (state) {
        chatProfileViewModel!.parameter = Get.parameters;
      },
      builder: (controller) {
        return WillPopScope(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: getAppBar(),
            body: getBody(context),
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
           Get.offAll(()=> ChatingPage());
          },
          icon: const Icon(Icons.arrow_back)),
    );
  }

  getBody(BuildContext context) {
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
        buildSafetyNumberView(context)
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
            backgroundColor: AppColorConstant.appYellow.withOpacity(0.2),
            child: AppText('SJ', fontSize: 30.px),
          ),
        ),
        AppText('Shyam Jethva', fontSize: 25.px),
        AppText('+91 9904780294',
            fontSize: 15.px, color: Theme.of(context).colorScheme.secondary,),
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
                    color: AppColorConstant.appYellow.withOpacity(0.2)),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: AppImageAsset(
                    image: AppAsset.video,
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
                    .launchPhoneURL(chatProfileViewModel!.parameter['phoneNo']);
              },
              child: Container(
                  height: 50.px,
                  width: 50.px,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.px),
                      color: AppColorConstant.appYellow.withOpacity(0.2)),
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
                    color: AppColorConstant.appYellow.withOpacity(0.2)),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: AppImageAsset(
                    image: AppAsset.mute,
                  ),
                )),
            AppText(
              S.of(context).mute,color: Theme.of(context).colorScheme.primary,
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
                    color: AppColorConstant.appYellow.withOpacity(0.2)),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: AppImageAsset(
                    image: AppAsset.search,
                  ),
                )),
            AppText(color:  Theme.of(context).colorScheme.primary,
              S.of(context).search,
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
      context
  ) {
    return ListTile(
      onTap: () {
        chatProfileViewModel!.mainTap(index);
      },
      title: AppText(
        tittle,
        fontSize: 15.px,
        color:  Theme.of(context).colorScheme.primary,
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
          1,
          AppAsset.audio,
          S.of(context).disappearingMessages,
          context
        ),
        chatSettingView(
          2,
          AppAsset.search,
          S.of(context).chatColorAndWallpaper,
          context
        ),
        chatSettingView(
          3,
          AppAsset.video,
          S.of(context).soundAndNotification,
          context
        ),
        chatSettingView(
          4,
          AppAsset.mute,
          S.of(context).contactDetails,
          context
        ),
        chatSettingView(
          5,
          AppAsset.audio,
          S.of(context).viewSafetyNumbers,
          context
        ),
      ],
    );
  }

  buildSafetyNumberView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.px, vertical: 10.px),
      child: ListTile(
        title: AppText(color: Theme.of(context).colorScheme.primary,
          S.of(context).viewSafetyNumbers,
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
