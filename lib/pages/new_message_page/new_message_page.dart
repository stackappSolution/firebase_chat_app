import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textform_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/new_message_controller.dart';
import 'package:signal/pages/new_message_page/new_message_view_model.dart';
import 'package:signal/routes/routes_helper.dart';

class NewMessagePage extends StatelessWidget {
  NewMessagePage({super.key});

  NewMessageViewModel? newMessageViewModel;

  @override
  Widget build(BuildContext context) {
    newMessageViewModel ?? (newMessageViewModel = NewMessageViewModel(this));
    newMessageViewModel!.getPermission();
    return GetBuilder<NewMessageController>(
      init: NewMessageController(),
      initState: (state) {},
      builder: (NewMessageController controller) {
        return SafeArea(
            child: Scaffold(
                backgroundColor: AppColorConstant.appWhite,
                appBar: buildAppBar(),
                body: buildSearchBar()));
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
              padding: EdgeInsets.all(20.px),
              child: SizedBox(
                height: 50.px,
                child: AppTextFormField(
                  onChanged: (value) {
                    newMessageViewModel!.newMessageController!
                        .setFilterText(value);
                  },
                  controller: newMessageViewModel!.textController,
                  suffixIcon: InkWell(
                    onTap: () {
                      newMessageViewModel!.toggleIcon();
                      newMessageViewModel!.newMessageController!.update();
                    },
                    child: (newMessageViewModel!.isIcon)
                        ? const Icon(Icons.dialpad)
                        : const Icon(Icons.keyboard),
                  ),
                  keyboardType: newMessageViewModel!.getKeyboardType(),
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
            buildContactList(),
          ],
        ),
      );

  buildContactList() {
    onSearchContacts();
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: newMessageViewModel!.filterContacts.length,
      itemBuilder: (context, index) {
        Contact contact = newMessageViewModel!.filterContacts[index];
        String? mobileNumber =
        contact.phones!.isNotEmpty ? contact.phones!.first.value : 'N/A';
        String? displayName = contact.displayName ?? 'unknown';
        String firstLetter = displayName.substring(0, 1).toUpperCase();
        return Container(
            margin: EdgeInsets.only(top: 5.px),
            child: ListTile(
              leading: InkWell(
                onTap: () {
                  Get.toNamed(RouteHelper.getChatProfileScreen());
                },
                child: CircleAvatar(
                  maxRadius: 30.px,
                  backgroundColor: AppColorConstant.appYellow.withOpacity(0.8),
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
    );
  }

  onSearchContacts() {
    newMessageViewModel!.filterContacts =
        newMessageViewModel!.contacts.where((contact) {
      final lowerCaseQuery = newMessageViewModel!
          .newMessageController!.filteredValue
          .toLowerCase();
      return contact.displayName!.toLowerCase().contains(lowerCaseQuery) ||
          contact.phones!.any(
              (phone) => phone.value!.toLowerCase().contains(lowerCaseQuery));
    }).toList();
  }
}
