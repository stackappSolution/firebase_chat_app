import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_button.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/invite_controller.dart';
import 'package:signal/pages/invite/invite_view_model.dart';

class InviteMemberScreen extends StatelessWidget {
  InviteMemberScreen({Key? key}) : super(key: key);

  InviteViewModel? inviteViewModel;

  @override
  Widget build(BuildContext context) {
    inviteViewModel ?? (inviteViewModel = InviteViewModel(this));

    return GetBuilder<InviteController>(
      init: InviteController(),
      initState: (state) {
        inviteViewModel!.parameter = Get.parameters;

      },
      builder: (controller) {
        return Scaffold(
          appBar: getAppbar(),
          body: buildInviteView(
              inviteViewModel!.parameter['firstLetter'],
              inviteViewModel!.parameter['displayName'],
              inviteViewModel!.parameter['phoneNo']),
        );
      },
    );
  }

  getAppbar() {
    return AppAppBar(
      leadingWidth: 110.px,
      leading: Padding(
        padding: EdgeInsets.all(5.px),
        child: CircleAvatar(
          maxRadius: 20.px,
          backgroundColor: AppColorConstant.appYellow,
          child: AppText(inviteViewModel!.parameter['firstLetter'],
              color: AppColorConstant.appWhite),
        ),
      ),
      title: AppText(
        inviteViewModel!.parameter['displayName'],
        color: AppColorConstant.appBlack,
      ),
    );
  }

  buildInviteView(
    String firstLetter,
    String displayName,
    String phoneNo,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 30.px,
        ),
        CircleAvatar(
          maxRadius: 50.px,
          backgroundColor: AppColorConstant.appYellow.withOpacity(0.5),
          child: AppText(firstLetter,
              fontSize: 40.px, color: AppColorConstant.appWhite),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.px),
          child: AppText(
            displayName,
            fontSize: 20.px,
            textAlign: TextAlign.center,
          ),
        ),
        AppText(phoneNo,
            fontSize: 12.px,
            textAlign: TextAlign.center,
            color: AppColorConstant.appGrey),
        SizedBox(
          height: 300.px,
        ),
        AppText(
          'Invite ${inviteViewModel!.parameter['phoneNo']} to Signal to keep Conversation here',
          textAlign: TextAlign.center,
          color: AppColorConstant.appGrey,
        ),
        Padding(
          padding: EdgeInsets.all(20.px),
          child: AppButton(
              onTap: () async {
                inviteViewModel!.inviteFriends();
              },
              borderRadius: BorderRadius.circular(18.px),
              height: 40.px,
              width: 180.px,
              color: AppColorConstant.appYellow,
              stringChild: true,
              child: const AppText("Invite To signal",
                  color: AppColorConstant.appWhite)),
        ),
      ],
    );
  }


}
