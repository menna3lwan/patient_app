import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import 'home_tab.dart';
import '../appointments/appointments_tab.dart';
import '../community/community_tab.dart';
import '../profile/profile_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _tabs = [
    const HomeTab(),
    const AppointmentsTab(),
    const CommunityTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final notifications = Provider.of<NotificationsProvider>(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Iconsax.home_2, activeIcon: Iconsax.home5, label: locale.get('home'), isActive: _currentIndex == 0, onTap: () => setState(() => _currentIndex = 0)),
                _NavItem(icon: Iconsax.calendar_1, activeIcon: Iconsax.calendar5, label: locale.get('appointments'), isActive: _currentIndex == 1, onTap: () => setState(() => _currentIndex = 1)),
                _NavItem(icon: Iconsax.message, activeIcon: Iconsax.message5, label: locale.get('community'), isActive: _currentIndex == 2, onTap: () => setState(() => _currentIndex = 2), badge: 0),
                _NavItem(icon: Iconsax.user, activeIcon: Iconsax.user5, label: locale.get('profile'), isActive: _currentIndex == 3, onTap: () => setState(() => _currentIndex = 3), badge: notifications.unreadCount),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int badge;

  const _NavItem({required this.icon, required this.activeIcon, required this.label, required this.isActive, required this.onTap, this.badge = 0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(isActive ? activeIcon : icon, color: isActive ? AppColors.primary : Theme.of(context).textTheme.bodySmall?.color, size: 24),
                if (badge > 0) Positioned(top: -4, right: -8, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle), child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))),
              ],
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal, color: isActive ? AppColors.primary : Theme.of(context).textTheme.bodySmall?.color)),
          ],
        ),
      ),
    );
  }
}
