import 'package:flutter/material.dart';
import 'package:signal/controller/edit_profile_controller.dart';

import 'edit_profile_screen.dart';

class EditProfileViewModel {
  EditProfileScreen? editProfileScreen;
  EditProfileController? editProfileController;

  EditProfileViewModel(this.editProfileScreen) {}

  aboutTap(BuildContext context) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter something...',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Do something with the entered text
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          );
        },
      );
  }
}
