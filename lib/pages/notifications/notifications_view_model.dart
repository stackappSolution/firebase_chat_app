import 'package:signal/modal/notification_model.dart';
import 'notifications.dart';

class NotificationsViewModel {
  NotificationsScreen? notificationsScreen;
  List<NotificationModel>? notificationsShort;
  NotificationModel? notification;

  NotificationsViewModel([this.notificationsScreen]);
}
