import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/edit_profile/edit_profile_about_screen/edit_profile_about_screen_view_model.dart';

import '../edit_profile_screen.dart';

class EditProfileAboutScreen extends StatelessWidget {
  EditProfileAboutScreenViewModel? editProfileAboutScreenViewModel;

  EditProfileAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    editProfileAboutScreenViewModel ??
        (editProfileAboutScreenViewModel =
            EditProfileAboutScreenViewModel(this));

    return Scaffold(
      appBar: getAppBar(),
      body: getBody(),
      floatingActionButton: getFloatingActionButton(),
    );
  }

  AppElevatedButton getFloatingActionButton() {
    return AppElevatedButton(
        buttonHeight: 40.px,
        buttonWidth: 80.px,
        widget: AppText(
          'Save',
          color: AppColorConstant.appWhite,
          fontSize: 20.px,
        ),
        isBorderShape: true,
        buttonColor: AppColorConstant.appYellow);
  }

  Column getBody() {
    return Column(
      children: [
        SizedBox(
          height: 40.px,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 6.px),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_reaction_outlined,
                    size: 25.px,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller:
                      editProfileAboutScreenViewModel!.captionController,
                  decoration: InputDecoration(
                    hintText: 'Write a few words about yourself...',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.px),
                child: IconButton(
                  onPressed: () {
                    editProfileAboutScreenViewModel!.captionController.text =
                        '';
                  },
                  icon: Icon(
                    Icons.close,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: ListView.builder(
          padding: EdgeInsets.all(10.px),
          itemCount: editProfileAboutScreenViewModel!.caption.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 50.px,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10.px),
                    child: AppText(editProfileAboutScreenViewModel!.icon[index],
                        fontSize: 25),
                  ),
                  AppText(editProfileAboutScreenViewModel!.caption[index]),
                ],
              ),
            );
          },
        ))
      ],
    );
  }

  AppAppBar getAppBar() {
    return AppAppBar(
      leadingWidth: 50.px,
      title: AppText('About', fontSize: 19.px),
      leading: Padding(
        padding: EdgeInsets.only(left: 15.px),
        child: IconButton(
          onPressed: () {
            Get.to(EditProfileScreen());
          },
          icon: Icon(
            Icons.arrow_back_sharp,
          ),
        ),
      ),
    );
  }
}
