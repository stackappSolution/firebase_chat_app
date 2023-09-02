import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';

class InviteScreen extends StatelessWidget {
  const InviteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstant.appWhite,
      appBar: getAppbar(),
      body: getBody(),
    );
  }

  getAppbar() {
    return const AppAppBar(
      title: AppText('Invite Friends'),
    );
  }

  getBody() {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20.px,top: 20.px),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.px),
            color: AppColorConstant.appYellow.withOpacity(0.1),
          ),
          height: 100.px,
          width: double.infinity,
          margin: EdgeInsets.all(15.px),
          child: const AppText(
            'Lets switch to signal: \n http://signal.org/install',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              Share.share('Visit Signal at http://signal.org/install');
            },
            leading: const Icon(
              Icons.share,
              color: AppColorConstant.appBlack,
            ),
            title: const AppText('Share'),
          ),
        )
      ],
    );
  }
}
