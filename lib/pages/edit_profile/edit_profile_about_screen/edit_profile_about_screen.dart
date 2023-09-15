import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/edit_profile/edit_profile_about_screen/edit_profile_about_controller.dart';
import 'package:signal/pages/edit_profile/edit_profile_about_screen/edit_profile_about_screen_view_model.dart';

import '../edit_profile_screen.dart';

class EditProfileAboutScreen extends StatelessWidget {
  EditProfileAboutScreenViewModel? editProfileAboutScreenViewModel;
  String data;

  EditProfileAboutScreen(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    editProfileAboutScreenViewModel ??
        (editProfileAboutScreenViewModel =
            EditProfileAboutScreenViewModel(this));

    return GetBuilder(
      init: EditProfileAboutController(),
      initState: (state) {
        editProfileAboutScreenViewModel!.captionController.text = data;
      },
      builder: (EditProfileAboutController controller) {
        return Scaffold(
          appBar: getAppBar(context),
          body: getBody(controller, context),
        );
      },
    );
  }

  getBody(EditProfileAboutController controller, context) {
    return Padding(
      padding: EdgeInsets.all(15.px),
      child: Stack(
        children: [
          Column(
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
                            autofocus: false,
                            controller: editProfileAboutScreenViewModel!
                                .captionController,
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
                            editProfileAboutScreenViewModel!
                                .captionController.text = '';
                          },
                          icon: const Icon(Icons.close),
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
                          editProfileAboutScreenViewModel!
                                  .captionController.text =
                              editProfileAboutScreenViewModel!.caption[index];
                          controller.update();
                        },
                        child: AppText(
                            editProfileAboutScreenViewModel!.caption[index],
                            fontSize: 18.px,
                            fontWeight: FontWeight.w100),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.px, right: 15.px),
                child: AppElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      editProfileAboutScreenViewModel!.updateAbout();
                    },
                    buttonHeight: 45.px,
                    widget: AppText('Save',
                        color: AppColorConstant.appWhite, fontSize: 22.px),
                    isBorderShape: true,
                    buttonColor: AppColorConstant.appYellow),
              ),
            ],
          ),
          if (editProfileAboutScreenViewModel!.isLoading) const AppLoader()
        ],
      ),
    );
  }

  getAppBar(context) {
    return AppAppBar(
      leadingWidth: 50.px,
      title: AppText('About', fontSize: 19.px),
    );
  }
}
