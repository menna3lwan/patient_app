import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Iconsax.arrow_right_3), onPressed: () => context.pop()),
        title: Text(locale.get('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SettingsSection(title: locale.get('appearance'), children: [
            _SettingsItem(icon: Iconsax.sun_1, title: locale.get('darkMode'), trailing: Switch(value: theme.isDark, onChanged: (_) => theme.toggleTheme(), activeColor: AppColors.primary)),
            _SettingsItem(icon: Iconsax.language_circle, title: locale.get('language'), trailing: DropdownButton<bool>(value: locale.isArabic, underline: const SizedBox(), items: const [DropdownMenuItem(value: true, child: Text('العربية')), DropdownMenuItem(value: false, child: Text('English'))], onChanged: (v) { if (v == true) locale.setArabic(); else locale.setEnglish(); })),
          ]),
          const SizedBox(height: 20),
          _SettingsSection(title: locale.get('notifications'), children: [
            _SettingsItem(icon: Iconsax.notification, title: 'إشعارات المواعيد', trailing: Switch(value: true, onChanged: (_) {}, activeColor: AppColors.primary)),
            _SettingsItem(icon: Iconsax.message, title: 'إشعارات الرسائل', trailing: Switch(value: true, onChanged: (_) {}, activeColor: AppColors.primary)),
            _SettingsItem(icon: Iconsax.discount_shape, title: 'العروض والخصومات', trailing: Switch(value: false, onChanged: (_) {}, activeColor: AppColors.primary)),
          ]),
          const SizedBox(height: 20),
          _SettingsSection(title: locale.get('support'), children: [
            _SettingsItem(icon: Iconsax.message_question, title: locale.get('help'), onTap: () {}),
            _SettingsItem(icon: Iconsax.shield_tick, title: locale.get('privacy'), onTap: () {}),
            _SettingsItem(icon: Iconsax.document, title: locale.get('terms'), onTap: () {}),
            _SettingsItem(icon: Iconsax.info_circle, title: locale.get('aboutApp'), onTap: () {}),
          ]),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingsSection({required this.title, required this.children});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(bottom: 12, right: 4, left: 4), child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
      Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
        child: Column(children: children.map((c) => Column(children: [c, if (children.last != c) Divider(height: 1, indent: 56, color: Theme.of(context).dividerColor)])).toList()),
      ),
    ]);
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _SettingsItem({required this.icon, required this.title, this.trailing, this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.primary, size: 20)),
      title: Text(title),
      trailing: trailing ?? const Icon(Iconsax.arrow_left_2, size: 18),
    );
  }
}
