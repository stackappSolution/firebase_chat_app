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
import 'package:signal/pages/groups/group_name/group_name_view_model.dart';
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/database_service.dart';

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

            controller!.update();
          },
        );
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: getAppbar(),
          body: buildGroupInfoView(context),
          floatingActionButton: buildFloatingActionButton(),
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
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Group name (required)')),
                  leading: (groupNameViewModel!.selectedImage != null)
                      ? CircleAvatar(
                          maxRadius: 40.px,
                          backgroundImage: FileImage(
                              File(groupNameViewModel!.selectedImage!.path)),
                        )
                      : CircleAvatar(
                          maxRadius: 40.px,
                          backgroundColor:
                              AppColorConstant.appYellow.withOpacity(0.3),
                          child: IconButton(
                              onPressed: () {
                                groupNameViewModel!
                                    .showDialogs(context, controller!);
                              },
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: AppColorConstant.appBlack,
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
                  title: const AppText('Members'),
                  subtitle: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.px),
                    child: AppText(
                        'You can add or invite friends after creating this group',
                        color: AppColorConstant.appGrey,
                        fontSize: 12.px),
                  ),
                )),
            buildMembersList()
          ],
        ),
        if (groupNameViewModel!.isLoading) const AppLoader(),
      ],
    );
  }

  buildMembersList() {
    return SizedBox(
      height: 350.px,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: groupNameViewModel!.membersList.length,
        itemBuilder: (context, index) {
          Contact contact = groupNameViewModel!.membersList[index];
          String? mobileNumber =
              contact.phones!.isNotEmpty ? contact.phones!.first.value : 'N/A';

          groupNameViewModel!.mobileNo.add(mobileNumber!);
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
              title: AppText(displayName),
            ),
          );
        },
      ),
    );
  }

  getAppbar() {
    return AppAppBar(
      title: AppText('Name this Group', fontSize: 20.px),
    );
  }

  buildFloatingActionButton() {
    return Stack(
      children: [
        AppButton(
          onTap: () {
            onCreateGroup();
          },
          height: 40.px,
          color: AppColorConstant.appYellow.withOpacity(0.2),
          stringChild: true,
          borderRadius: BorderRadius.circular(20.px),
          width: 100.px,
          child: const AppText('Create', color: AppColorConstant.appBlack),
        ),
        if(groupNameViewModel!.isLoading)
          const AppLoader(),
      ],
    );
  }

  onCreateGroup() async {
    groupNameViewModel!.mobileNo
        .add(AuthService.auth.currentUser!.phoneNumber!);

    groupNameViewModel!.isLoading = true;
    controller!.update();
    DatabaseService().addNewMessage(
        groupName: groupNameViewModel!.groupNameController.text,
        profile: groupNameViewModel!.userProfile,
        members: groupNameViewModel!.mobileNo,
        massage: '',
        sender: AuthService.auth.currentUser!.phoneNumber!,
        isGroup: true);
    groupNameViewModel!.isLoading = false;
    controller!.update();
  }
}
