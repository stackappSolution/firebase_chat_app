import 'package:signal/modal/notification_model.dart';
import 'package:signal/pages/notifications.dart';

import '../modal/notification_model.dart';

class NotificationsViewModel {
  NotificationsScreen? notificationsScreen;
  List<NotificationModel>? notificationsShort;
  NotificationModel? notification;

  NotificationsViewModel([this.notificationsScreen]);
}
