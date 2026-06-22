import 'package:get/get.dart';
import '../models/models.dart';

class NotificationsController extends GetxController {
  final notifications = RxList<NotificationModel>(MockData.notifications);

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  bool get hasUnread => unreadCount > 0;

  int get unread => unreadCount;

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;
    notifications[index].isRead = true;
    notifications.refresh();
  }

  void markAllAsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
  }

  void clearAll() {
    notifications.clear();
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
  }
}
