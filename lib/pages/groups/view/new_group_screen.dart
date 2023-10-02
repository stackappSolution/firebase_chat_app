import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_checkbox.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textform_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/new_group_controller.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/groups/view/new_group_view_model.dart';
import 'package:signal/routes/routes_helper.dart';

// ignore: must_be_immutable
class NewGroupScreen extends StatelessWidget {
  NewGroupViewModel? newGroupViewModel;

  NewGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    newGroupViewModel ?? (newGroupViewModel = NewGroupViewModel(this));
    newGroupViewModel!.fetchContacts();
    return GetBuilder<GroupController>(
      initState: (state) async {},
      init: GroupController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppAppBar(
              title: AppText(
            S.of(context).selectMember,
            fontSize: 22.px,
            color: Theme.of(context).colorScheme.primary,
          )),
          floatingActionButton: buildFloatingActionButton(),
          body: Padding(
            padding: EdgeInsets.only(left: 15.px, right: 15.px, top: 10.px),
            child: Column(children: [
              SizedBox(
                height: 40.px,
                child: AppTextFormField(
                  onChanged: (value) {
                    newGroupViewModel!.searchController.text;
                    newGroupViewModel!.filterContacts(value);
                  },
                  controller: newGroupViewModel!.searchController,
                  keyboardType: newGroupViewModel!.getKeyboardType(),
                  decoration: InputDecoration(
                      hintText: S.of(context).searchNameOrNumber,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(50.px)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20.px)),
                ),
              ),
              if(newGroupViewModel!.selectedItemsIndex.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.px),
                child: SizedBox(
                  height: 60.px,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: newGroupViewModel!.groupMembers.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      Contact contact = newGroupViewModel!.groupMembers[index];
                      String? displayName = contact.displayName ?? 'unknown';
                      String firstLetter =
                          displayName.substring(0, 1).toUpperCase();
                      return Padding(
                        padding: EdgeInsets.all(12.px),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: AppColorConstant.yellowLight,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.px))),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(5.px),
                                  height: 200.px,
                                  width: 20.px,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColorConstant.appYellow),
                                  child: AppText(firstLetter,
                                      fontSize: 10.px,
                                      color: AppColorConstant.appWhite),
                                ),
                                AppText(displayName,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 12.px),
                                IconButton(
                                    onPressed: () {
                                      newGroupViewModel!.groupMembers
                                          .remove(contact);
                                      newGroupViewModel!.selectedItems[
                                              newGroupViewModel!
                                                  .selectedItemsIndex[index]] =
                                          false;
                                      newGroupViewModel!.selectedItemsIndex
                                          .removeAt(index);
                                      logs(
                                          "index --- >  ${newGroupViewModel!.selectedItemsIndex.toString()}");
                                      logs(newGroupViewModel!.selectedItemsIndex
                                          .toString());
                                      logs(
                                          "length -- ${newGroupViewModel!.groupMembers.length}");

                                      controller.update();
                                    },
                                    icon: Icon(
                                      color: AppColorConstant.appBlack,
                                      Icons.clear,
                                      size: 15.px,
                                    ))
                              ]),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 12.px,horizontal: 12.px),
                    child: AppText(
                      S.of(context).contacts,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.px),
                  child: ListView.builder(
                    itemCount: newGroupViewModel!.isSearching == true
                        ? newGroupViewModel!.filteredContacts.length
                        : newGroupViewModel!.contacts.length,
                    itemBuilder: (context, index) {
                      final Contact contact = newGroupViewModel!.isSearching
                          ? newGroupViewModel!.filteredContacts[index]
                          : newGroupViewModel!.contacts[index];
                      String? mobileNumber = contact.phones!.isNotEmpty
                          ? contact.phones!.first.value
                          : 'N/A';
                      String? displayName = contact.displayName ?? 'unknown';
                      String firstLetter =
                          displayName.substring(0, 1).toUpperCase();

                      return Container(
                        margin: EdgeInsets.only(top: 10.px),
                        height: 50.px,
                        width: double.infinity,
                        child: Row(children: [
                          Container(
                            alignment: Alignment.center,
                            height: 35.px,
                            width: 35.px,
                            decoration: const BoxDecoration(
                                color: AppColorConstant.appYellow,
                                shape: BoxShape.circle),
                            child: AppText(firstLetter,
                                color: AppColorConstant.appWhite),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 13.px),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 200.px,
                                  child: AppText(
                                    displayName,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                AppText(
                                  mobileNumber!,
                                  color: AppColorConstant.darkSecondary,
                                  fontSize: 13.px,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(right: 0.px),
                                    child: Checkbox(
                                      onChanged: (value) {
                                        newGroupViewModel!
                                            .selectedItems[index] = value!;
                                        logs(
                                            'isChecked-----> ${newGroupViewModel!.selectedItems[index]}');
                                        if (newGroupViewModel!
                                                .selectedItems[index] ==
                                            true) {
                                          newGroupViewModel!.groupMembers
                                              .add(contact);
                                          newGroupViewModel!.selectedItemsIndex
                                              .add(index);
                                          logs(
                                              "selected Items Index -->  ${newGroupViewModel!.selectedItemsIndex}");
                                          logs(
                                              "lenth -- ${newGroupViewModel!.groupMembers.length}");

                                          controller.update();
                                        } else {
                                          newGroupViewModel!.groupMembers
                                              .remove(contact);
                                          controller.update();
                                          newGroupViewModel!.selectedItemsIndex
                                              .removeWhere((element) =>
                                                  element == index);
                                          logs(
                                              "selected Items Index -->  ${newGroupViewModel!.selectedItemsIndex}");
                                          logs(
                                              "lenth -- ${newGroupViewModel!.groupMembers.length}");
                                        }
                                      },
                                      value: newGroupViewModel!
                                          .selectedItems[index],
                                    )),
                              ],
                            ),
                          )
                        ]),
                      );
                    },
                  ),
                ),
              )
            ]),
          ),
        );
      },
    );
  }

  buildFloatingActionButton() {
    return (newGroupViewModel!.groupMembers.isNotEmpty)
        ? FloatingActionButton(
            backgroundColor: AppColorConstant.appYellow,
            onPressed: () {
              Get.toNamed(RouteHelper.getGroupNameScreen(),
                  arguments: newGroupViewModel!.groupMembers);
            },
            child: const Icon(
              Icons.navigate_next,
              color: AppColorConstant.appWhite,
            ))
        : const SizedBox();
  }
}
