import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final notifications = Provider.of<NotificationsProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70, height: 70,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Center(child: Text(auth.user?.name.isNotEmpty == true ? auth.user!.name[0] : '👩', style: TextStyle(fontSize: 32, color: AppColors.primary, fontWeight: FontWeight.bold))),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(auth.user?.name ?? locale.get('guest'), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(auth.user?.email ?? '', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                          const SizedBox(height: 4),
                          Text(auth.user?.phone ?? '', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Iconsax.edit, color: Colors.white), onPressed: () => context.push('/edit-profile')),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Menu items
              _MenuSection(title: locale.get('account'), items: [
                _MenuItem(icon: Iconsax.user_edit, title: locale.get('editProfile'), onTap: () => context.push('/edit-profile')),
                _MenuItem(icon: Iconsax.heart, title: locale.get('favorites'), onTap: () => context.push('/favorites')),
                _MenuItem(icon: Iconsax.notification, title: locale.get('notifications'), badge: notifications.unreadCount, onTap: () => context.push('/notifications')),
                _MenuItem(icon: Iconsax.document_text, title: locale.get('medicalHistory'), onTap: () {}),
              ]),
              const SizedBox(height: 16),
              _MenuSection(title: locale.get('appearance'), items: [
                _MenuItem(icon: theme.isDark ? Iconsax.moon : Iconsax.sun_1, title: theme.isDark ? locale.get('darkMode') : locale.get('lightMode'), trailing: Switch(value: theme.isDark, onChanged: (_) => theme.toggleTheme(), activeColor: AppColors.primary)),
                _MenuItem(icon: Iconsax.language_circle, title: locale.get('language'), trailing: Text(locale.isArabic ? 'العربية' : 'English', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)), onTap: () => locale.toggle()),
              ]),
              const SizedBox(height: 16),
              _MenuSection(title: locale.get('support'), items: [
                _MenuItem(icon: Iconsax.message_question, title: locale.get('help'), onTap: () {}),
                _MenuItem(icon: Iconsax.shield_tick, title: locale.get('privacy'), onTap: () {}),
                _MenuItem(icon: Iconsax.document, title: locale.get('terms'), onTap: () {}),
                _MenuItem(icon: Iconsax.info_circle, title: locale.get('aboutApp'), onTap: () {}),
              ]),
              const SizedBox(height: 16),
              // Logout button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context, locale, auth),
                  icon: const Icon(Iconsax.logout, color: AppColors.error),
                  label: Text(locale.get('logout'), style: const TextStyle(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error), padding: const EdgeInsets.symmetric(vertical: 14)),
                ),
              ),
              const SizedBox(height: 24),
              // Version
              Text('${locale.get('appName')} v1.0.0', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, LocaleProvider locale, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(locale.get('logout')),
        content: Text(locale.get('logoutConfirm')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(locale.get('cancel'))),
          ElevatedButton(
            onPressed: () { auth.logout(); Navigator.pop(ctx); context.go('/login'); },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(locale.get('logout')),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _MenuSection({required this.title, required this.items});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(bottom: 8, right: 4, left: 4), child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
          child: Column(children: items.map((item) => Column(children: [item, if (items.last != item) Divider(height: 1, indent: 56, color: Theme.of(context).dividerColor)])).toList()),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int badge;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _MenuItem({required this.icon, required this.title, this.badge = 0, this.trailing, this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.primary, size: 20)),
      title: Text(title),
      trailing: trailing ?? (badge > 0 ? Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(12)), child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))) : const Icon(Iconsax.arrow_left_2, size: 18)),
    );
  }
}
