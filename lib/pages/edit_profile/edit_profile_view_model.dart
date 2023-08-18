import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_textform_field.dart';
import 'package:signal/controller/edit_profile_controller.dart';

import 'edit_profile_screen.dart';

class EditProfileViewModel {
  EditProfileScreen? editProfileScreen;
  EditProfileController? editProfileController;

  EditProfileViewModel(this.editProfileScreen) {}

  AboutTap(BuildContext context) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter something...',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Do something with the entered text
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          );
        },
      );
  }
}
