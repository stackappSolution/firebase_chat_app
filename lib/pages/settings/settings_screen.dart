import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_image_assets.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/app_asset.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/constant/string_constant.dart';
import 'package:signal/controller/settings_controller.dart';
import 'package:signal/pages/edit_profile/edit_profile_screen.dart';
import 'package:signal/pages/settings/settings_view_model.dart';
import 'package:signal/generated/l10n.dart';
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/users_service.dart';

import '../../service/network_connectivity.dart';

// ignore: must_be_immutable
class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  SettingViewModel? settingViewModel;
  SettingsController? controller;

  @override
  Widget build(BuildContext context) {
    settingViewModel ?? (settingViewModel = SettingViewModel(this));
    logs('Current Screen---> $runtimeType');

    return GetBuilder<SettingsController>(
      initState: (state) {
        Future.delayed(
          const Duration(milliseconds: 0),
          () async {
            controller = Get.find<SettingsController>();
            controller!.update();
          },
        );
      },
      init: SettingsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: getAppbar(context),
          body: getBody(context, controller),
        );
      },
    );
  }

  getAppbar(context) {
    return AppAppBar(
      title: AppText(
        S.of(Get.context!).settings,
        fontSize: 20.px,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  getBody(BuildContext context, SettingsController controller) {
    return ListView(
      children: [
        SizedBox(
          height: 10.px,
        ),
        buildProfileView(context),
        SizedBox(
          height: 20.px,
        ),
        buildSettingsList(context, controller),
      ],
    );
  }

  buildProfileView(context) {
    Color primaryTheme = Theme.of(context).colorScheme.primary;
    Color secondaryTheme = Theme.of(context).colorScheme.secondary;
    return InkWell(
      onTap: () {
        Get.to(EditProfileScreen());
      },
      child: StreamBuilder(
        stream: UsersService.getUserStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const AppText('');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  AppLoader();
          }
          final data = snapshot.data!.docs;
          return Row(
            children: [
              SizedBox(
                width: 20.px,
                height: 20.px,
              ),
              data.first['photoUrl'].isEmpty
                  ? CircleAvatar(
                      maxRadius: 35.px,
                      backgroundColor:
                          AppColorConstant.appYellow.withOpacity(0.2),
                      child: AppText(
                          data.first['firstName']
                              .substring(0, 1)
                              .toString()
                              .toUpperCase(),
                          fontSize: 25.px,
                          color: primaryTheme),
                    )
                  : CircleAvatar(
                      maxRadius: 35.px,
                      backgroundImage: NetworkImage(data.first['photoUrl']),
                    ),
              SizedBox(
                width: 30.px,
                height: 20.px,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: AppText(
                        '${data.first['firstName']} ${data.first['lastName']}',
                        overflow: TextOverflow.ellipsis,
                        fontSize: 20.px,
                        color: primaryTheme,
                      ),
                    ),
                    AppText(AuthService.auth.currentUser!.phoneNumber!,
                        overflow: TextOverflow.ellipsis,
                        color: secondaryTheme,
                        fontSize: 12.px),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  buildSettingsList(BuildContext context, SettingsController controller) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        settingsView(
          context,
          1,
          AppAsset.account,
          S.of(Get.context!).account,
        ),
        settingsView(
          context,
          2,
          AppAsset.appearance,
          S.of(Get.context!).appearance,
        ),
        settingsView(
          context,
          3,
          AppAsset.linkedDevice,
          S.of(Get.context!).linkedDevice,
        ),
        settingsView(
          context,
          4,
          AppAsset.donate,
          S.of(Get.context!).donateToSignal,
        ),
        settingsView(
          context,
          5,
          AppAsset.chats,
          S.of(Get.context!).chats,
        ),
        settingsView(
          context,
          6,
          AppAsset.privacyPolicy,
          S.of(Get.context!).privacyPolicy,
        ),
        settingsView(
          context,
          7,
          AppAsset.invite,
          S.of(Get.context!).inviteFriends,
        ),
        settingsView(
          context,
          8,
          AppAsset.help,
          S.of(Get.context!).help,
        ),
        settingsView(
          context,
          9,
          AppAsset.logOut,
          StringConstant.logOut,
        ),
      ],
    );
  }

  settingsView(context, index, image, tittle) {
    return Padding(
      padding: EdgeInsets.all(10.px),
      child: ListTile(
        onTap: () {
          settingViewModel!.mainTap(index);
        },
        title: AppText(
          tittle,
          color: Theme.of(context).colorScheme.primary,
        ),
        leading: Container(
          height: 45.px,
          width: 45.px,
          padding: EdgeInsets.all(10.px),
          decoration: BoxDecoration(
              color: AppColorConstant.appYellow.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.px),
              border: Border.all(color: AppColorConstant.appYellow)),
          child: AppImageAsset(
            image: image,
            color: AppColorConstant.appYellow,
          ),
        ),
      ),
    );
  }
}
