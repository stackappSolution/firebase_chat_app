import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/edit_profile/edit_profile_about_screen/edit_profile_about_controller.dart';
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

    return GetBuilder(
      init: EditProfileAboutController(),
      builder: (EditProfileAboutController controller) {
        return Scaffold(
          appBar: getAppBar(context),
          body: getBody(controller, context),
          floatingActionButton: getFloatingActionButton(),
        );
      },
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

  Column getBody(EditProfileAboutController controller, context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 15.px),
          child: SizedBox(
            height: 40.px,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.px),
                    child: TextField(
                      autofocus: true,
                      controller:
                          editProfileAboutScreenViewModel!.captionController,
                      decoration: const InputDecoration(
                        hintText: 'Write a few words about yourself...',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.px),
                  child: IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      editProfileAboutScreenViewModel!.captionController.text =
                          '';
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(10.px),
            itemCount: editProfileAboutScreenViewModel!.caption.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 50.px,
                child: InkWell(
                  onTap: () {
                    editProfileAboutScreenViewModel!.captionController.text =
                        '${editProfileAboutScreenViewModel!.icon[index]} ${editProfileAboutScreenViewModel!.caption[index]}';

                    controller.update();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10.px),
                        child: AppText(
                          editProfileAboutScreenViewModel!.icon[index],
                          fontSize: 25,
                        ),
                      ),
                      AppText(
                        editProfileAboutScreenViewModel!.caption[index],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  AppAppBar getAppBar(context) {
    return AppAppBar(
      leadingWidth: 50.px,
      title: AppText('About', fontSize: 19.px),
      leading: Padding(
        padding: EdgeInsets.only(left: 15.px),
        child: IconButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Get.to(EditProfileScreen());
          },
          icon: const Icon(
            Icons.arrow_back_sharp,
          ),
        ),
      ),
    );
  }
}
