import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_elevated_button.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/edit_profile_about_controller.dart';
import 'package:signal/pages/edit_profile/edit_profile_about_screen/edit_profile_about_screen_view_model.dart';

import '../../../service/network_connectivity.dart';
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

  Stack getBody(EditProfileAboutController controller, context) {
    Color primaryTheme = Theme.of(context).colorScheme.primary;
    Color secondaryTheme = Theme.of(context).colorScheme.secondary;
    return Stack(
      children: [
        Padding(
          padding:  EdgeInsets.all(15.px),
          child: Column(
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
                            onChanged: (value) {
                              editProfileAboutScreenViewModel!
                                      .captionController.selection =
                                  TextSelection.collapsed(
                                      offset: editProfileAboutScreenViewModel!
                                          .captionController.text.length);
                            },
                            autofocus: false,
                            controller: editProfileAboutScreenViewModel!
                                .captionController,
                            decoration: InputDecoration(
                              hintText: 'Write a few words about yourself...',
                              hintStyle: TextStyle(color: secondaryTheme),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.px, vertical: 40.px),
                  itemCount: editProfileAboutScreenViewModel!.caption.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 50.px,
                      child: InkWell(
                        onTap: () {
                          editProfileAboutScreenViewModel!
                                  .captionController.text =
                              editProfileAboutScreenViewModel!.caption[index];
                          editProfileAboutScreenViewModel!
                                  .captionController.selection =
                              TextSelection.collapsed(
                                  offset: editProfileAboutScreenViewModel!
                                      .captionController.text.length);
                          controller.update();
                        },
                        child: AppText(
                            editProfileAboutScreenViewModel!.caption[index],color: primaryTheme,
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
                        color: AppColorConstant.appWhite, fontSize: 18.px),
                    isBorderShape: true,
                    buttonColor: AppColorConstant.appYellow),
              ),
            ],
          ),
        ),
        if (editProfileAboutScreenViewModel!.isLoading)  AppLoader()
      ],
    );
  }

  getAppBar(context) {
    Color primaryTheme = Theme.of(context).colorScheme.primary;
    Color secondaryTheme = Theme.of(context).colorScheme.secondary;
    return AppAppBar(
      leadingWidth: 50.px,backgroundColor: primaryTheme,
      title: AppText('About', fontSize: 19.px,color: primaryTheme),
    );
  }
}
