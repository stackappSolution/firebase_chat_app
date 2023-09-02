import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textform_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/new_group_controller.dart';
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
      initState: (state) async {

      },
      init: GroupController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppAppBar(
              title: AppText(
            StringConstant.selectMember,
            fontSize: 22.px,
          )),
          floatingActionButton: buildFloatingActionButton(),
          body: Padding(
            padding: EdgeInsets.only(left: 15.px, right: 15.px, top: 10.px),
            child: Column(children: [
              SizedBox(
                height: 40.px,
                child: AppTextFormField(
                  decoration: InputDecoration(
                      hintText: 'search Name or Number',
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(50.px)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20.px)),
                  suffixIcon: Icon(
                    Icons.dialpad,
                    size: 12.px,
                    color: AppColorConstant.appYellow,
                  ),
                ),
              ),
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
                      return Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(10),
                        height: 20.px,
                        width: 200.px,
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
                                    controller.update();
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    size: 15.px,
                                  ))
                            ]),
                      );
                    },
                  ),
                ),
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AppText(
                      StringConstant.contacts,
                    ),
                  )),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.px),
                  child: ListView.builder(
                    itemCount: newGroupViewModel!.contacts.length,
                    itemBuilder: (context, index) {
                      Contact contact = newGroupViewModel!.contacts[index];
                      String? mobileNumber = contact.phones!.isNotEmpty
                          ? contact.phones!.first.value
                          : 'N/A';
                      String? displayName = contact.displayName ?? 'unknown';
                      String firstLetter =
                          displayName.substring(0, 1).toUpperCase();

                      newGroupViewModel!.isChecked = List.filled(
                          newGroupViewModel!.contacts.length, false);

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
                                AppText(
                                  displayName,
                                  color: AppColorConstant.darkPrimary,
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
                                    side: const BorderSide(
                                        width: 1,
                                        color: AppColorConstant.blackOff),
                                    value: newGroupViewModel!.isChecked[index],
                                    onChanged: (value) {
                                      newGroupViewModel!.isChecked[index] =
                                          value!;
                                      logs(
                                          'isChecked-----> ${newGroupViewModel!.isChecked}');

                                      if (newGroupViewModel!.isChecked[index] ==
                                          true) {
                                        newGroupViewModel!.groupMembers
                                            .add(contact);
                                        controller.update();
                                      }

                                      logs(
                                          'members---> ${newGroupViewModel!.groupMembers.length}');
                                    },
                                    checkColor: Colors.white,
                                    activeColor: Colors.blue,
                                    tristate: false,
                                    visualDensity: VisualDensity.compact,
                                    shape: const CircleBorder(),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
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
    return FloatingActionButton(
      backgroundColor: AppColorConstant.appYellow,
      onPressed: () {
        Get.toNamed(RouteHelper.getGroupNameScreen(),
            arguments: newGroupViewModel!.groupMembers);
      },
      child: (newGroupViewModel!.groupMembers.isNotEmpty)
          ? const Icon(
              Icons.navigate_next,
              color: AppColorConstant.appWhite,
            )
          : const AppText(
              'Skip',
              color: AppColorConstant.appWhite,
            ),
    );
  }
}
