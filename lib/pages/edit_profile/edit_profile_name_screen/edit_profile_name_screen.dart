import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textform_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/edit_profile/edit_profile_name_screen/edit_profile_name_controller.dart';
import 'package:signal/pages/edit_profile/edit_profile_name_screen/edit_profile_name_screen_view_model.dart';
import 'package:signal/pages/settings/settings_screen.dart';
import 'package:signal/service/users_service.dart';

import '../../../service/network_connectivity.dart';

class EditProfileNameScreen extends StatelessWidget {
  EditProfileNameScreenViewModel? editProfileNameScreenViewModel;

  var data;

  EditProfileNameScreen(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    editProfileNameScreenViewModel ??
        (editProfileNameScreenViewModel = EditProfileNameScreenViewModel(this));
    return GetBuilder<EditProfileNameController>(
      init: EditProfileNameController(),
      initState: (state) {
        NetworkConnectivity.checkConnectivity(context);
        editProfileNameScreenViewModel!.firstNameController.text =
            data['firstName'];
        editProfileNameScreenViewModel!.lastNameController.text =
            data['lastName'];
      },
      builder: (EditProfileNameController controller) {
        return Scaffold(
          appBar: getAppBar(context),
          body: getBody(context, controller),
        );
      },
    );
  }

  getBody(BuildContext context, EditProfileNameController controller) {
    return Padding(
      padding: EdgeInsets.only(top: 25.px, left: 25.px, right: 25.px),
      child: Stack(
        children: [Column(
          children: [
            AppTextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(15),
              ],
              controller: editProfileNameScreenViewModel!.firstNameController,
              labelText: S.of(context).firstName,
              onChanged: (value) {
                editProfileNameScreenViewModel!
                    .onChangedValue(value, controller, context);
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 5.px,
                ),
                child: AppText(
                  editProfileNameScreenViewModel!.errorFirstName,
                  color: AppColorConstant.red,
                  fontSize: 10.px,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10.px,
              ),
              child: AppTextFormField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(15),
                ],
                controller: editProfileNameScreenViewModel!.lastNameController,
                labelText: S.of(context).lastName,
                fontSize: null,
              ),
            ),
            const Spacer(),
            AppElevatedButton(
                onPressed: () {
                  editProfileNameScreenViewModel!.updateUserName(
                      editProfileNameScreenViewModel!.firstNameController.text,
                      editProfileNameScreenViewModel!.lastNameController.text,controller);
                  controller.update();
                },
                buttonHeight: 45.px,
                widget: AppText(
                  'Save',
                  color: AppColorConstant.appWhite,
                  fontSize: 22.px,
                ),
                isBorderShape: true,
                buttonColor: AppColorConstant.appYellow),
            SizedBox(
              height: 25.px,
            )
          ],
        ),
          if(editProfileNameScreenViewModel!.isLoading)
            AppLoader()
        ],
      ),
    );
  }

  getAppBar(context) {
    return AppAppBar(
      title: AppText(
        'Your Name',
        fontSize: 19.px,
      ),
    );
  }
}
