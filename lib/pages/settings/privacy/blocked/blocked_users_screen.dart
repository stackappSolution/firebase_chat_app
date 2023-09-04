import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_text.dart';

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: getAppbar(context),
      body: getBody(context),
    );
  }

  getAppbar(BuildContext context) {
    return AppAppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: AppText('Blocked users',
          fontSize: 18.px, color: Theme.of(context).colorScheme.primary),
    );
  }

  getBody(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start ,

      children: [
        buildAddBlockView(context),
        Padding(padding: EdgeInsets.all(20.px),
          child: AppText(
            'Blocked Users',
            fontSize: 15.px,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.primary,
          ),
        )
      ],
    );
  }

  buildAddBlockView(BuildContext context) {
    return ListTile(
      title: AppText('Add blocked user',
          fontSize: 15.px, color: Theme.of(context).colorScheme.primary),
      subtitle: AppText(
          'Blocked users will not be able to call you and send you messages',
          fontSize: 12.px,
          color: Theme.of(context).colorScheme.secondary),
    );
  }






}
