import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textform_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/new_message_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/new_message_page/new_message_view_model.dart';

import '../../routes/routes_helper.dart';

class NewMessagePage extends StatelessWidget {
  NewMessagePage({super.key});

  NewMessageViewModel? newMessageViewModel;

  @override
  Widget build(BuildContext context) {
    newMessageViewModel ?? (newMessageViewModel = NewMessageViewModel(this));
    newMessageViewModel!.getPermission();
    return GetBuilder(
      init: NewMessageController(),
      initState: (state) {},
      builder: (NewMessageController controller) {
        return SafeArea(
            child: Scaffold(
          backgroundColor: AppColorConstant.appWhite,
          appBar: buildAppBar(),
          body: buildSearchBar(),
        ));
      },
    );
  }

  buildAppBar() => AppBar(
        backgroundColor: AppColorConstant.appWhite,
        title: AppText('New message', fontSize: 20.px),
      );

  buildSearchBar() => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.all(20.px),
              child: Container(
                height: 50.px,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),),
                child: AppTextFormField(
                  suffixIcon: const Icon(Icons.keyboard),
                 hintText: 'Search',
                  style: TextStyle(
                    fontSize: 22.px,
                    fontWeight: FontWeight.w400,
                  ),
                  fontSize: 20.px,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.px),
              child: ListTile(
                  title: AppText('New Group', fontSize: 18.px),
                  leading: CircleAvatar(
                    radius: 30.px,
                    backgroundColor:
                        AppColorConstant.appYellow.withOpacity(0.5),
                    child: const Icon(Icons.group,
                        color: AppColorConstant.appBlack),
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(20.px),
              child: AppText('Contacts', fontSize: 22.px),
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: newMessageViewModel!.contacts.length,
              itemBuilder: (context, index) {
                Contact contact = newMessageViewModel!.contacts[index];
                String? mobileNumber = contact.phones!.isNotEmpty
                    ? contact.phones!.first.value
                    : 'N/A';
                String? displayName = contact.displayName ?? 'unknown';
                String firstLetter = displayName.substring(0, 1).toUpperCase();
                return Container(
                    margin: EdgeInsets.only(top: 5.px),
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
                          child: AppText(
                            firstLetter,
                            color: AppColorConstant.appWhite,
                            fontSize: 22.px,
                          ),
                        ),
                      ),
                      title: AppText(
                        displayName,
                        fontSize: 15.px,
                      ),
                      subtitle: AppText(mobileNumber!,
                          color: AppColorConstant.grey, fontSize: 12.px),
                    ));
              },
            ),
          ],
        ),
      );
}
