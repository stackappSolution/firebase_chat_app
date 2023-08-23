import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';

class ChatProfileScreen extends StatelessWidget {
  const ChatProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstant.appWhite,
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  getAppBar() {
    return const AppAppBar();
  }

  getBody() {
    return ListView(
      children: [
        buildProfileView(),
      ],
    );
  }

  buildProfileView() {
    return Column(
      children: [
        SizedBox(
          height: 20.px,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            maxRadius: 40.px,
            backgroundColor: AppColorConstant.appYellow.withOpacity(0.2),
            child: AppText('SJ', fontSize: 30.px),
          ),
        ),
        AppText('Shyam Jethva', fontSize: 25.px),
        AppText('+91 9904780294',
            fontSize: 15.px, color: AppColorConstant.grey),
      ],
    );
  }

  buildMenu() {
    return Row(
      children: [
        Container(
          height: 40.px,
          width: 40.px,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.px),
              color: AppColorConstant.appYellow.withOpacity(0.2)),
        ),
      ],
    );
  }
}
