import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/controller/diappearing_controller.dart';
import 'package:signal/pages/settings/privacy/disappear/disappear_view_model.dart';

// ignore: must_be_immutable
class DisappearScreen extends StatelessWidget {
  DisappearScreen({Key? key}) : super(key: key);

  DisappearViewModel? disappearViewModel;

  @override
  Widget build(BuildContext context) {
    disappearViewModel ?? (disappearViewModel = DisappearViewModel(this));

    return GetBuilder<DisappearingController>(
      init: DisappearingController(),
      initState: (state) {},
      builder: (DisappearingController controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: getAppbar(context),
          body: getBody(context,controller),
        );
      },
    );
  }

  getAppbar(BuildContext context) {
    return AppAppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: AppText('Disappearing Messages',
          fontSize: 18.px, color: Theme.of(context).colorScheme.primary),
    );
  }

  getBody(BuildContext context, DisappearingController controller) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(15.px),
          child: AppText(
            'When enabled,new messages sent and received in new chats started by you will disappear after they have been seen.',
            fontSize: 12.px,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        buildSelectionView(controller),
      ],
    );
  }

  buildSelectionView(DisappearingController controller) {
    return ListView(
      shrinkWrap: true,
      children: [
        RadioListTile<String>(
          activeColor: AppColorConstant.appYellow,
          value: 'off',
          groupValue: controller.selectedValue.value,
          onChanged: (value) {
          controller.updateSelectedValue(value!);
          },
          title: const AppText('off'),
        ),
        RadioListTile<String>(
          activeColor: AppColorConstant.appYellow,
          value: '4 weeks',
          groupValue: controller.selectedValue.value,
          onChanged: (value) {
          controller.updateSelectedValue(value!);
          },
          title: const AppText('4 weeks'),
        ),
        RadioListTile<String>(
          activeColor: AppColorConstant.appYellow,
          value: '1 week',
          groupValue:controller.selectedValue.value,
          onChanged: (value) {
            controller.updateSelectedValue(value!);
          },
          title: const AppText('1 week'),
        ),
        RadioListTile<String>(
          activeColor: AppColorConstant.appYellow,
          value: '1 day',
          groupValue:controller.selectedValue.value,
          onChanged: (value) {
           controller.updateSelectedValue(value!);
          },
          title: const AppText('1 day'),
        ),
        RadioListTile<String>(
          activeColor: AppColorConstant.appYellow,
          value: '8 hours',
          groupValue:controller.selectedValue.value,
          onChanged: (value) {
           controller.updateSelectedValue(value!);
          },
          title: const AppText('8 hours'),
        ),
        RadioListTile<String>(
          activeColor: AppColorConstant.appYellow,
          value: '1 hour',
          groupValue:controller.selectedValue.value,
          onChanged: (value) {
          controller.updateSelectedValue(value!);
          },
          title: const AppText('1 hour'),
        ),
        RadioListTile<String>(
          activeColor: AppColorConstant.appYellow,
          value: '5 minutes',
          groupValue:controller.selectedValue.value,
          onChanged: (value) {
           controller.updateSelectedValue(value!);
          },
          title: const AppText('5 minutes'),
        ),
      ],
    );
  }
}
