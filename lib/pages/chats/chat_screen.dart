import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/contact_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/chats/chat_view_model.dart';
import 'package:signal/routes/routes_helper.dart';

import '../../service/database_service.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  ChatViewModel? chatViewModel;
  ContactController? contactController;

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
          body: getBody(controller),
        ));
      },
    );
  }

  getBody(ContactController controller) {
    return ListView(
      children: [buildContactList(controller)],
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
            backgroundColor: AppColorConstant.appYellow,
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
            backgroundColor: AppColorConstant.appYellow,
            child: AppImageAsset(
                image: AppAsset.edit, height: 25.px, width: 25.px),
            onPressed: () {
              Get.toNamed(RouteHelper.getNewMessageScreen());
            },
          ),
        )
      ],
    );
  }

  buildContactList(ContactController controller) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('rooms')
          // .where('members', arrayContains: DatabaseService.auth.currentUser!.phoneNumber)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return AppText('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppLoader();
        }
        final documents = snapshot.data!.docs;
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return Container(
                margin: EdgeInsets.all(10.px),
                child: ListTile(
                  trailing: AppText(
                      fontSize: 10.px,
                      S.of(Get.context!).yesterday,
                      color: AppColorConstant.appBlack),
                  leading: InkWell(
                    onTap: () {
                      Get.toNamed(RouteHelper.getChatProfileScreen());
                    },
                    child: CircleAvatar(
                      maxRadius: 30.px,
                      backgroundColor:
                          AppColorConstant.appYellow.withOpacity(0.8),
                      child: (documents[index]['isGroup'] == true)
                          ? AppText(
                              documents[index]['groupName']
                                      .substring(0, 1)
                                      .toUpperCase() ??
                                  "",
                              color: AppColorConstant.appWhite,
                              fontSize: 22.px,
                            )
                          : AppText(
                              documents[index]['id']
                                      .substring(0, 1)
                                      .toUpperCase() ??
                                  "",
                              color: AppColorConstant.appWhite,
                              fontSize: 22.px,
                            ),
                    ),
                  ),
                  title: (documents[index]['isGroup'] == true)
                      ? AppText(
                          documents[index]['groupName'] ?? "",
                          fontSize: 15.px,
                        )
                      : AppText(
                          documents[index]['id'] ?? "",
                          fontSize: 15.px,
                        ),
                  subtitle: AppText(documents[index]['members'][1] ?? "",
                      color: AppColorConstant.grey, fontSize: 12.px),
                ));
          },
        );
      },
    );
  }
}
