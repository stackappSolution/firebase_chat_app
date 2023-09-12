import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/app/widget/app_textform_field.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/pages/edit_profile/edit_profile_name_screen/edit_profile_name_controller.dart';
import 'package:signal/pages/edit_profile/edit_profile_name_screen/edit_profile_name_screen_view_model.dart';
import 'package:signal/pages/edit_profile/edit_profile_screen.dart';


class EditProfileNameScreen extends StatelessWidget {
  EditProfileNameScreenViewModel? editProfileNameScreenViewModel;

  EditProfileNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    editProfileNameScreenViewModel ??
        (editProfileNameScreenViewModel = EditProfileNameScreenViewModel(this));
    return GetBuilder<EditProfileNameController>(
      init: EditProfileNameController(),
      builder: (EditProfileNameController controller) {
        return Scaffold(
          appBar: getAppBar(),
          body: getBody(context, controller),
          floatingActionButton: getFloatingActionButton(context),
        );
      },
    );
  }

  getFloatingActionButton(context) {
    return AppElevatedButton(
      buttonHeight: 40.px,
      buttonWidth: 80.px,
      widget: AppText(
        'Save',
        color: AppColorConstant.appWhite,
        fontSize: 20.px,
      ),
      isBorderShape: true,
      buttonColor: (editProfileNameScreenViewModel!.isButtonActive &&
              editProfileNameScreenViewModel!.isLoading == false)
          ? AppColorConstant.appYellow
          : AppColorConstant.appYellow.withOpacity(0.5),
      onPressed: (editProfileNameScreenViewModel!.isButtonActive &&
              editProfileNameScreenViewModel!.isLoading == false)
          ? () {}
          : null,
    );
  }

  getBody(BuildContext context, EditProfileNameController controller) {
    return Padding(
      padding: EdgeInsets.all(10.px),
      child: Column(
        children: [
          AppTextFormField(
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
              controller: editProfileNameScreenViewModel!.lastNameController,
              labelText: S.of(context).lastName,
              fontSize: null,
            ),
          ),
          SizedBox(
            height: 160.px,
          ),
        ],
      ),
    );
  }

  getAppBar() {
    return AppAppBar(
      title: AppText(
        'me',
        fontSize: 19.px,
      ),
      leading: Padding(
        padding: EdgeInsets.only(left: 15.px),
        child: IconButton(
          onPressed: () {
            Get.to(EditProfileScreen());
          },
          icon: Icon(
            Icons.close,
          ),
        ),
      ),
    );
  }
}
