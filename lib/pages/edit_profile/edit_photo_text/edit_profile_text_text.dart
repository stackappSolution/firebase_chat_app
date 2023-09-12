import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';

import '../../../app/widget/app_elevated_button.dart';
import 'edit_profile_text_controller.dart';
import 'edit_profile_text_view_model.dart';

class EditProfileTextText extends StatelessWidget {
  EditProfileTextViewModel? editProfileTextViewModel;

  EditProfileTextText({super.key});

  @override
  Widget build(BuildContext context) {
    editProfileTextViewModel ??
        (editProfileTextViewModel = EditProfileTextViewModel(this));
    return GetBuilder(
        init: EditProfileTextController(),
        builder: (EditProfileTextController controller) {
          return Scaffold(
            body: getBody(),
            floatingActionButton: getFloatingActionButton(),
          );
        });
  }

  getFloatingActionButton() {
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

  getBody() {
    return Padding(
      padding: EdgeInsets.only(top: 15.px, bottom: 15.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 70.px,
            child: Padding(
              padding: EdgeInsets.all(8.0.px),
              child: TextField(
                controller: editProfileTextViewModel!.textEditingController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                ],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 55.px),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
