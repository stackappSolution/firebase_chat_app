import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/contact_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/chats/chat_view_model.dart';
import 'package:signal/routes/routes_helper.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  ChatViewModel? chatViewModel;

  @override
  Widget build(BuildContext context) {
    logs("Current Screen --> $runtimeType");
    chatViewModel ?? (chatViewModel = ChatViewModel(this));
    chatViewModel!.getPermission();
    return GetBuilder<ContactController>(
      init: ContactController(),
      initState: (state) {},
      builder: (controller) {
        return SafeArea(
            child: Scaffold(
          backgroundColor: AppColorConstant.appWhite,
          floatingActionButton: buildFloatingButton(),
          body: getBody(),
        ));
      },
    );
  }

  getBody() {
    return ListView(
      children: [
        buildContactList(),
      ],
    );
  }

  buildFloatingButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.px),
          child: FloatingActionButton(
            heroTag: 'camera',
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.px)),
            backgroundColor: AppColorConstant.appTheme,
            child: AppImageAsset(
                image: AppAsset.camera, height: 25.px, width: 25.px),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10.px),
          child: FloatingActionButton(
            heroTag: "chats",
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.px)),
            backgroundColor: AppColorConstant.appTheme,
            child: AppImageAsset(
                image: AppAsset.edit, height: 25.px, width: 25.px),
            onPressed: () {},
          ),
        )
      ],
    );
  }




  buildContactList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: chatViewModel!.contacts.length,
      itemBuilder: (context, index) {
        Contact contact = chatViewModel!.contacts[index];
        String? mobileNumber =
            contact.phones!.isNotEmpty ? contact.phones!.first.value : 'N/A';
        String? displayName = contact.displayName ?? 'unknown';
        String firstLetter = displayName.substring(0, 1).toUpperCase();

        return Container(
            margin: EdgeInsets.all(10.px),
            child: ListTile(onTap: () {
              Get.toNamed(RouteHelper.getChattingScreen(),parameters: {'phoneNo': mobileNumber});
            },
              trailing: AppText(
                  fontSize: 10.px,
                  S.of(Get.context!).yesterday,
                  color: AppColorConstant.appBlack),
              leading: InkWell(onTap: () {
                  Get.toNamed(RouteHelper.getChatProfileScreen());
              },
                child: CircleAvatar(maxRadius: 30.px,
                  backgroundColor: AppColorConstant.appTheme.withOpacity(0.8),
                  child: AppText(
                    firstLetter,
                    color: AppColorConstant.appWhite,
                    fontSize: 22.px,
                  ),
                ),
              ),
              title: AppText(displayName,fontSize: 15.px,),
              subtitle: AppText(mobileNumber!,
                  color: AppColorConstant.grey, fontSize: 12.px),
            ));
      },
    );
  }
}
