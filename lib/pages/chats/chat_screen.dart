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
import 'package:signal/pages/chats/chat_view_model.dart';
import 'package:signal/routes/app_navigation.dart';

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
          body: buildContactList(),
        ));
      },
    );
  }


  buildFloatingButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.px),
          child: FloatingActionButton(
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
      itemCount: chatViewModel!.contacts.length,
      itemBuilder: (context, index) {
        Contact contact = chatViewModel!.contacts[index];
        String? mobileNumber =
            contact.phones!.isNotEmpty ? contact.phones!.first.value : 'N/A';
        String firstLetter = contact.displayName!.substring(0, 1).toUpperCase();
        return Container(
            margin: EdgeInsets.all(10.px),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.px),
                border: Border.all(
                    color: AppColorConstant.appTheme.withOpacity(0.4))),
            child: ListTile(onTap: () {
              goToChatingPage();

            },
              leading: CircleAvatar(
                backgroundColor: AppColorConstant.appTheme,
                child: AppText(
                  firstLetter,
                  color: AppColorConstant.appWhite,
                  fontSize: 22.px,
                ),
              ),
              title: AppText(contact.displayName!),
              subtitle: AppText(mobileNumber!,
                  color: AppColorConstant.appBlack, fontSize: 12.px),
            ));
      },
    );
  }
}
