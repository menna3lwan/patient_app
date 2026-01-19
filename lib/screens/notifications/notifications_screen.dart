import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import '../../widgets/widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final notificationsProvider = context.watch<NotificationsProvider>();
    final notifications = notificationsProvider.notifications;

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.get('notifications')),
        actions: [
          if (notificationsProvider.hasUnread)
            TextButton(
              onPressed: () => notificationsProvider.markAllAsRead(),
              child: Text(locale.get('markAllRead')),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? EmptyState(
              icon: Iconsax.notification,
              title: locale.get('noNotifications'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationCard(
                  title: notification.title,
                  body: notification.body,
                  timeAgo: notification.timeAgo,
                  type: notification.type,
                  isRead: notification.isRead,
                  onTap: () {
                    notificationsProvider.markAsRead(notification.id);
                    // Navigate based on type
                    if (notification.type == 'appointment') {
                      // Could navigate to appointment details
                    }
                  },
                  onDismiss: () => notificationsProvider.deleteNotification(notification.id),
                );
              },
            ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final String title, body, timeAgo, type;
  final bool isRead;
  final VoidCallback? onTap, onDismiss;

  const _NotificationCard({
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    required this.isRead,
    this.onTap,
    this.onDismiss,
  });

  IconData get _icon {
    switch (type) {
      case 'appointment': return Iconsax.calendar_tick;
      case 'message': return Iconsax.message;
      case 'promotion': return Iconsax.discount_shape;
      default: return Iconsax.notification;
    }
  }

  Color get _iconColor {
    switch (type) {
      case 'appointment': return AppColors.primary;
      case 'message': return AppColors.info;
      case 'promotion': return AppColors.warning;
      default: return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(title + timeAgo),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: isRead ? null : Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_icon, color: _iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        body,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
