import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/providers.dart';
import '../../config/locale.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.get('profile')),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/edit-profile'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(
                        user?.name.isNotEmpty == true ? user!.name[0] : 'م',
                        style: const TextStyle(
                            fontSize: 40, color: AppColors.primary),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primary,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt,
                              size: 14, color: Colors.white),
                          onPressed: () => _showImageOptions(context, locale),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? locale.get('guest'),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  user?.email ?? '',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user?.governorate ?? '',
                    style:
                        const TextStyle(color: AppColors.primary, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value:
                      '${context.watch<AppointmentsProvider>().completedAppointments.length}',
                  label: locale.get('completedConsultations'),
                  icon: Icons.check_circle,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  value:
                      '${context.watch<FavoritesProvider>().favoriteIds.length}',
                  label: locale.get('favoriteDoctors'),
                  icon: Icons.favorite,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Menu Items
          _SectionTitle(title: locale.get('account')),
          _MenuItem(
            icon: Icons.person,
            title: locale.get('editProfile'),
            onTap: () => context.push('/edit-profile'),
          ),
          _MenuItem(
            icon: Icons.favorite,
            title: locale.get('favorites'),
            onTap: () => context.push('/favorites'),
          ),
          _MenuItem(
            icon: Icons.notifications,
            title: locale.get('notifications'),
            badge: '${context.watch<NotificationsProvider>().unreadCount}',
            onTap: () => context.push('/notifications'),
          ),
          _MenuItem(
            icon: Icons.history,
            title: locale.get('medicalHistory'),
            onTap: () => _showMedicalHistory(context, locale),
          ),

          const SizedBox(height: 16),
          _SectionTitle(title: locale.get('settings')),
          _MenuItem(
            icon: theme.isDark ? Icons.light_mode : Icons.dark_mode,
            title:
                theme.isDark ? locale.get('lightMode') : locale.get('darkMode'),
            onTap: () => theme.toggleTheme(),
          ),
          _MenuItem(
            icon: Icons.language,
            title: locale.get('language'),
            subtitle: locale.isArabic ? 'العربية' : 'English',
            onTap: () => _showLanguageDialog(context, locale),
          ),

          const SizedBox(height: 16),
          _SectionTitle(title: locale.get('support')),
          _MenuItem(
            icon: Icons.help,
            title: locale.get('help'),
            onTap: () => _showHelpSheet(context, locale),
          ),
          _MenuItem(
            icon: Icons.privacy_tip,
            title: locale.get('privacy'),
            onTap: () => _showPrivacyDialog(context, locale),
          ),
          _MenuItem(
            icon: Icons.description,
            title: locale.get('terms'),
            onTap: () => _showTermsDialog(context, locale),
          ),
          _MenuItem(
            icon: Icons.info,
            title: locale.get('about'),
            onTap: () => _showAboutDialog(context, locale),
          ),

          const SizedBox(height: 16),
          _MenuItem(
            icon: Icons.logout,
            title: locale.get('logout'),
            color: AppColors.error,
            onTap: () => _showLogoutDialog(context, locale),
          ),

          const SizedBox(height: 24),
          Center(
            child: Text(
              '${locale.get('version')} 1.0.0',
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showImageOptions(BuildContext context, LocaleProvider locale) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(locale.get('changePhoto'),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ImageOption(
                  icon: Icons.camera_alt,
                  label: locale.get('camera'),
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(locale.get('photoUpdated'))),
                    );
                  },
                ),
                _ImageOption(
                  icon: Icons.photo_library,
                  label: locale.get('gallery'),
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(locale.get('photoUpdated'))),
                    );
                  },
                ),
                _ImageOption(
                  icon: Icons.delete,
                  label: locale.get('delete'),
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LocaleProvider locale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(locale.get('language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇸🇦', style: TextStyle(fontSize: 24)),
              title: const Text('العربية'),
              trailing: locale.isArabic
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                locale.setArabic();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: const Text('English'),
              trailing: !locale.isArabic
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                locale.setEnglish();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMedicalHistory(BuildContext context, LocaleProvider locale) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(locale.get('medicalHistory'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _HistoryCard(
                      title: 'استشارة نساء وتوليد',
                      doctor: 'د. منة ماهر',
                      date: '15 يناير 2026',
                      notes: 'متابعة حمل - الشهر الخامس',
                    ),
                    _HistoryCard(
                      title: 'استشارة جلدية',
                      doctor: 'د. منى محمد',
                      date: '10 ديسمبر 2025',
                      notes: 'علاج حب الشباب',
                    ),
                    _HistoryCard(
                      title: 'استشارة نفسية',
                      doctor: 'د. شهد  بدوي',
                      date: '5 نوفمبر 2025',
                      notes: 'جلسة دعم نفسي',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpSheet(BuildContext context, LocaleProvider locale) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.support_agent, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(locale.get('help'),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.chat, color: AppColors.primary),
              title: Text(locale.get('chatSupport')),
              subtitle: const Text('support@henlehen.com'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: AppColors.primary),
              title: Text(locale.get('callSupport')),
              subtitle: const Text('19999'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading:
                  const Icon(Icons.question_answer, color: AppColors.primary),
              title: Text(locale.get('faq')),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context, LocaleProvider locale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(locale.get('privacy')),
        content: SingleChildScrollView(
          child: Text(
            locale.isArabic
                ? 'نحن نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية.\n\n'
                    '• نجمع فقط البيانات الضرورية لتقديم الخدمة\n'
                    '• لا نشارك بياناتك مع أطراف ثالثة\n'
                    '• جميع الاستشارات الطبية مشفرة وآمنة\n'
                    '• يمكنك حذف حسابك في أي وقت\n\n'
                    'للمزيد من المعلومات، تواصل معنا.'
                : 'We respect your privacy and are committed to protecting your personal data.\n\n'
                    '• We only collect data necessary to provide the service\n'
                    '• We do not share your data with third parties\n'
                    '• All medical consultations are encrypted and secure\n'
                    '• You can delete your account at any time\n\n'
                    'For more information, contact us.',
            style: const TextStyle(height: 1.5),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(locale.get('ok')),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context, LocaleProvider locale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(locale.get('terms')),
        content: SingleChildScrollView(
          child: Text(
            locale.isArabic
                ? 'شروط الاستخدام:\n\n'
                    '1. يجب أن يكون عمرك 18 سنة أو أكثر\n'
                    '2. المعلومات المقدمة للاستشارات الطبية\n'
                    '3. لا تستخدم المنصة للطوارئ الطبية\n'
                    '4. احترم الأطباء والمستخدمين الآخرين\n'
                    '5. لا تشارك معلومات حسابك\n\n'
                    'باستخدام التطبيق، أنت توافق على هذه الشروط.'
                : 'Terms of Use:\n\n'
                    '1. You must be 18 years or older\n'
                    '2. Information provided is for medical consultations\n'
                    '3. Do not use the platform for medical emergencies\n'
                    '4. Respect doctors and other users\n'
                    '5. Do not share your account information\n\n'
                    'By using the app, you agree to these terms.',
            style: const TextStyle(height: 1.5),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(locale.get('ok')),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, LocaleProvider locale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(locale.get('about')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.favorite,
                  size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(locale.get('appName'),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              locale.isArabic
                  ? 'منصة طبية متخصصة للمرأة'
                  : 'A Medical Platform for Women',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              locale.isArabic
                  ? 'تقدم استشارات طبية آمنة وسرية مع أفضل الطبيبات المتخصصات'
                  : 'Providing safe and confidential medical consultations with the best specialized female doctors',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(locale.get('ok')),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, LocaleProvider locale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(locale.get('logout')),
        content: Text(locale.get('logoutConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(locale.get('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              context.read<AuthProvider>().logout();
              context.go('/login');
            },
            child: Text(locale.get('logout')),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: AppColors.textSecondary),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            label,
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? badge;
  final Color? color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.badge,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.primary),
        title: Text(title, style: TextStyle(color: color)),
        subtitle: subtitle != null
            ? Text(subtitle!, style: const TextStyle(fontSize: 12))
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null && badge != '0')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_left, color: AppColors.textSecondary),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _ImageOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ImageOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String title;
  final String doctor;
  final String date;
  final String notes;

  const _HistoryCard({
    required this.title,
    required this.doctor,
    required this.date,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.medical_services,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(doctor,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                Text(date,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
            const Divider(height: 24),
            Text(notes, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
