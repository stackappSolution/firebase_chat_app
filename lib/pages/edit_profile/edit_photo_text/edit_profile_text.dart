import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/edit_profile/edit_photo_text/edit_profile_text_controller.dart';
import 'package:signal/pages/edit_profile/edit_photo_text/edit_profile_text_view_model.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../../app/app/utills/app_utills.dart';
import '../../../app/widget/app_elevated_button.dart';

class EditProfileText extends StatelessWidget {
  EditProfileTextViewModel? editProfileTextViewModel;

  EditProfileText({super.key});

  @override
  Widget build(BuildContext context) {
    editProfileTextViewModel ??
        (editProfileTextViewModel = EditProfileTextViewModel(this));
    return DefaultTabController(
      length: 2,
      child: GetBuilder<EditProfileTextController>(
          init: EditProfileTextController(),
          builder: (EditProfileTextController controller) {
            return Scaffold(
              appBar: getAppBar(context),
              body: Padding(
                padding: EdgeInsets.all(15.px),
                child: getBody(controller, context),
              ),
            );
          }),
    );
  }

  getBody(EditProfileTextController controller, context) {
    return Stack(
      children: [

          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.px, bottom: 15.px),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WidgetsToImage(
                      controller: editProfileTextViewModel!.controller,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: editProfileTextViewModel!.backGroud,
                        child: TextField(
                          cursorColor: Colors.transparent,
                          autofocus: true,
                          controller:
                              editProfileTextViewModel!.textEditingController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
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
              ),
              SizedBox(
                height: 80.px,
              ),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: editProfileTextViewModel!.chatColors.length,
                  padding: EdgeInsets.only(right: 10.px, left: 10.px),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(10.px),
                      child: InkWell(
                        onTap: () {
                          editProfileTextViewModel!.backGroud =
                              editProfileTextViewModel!.chatColors[index];
                          controller.update();
                        },
                        child: (editProfileTextViewModel!.chatColors[index] ==
                                editProfileTextViewModel!.backGroud)
                            ? Container(
                                child: Container(
                                  height: 50.px,
                                  width: 50.px,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColorConstant.offBlack,
                                          width: 5.px),
                                      color: editProfileTextViewModel!
                                          .chatColors[index],
                                      shape: BoxShape.circle),
                                ),
                              )
                            : Container(
                                height: 50.px,
                                width: 50.px,
                                decoration: BoxDecoration(
                                  color: editProfileTextViewModel!
                                      .chatColors[index],
                                  shape: BoxShape.circle,
                                ),
                              ),
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
                      final bytes =
                          await editProfileTextViewModel!.controller.capture();
                      saveBytesToFile(bytes!, controller);
                    },
                    buttonHeight: 45.px,
                    widget: AppText(
                      'Save',
                      color: AppColorConstant.appWhite,
                      fontSize: 22.px,
                    ),
                    isBorderShape: true,
                    buttonColor: AppColorConstant.appYellow),
              ),
            ],
          ),
        if (editProfileTextViewModel!.isLoading)
          AppLoader(),
      ],
    );
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      backgroundColor: AppColorConstant.appWhite,
      title: const AppText(
        'Preview',
        fontSize: 20,
      ),
    );
  }

  void saveBytesToFile(
    Uint8List bytes,
    EditProfileTextController controller,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/your_file_name.extension');
    await file.writeAsBytes(bytes);
    logs('File saved at: ${file.path}');
    editProfileTextViewModel!.updateProfilePicture(file.path);
    controller.update();
  }
}
