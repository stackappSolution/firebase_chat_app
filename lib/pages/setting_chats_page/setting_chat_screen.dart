import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/setting_chats_controller.dart';
import 'package:signal/pages/setting_chats_page/setting_chats_view_model.dart';

class SettingChatScreen extends StatelessWidget {
  SettingChatScreen({super.key});

  SettingChatsViewModel? settingChatsViewModel;

  @override
  Widget build(BuildContext context) {
    settingChatsViewModel ?? (settingChatsViewModel = SettingChatsViewModel(this));
    return GetBuilder(
      init: SettingChatsController(),
      initState: (state) {

      },
      builder: (SettingChatsController controller) {
        return SafeArea(
            child: Scaffold(
          backgroundColor: AppColorConstant.appWhite,
          appBar: buildAppBar(),
          body: buildChatsScreen(controller),
        ));
      },
    );
  }

  buildAppBar() => PreferredSize(
        preferredSize: Size.fromHeight(70.px),
        child: AppBar(
          backgroundColor: AppColorConstant.appWhite,
          title: const AppText('Chats'),
        ),
      );

  buildChatsScreen(SettingChatsController controller) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: AppText(StringConstant.generateLink, fontSize: 16.px),
                subtitle: AppText(StringConstant.generateLinkDis,
                    fontSize: 12.px, color: Colors.black.withOpacity(0.6)),
                trailing:  InkWell(onTap:() {
                  settingChatsViewModel!.generateLink = !settingChatsViewModel!.generateLink;
                  controller.update();
                },
                  child: Container(
                    padding: (settingChatsViewModel!.generateLink)
                        ? EdgeInsets.all(3.px)
                        : EdgeInsets.all(5.px),
                    alignment: (settingChatsViewModel!.generateLink)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    height: 35.px,
                    width: 60.px,
                    decoration: BoxDecoration(
                        color: (settingChatsViewModel!.generateLink)
                            ? AppColorConstant.blue
                            : AppColorConstant.blackOff.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(27.px),
                        border: Border.all(
                            color: Colors.grey.shade600, width: 1.px)),
                    child: Container(
                      height: (settingChatsViewModel!.generateLink)
                          ? 23.px
                          : 19.px,
                      width: (settingChatsViewModel!.generateLink)
                          ? 23.px
                          : 19.px,
                      decoration: BoxDecoration(
                          color: (settingChatsViewModel!.generateLink)
                              ? AppColorConstant.appWhite
                              : AppColorConstant.blackOff,
                          shape: BoxShape.circle),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.px,
              ),
              ListTile(
                title: AppText(StringConstant.useAddressBook, fontSize: 16.px),
                subtitle: AppText(
                  StringConstant.useAddressBookDis,
                  fontSize: 12.px,
                  color: Colors.black.withOpacity(0.6),
                ),
                trailing: InkWell(onTap:() {
                  settingChatsViewModel!.useAddressBook = !settingChatsViewModel!.useAddressBook;
                  controller.update();
                },
                  child: Container(
                    padding: (settingChatsViewModel!.useAddressBook)
                        ? EdgeInsets.all(3.px)
                        : EdgeInsets.all(5.px),
                    alignment: (settingChatsViewModel!.useAddressBook)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    height: 35.px,
                    width: 60.px,
                    decoration: BoxDecoration(
                        color: (settingChatsViewModel!.useAddressBook)
                            ? AppColorConstant.blue
                            : AppColorConstant.blackOff.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(27.px),
                        border: Border.all(
                            color: Colors.grey.shade600, width: 1.px)),
                    child: Container(
                      height: (settingChatsViewModel!.useAddressBook)
                          ? 23.px
                          : 19.px,
                      width: (settingChatsViewModel!.useAddressBook)
                          ? 23.px
                          : 19.px,
                      decoration: BoxDecoration(
                          color: (settingChatsViewModel!.useAddressBook)
                              ? AppColorConstant.appWhite
                              : AppColorConstant.blackOff,
                          shape: BoxShape.circle),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.px,
              ),
              ListTile(
                title: AppText(StringConstant.keepMuted, fontSize: 16.px),
                subtitle: AppText(
                  StringConstant.keepMutedDis,
                  fontSize: 12.px,
                  color: Colors.black.withOpacity(0.6),
                ),
                trailing:   InkWell(onTap:() {
                  settingChatsViewModel!.keepMuted = !settingChatsViewModel!.keepMuted;
                  controller.update();
                },
                  child: Container(
                    padding: (settingChatsViewModel!.keepMuted)
                        ? EdgeInsets.all(3.px)
                        : EdgeInsets.all(5.px),
                    alignment: (settingChatsViewModel!.keepMuted)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    height: 35.px,
                    width: 60.px,
                    decoration: BoxDecoration(
                        color: (settingChatsViewModel!.keepMuted)
                            ? AppColorConstant.blue
                            : AppColorConstant.blackOff.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(27.px),
                        border: Border.all(
                            color: Colors.grey.shade600, width: 1.px)),
                    child: Container(
                      height: (settingChatsViewModel!.keepMuted)
                          ? 23.px
                          : 19.px,
                      width: (settingChatsViewModel!.keepMuted)
                          ? 23.px
                          : 19.px,
                      decoration: BoxDecoration(
                          color: (settingChatsViewModel!.keepMuted)
                              ? AppColorConstant.appWhite
                              : AppColorConstant.blackOff,
                          shape: BoxShape.circle),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.px,
              ),
              Divider(
                height: 3.px,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10.px,
              ),
              ListTile(
                title: AppText(StringConstant.keyBoard, fontSize: 16.px),
              ),
              ListTile(
                title: AppText(StringConstant.useEmoji, fontSize: 16.px),
                trailing:   InkWell(onTap:() {
                  settingChatsViewModel!.systemEmoji = !settingChatsViewModel!.systemEmoji;
                  controller.update();
                },
                  child: Container(
                    padding: (settingChatsViewModel!.systemEmoji)
                        ? EdgeInsets.all(3.px)
                        : EdgeInsets.all(5.px),
                    alignment: (settingChatsViewModel!.systemEmoji)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    height: 35.px,
                    width: 60.px,
                    decoration: BoxDecoration(
                        color: (settingChatsViewModel!.systemEmoji)
                            ? AppColorConstant.blue
                            : AppColorConstant.blackOff.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(27.px),
                        border: Border.all(
                            color: Colors.grey.shade600, width: 1.px)),
                    child: Container(
                      height: (settingChatsViewModel!.systemEmoji)
                          ? 23.px
                          : 19.px,
                      width: (settingChatsViewModel!.systemEmoji)
                          ? 23.px
                          : 19.px,
                      decoration: BoxDecoration(
                          color: (settingChatsViewModel!.systemEmoji)
                              ? AppColorConstant.appWhite
                              : AppColorConstant.blackOff,
                          shape: BoxShape.circle),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.px,
              ),
              ListTile(
                title: AppText(StringConstant.keySend, fontSize: 16.px),
                trailing:   InkWell(onTap:() {
                  settingChatsViewModel!.keySends = !settingChatsViewModel!.keySends;
                  controller.update();
                },
                  child: Container(
                    padding: (settingChatsViewModel!.keySends)
                        ? EdgeInsets.all(3.px)
                        : EdgeInsets.all(5.px),
                    alignment: (settingChatsViewModel!.keySends)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    height: 35.px,
                    width: 60.px,
                    decoration: BoxDecoration(
                        color: (settingChatsViewModel!.keySends)
                            ? AppColorConstant.blue
                            : AppColorConstant.blackOff.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(27.px),
                        border: Border.all(
                            color: Colors.grey.shade600, width: 1.px)),
                    child: Container(
                      height: (settingChatsViewModel!.keySends)
                          ? 23.px
                          : 19.px,
                      width: (settingChatsViewModel!.keySends)
                          ? 23.px
                          : 19.px,
                      decoration: BoxDecoration(
                          color: (settingChatsViewModel!.keySends)
                              ? AppColorConstant.appWhite
                              : AppColorConstant.blackOff,
                          shape: BoxShape.circle),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.px,),
              Divider(
                height: 3.px,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10.px,
              ),
              ListTile(
                title: AppText(StringConstant.backups,
                    fontSize: 16.px, fontWeight: FontWeight.w600),
              ),
              ListTile(
                title: AppText(
                  StringConstant.chatBackups,
                  fontSize: 16.px,
                ),
                subtitle: AppText(StringConstant.disabled,
                    fontSize: 12.px, color: Colors.black.withOpacity(0.6)),
              ),
            ],
          ),
        ),
      );
}
