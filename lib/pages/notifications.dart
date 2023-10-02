import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:signal/app/app/utills/app_utills.dart';
import 'package:signal/app/widget/app_app_bar.dart';
import 'package:signal/app/widget/app_loader.dart';
import 'package:signal/app/widget/app_text.dart';
import 'package:signal/constant/color_constant.dart';
import 'package:signal/pages/notifications_view_model.dart';
import 'package:signal/service/auth_service.dart';
import 'package:signal/service/users_service.dart';

import '../modal/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsViewModel? notificationsViewModel;

   NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    notificationsViewModel ?? (notificationsViewModel = NotificationsViewModel(this));

    return Scaffold(
        appBar: AppAppBar(
          title: AppText('All Notifications', fontSize: 16.px),
        ),
        body: FutureBuilder<List<NotificationModel>>(
          future: UsersService.instance.getAllNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AppLoader();
            } else if (snapshot.hasError) {
              return AppText('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: AppText(
                  'No notifications available.',
                ),
              );
            } else {
              notificationsViewModel!.notificationsShort = snapshot.data!..sort((a, b) => b.time!.compareTo('${a.time}'));
              return Padding(
                padding:  EdgeInsets.all(8.0.px),
                child: ListView.builder(
                    itemCount: notificationsViewModel!.notificationsShort!.length,
                    itemBuilder: (context, index) {
                       notificationsViewModel!.notification = notificationsViewModel!
                           .notificationsShort![index];
                  return Container(
                    margin: EdgeInsets.only(left: 10.px,right: 10.px),
                    height: 60,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppText(
                                "${notificationsViewModel!.notification!.senderName}",
                                color: AppColorConstant.appYellow,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                              AppText(
                                " was sent you message ''${notificationsViewModel!.notification!.message}''",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: 2.px,bottom: 5.px),
                              child: AppText(
                                  fontSize: 10.px,color: AppColorConstant.darkSecondary,
                                  '${notificationsViewModel!.notification!.time}'),
                            ),
                          ),
                          Divider(
                            height: 1.px,
                          )
                        ]),
                  );
                },
            ),
              );
          }
        },
      ),
    );
  }
}
