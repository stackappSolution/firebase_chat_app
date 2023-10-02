import 'dart:io';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_button.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/new_group_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/groups/group_name/group_name_view_model.dart';
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/database_service.dart';

import '../../../modal/first_message_model.dart';

// ignore: must_be_immutable
class GroupNameScreen extends StatelessWidget {
  GroupNameScreen({Key? key}) : super(key: key);

  GroupNameViewModel? groupNameViewModel;
  GroupController? controller;

  @override
  Widget build(BuildContext context) {
    groupNameViewModel ?? (groupNameViewModel = GroupNameViewModel(this));

    return GetBuilder<GroupController>(
      initState: (state) {
        Future.delayed(
          const Duration(milliseconds: 100),
          () {
            controller = Get.find<GroupController>();
            groupNameViewModel!.membersList = Get.arguments;
            logs("length---> ${groupNameViewModel!.membersList.length}");
            logs("members---> ${groupNameViewModel!.membersList}");
            controller!.update();
          },
        );
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: getAppbar(context),
          body: buildGroupInfoView(context),
        );
      },
    );
  }

  buildGroupInfoView(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.px, horizontal: 10.px),
              child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: TextFormField(
                      controller: groupNameViewModel!.groupNameController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: S.of(context).groupName)),
                  leading: (groupNameViewModel!.selectedImage != null)
                      ? CircleAvatar(
                          maxRadius: 40.px,
                          backgroundImage: FileImage(
                              File(groupNameViewModel!.selectedImage!.path)),
                        )
                      : CircleAvatar(
                          maxRadius: 40.px,
                          backgroundColor:
                              AppColorConstant.appYellow.withOpacity(0.5),
                          child: IconButton(
                              onPressed: () {
                                groupNameViewModel!
                                    .showDialogs(context, controller!);
                              },
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: AppColorConstant.appWhite,
                              )),
                        )),
            ),
            Divider(
              height: 2.px,
              color: AppColorConstant.appGrey,
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 12.px),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20.px, horizontal: 20.px),
                  title: AppText(
                    S.of(context).members,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.px),
                    child: AppText(S.of(context).addRemoveMember,
                        color: AppColorConstant.appGrey, fontSize: 12.px),
                  ),
                )),
            buildMembersList()
          ],
        ),
        buildFloatingActionButton(context),
        if (groupNameViewModel!.isLoading) AppLoader(),
      ],
    );
  }

  void addNumbers(String mobileNumbers) {
    groupNameViewModel!.mobileNo.add(mobileNumbers);
  }

  buildMembersList() {
    return SizedBox(
      height: 350.px,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: groupNameViewModel!.membersList.length,
        itemBuilder: (context, index) {
          Contact contact = groupNameViewModel!.membersList[index];
          String? mobileNumber = contact.phones!.isNotEmpty
              ? contact.phones!.first.value!.trim().removeAllWhitespace
              : 'N/A';

          addNumbers(mobileNumber!);
          logs('mobileNumbers----------> ${groupNameViewModel!.mobileNo}');

          String? displayName = contact.displayName ?? 'unknown';
          String firstLetter = displayName.substring(0, 1).toUpperCase();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: AppColorConstant.appYellow,
                  child: AppText(
                    firstLetter,
                    color: AppColorConstant.appWhite,
                  )),
              title: AppText(
                displayName,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        },
      ),
    );
  }

  getAppbar(BuildContext context) {
    return AppAppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: AppText(
        S.of(context).nameThisGroup,
        fontSize: 20.px,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  buildFloatingActionButton(BuildContext context) {
    return InkWell(
      onTap: () {
        onCreateGroup();
      },
      child: Align(alignment:Alignment.bottomCenter ,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 30.px, horizontal: 20.px),
          alignment: Alignment.center,
          height: 50.px,
          width: 100.px,
          decoration: BoxDecoration(
              color: AppColorConstant.appYellow,
              borderRadius: BorderRadius.all(Radius.circular(50.px))),
          child: AppText(
            S.of(context).create,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  onCreateGroup() async {
    groupNameViewModel!.mobileNo
        .add(AuthService.auth.currentUser!.phoneNumber!);
    List<dynamic> members = groupNameViewModel!.mobileNo.toSet().toList();
    logs("members -- >>  ${members}");

    SendMessageModel sendMessageModel = SendMessageModel(
        type: 'text',
        createdBy: AuthService.auth.currentUser!.phoneNumber,
        groupName: groupNameViewModel!.groupNameController.text,
        profile: groupNameViewModel!.userProfile,
        members: members,
        isGroup: true,
        message: "welcome",
        text: "New Group");
    DatabaseService.instance.addNewMessage(sendMessageModel);
  }
}
