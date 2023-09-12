import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/edit_profile/edit_photo_text/edit_profile_text_color.dart';
import 'package:signal/pages/edit_profile/edit_photo_text/edit_profile_text_text.dart';

class EditProfileText extends StatelessWidget {
  EditProfileText({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(elevation: 0.5,
          backgroundColor: AppColorConstant.appWhite,
          bottom: const TabBar(
            tabs: [
              Tab(icon: AppText('Text')),
              Tab(icon: AppText('Color')),
            ],
          ),
          title: const AppText('Preview',fontSize: 20),
        ),
        body: TabBarView(
          children: [ EditProfileTextText(), EditProfileTextColor()],
        ),
      ),
    );
  }
}
