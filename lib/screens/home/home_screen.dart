import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_ui/shared_ui.dart';
import '../../config/providers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<AuthController>().user.value;
    final notif = Get.find<NotificationsController>();
    final upcoming = Get.find<AppointmentsController>().upcoming;
    final doctors = MockData.doctors.where((d) => d.rating >= 4.7).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('مرحباً ${user?.name ?? ""}',
                style: const TextStyle(fontSize: 14)),
            const Text('كيف يمكننا مساعدتك؟',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => Get.toNamed('/notifications')),
              if (notif.unread > 0)
                Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            color: AppColors.error, shape: BoxShape.circle),
                        child: Text('${notif.unread}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10)))),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Search
            GestureDetector(
              onTap: () => Get.toNamed('/search'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider)),
                child: const Row(children: [
                  Icon(Icons.search, color: AppColors.textSecondary),
                  SizedBox(width: 12),
                  Text('ابحثي عن دكتورة...',
                      style: TextStyle(color: AppColors.textSecondary))
                ]),
              ),
            ),
            const SizedBox(height: 24),

            // Upcoming Appointment
            if (upcoming.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.primary.withOpacity(0.8),
                      AppColors.primaryLight
                    ]),
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(upcoming.first.doctor.name[3],
                            style: const TextStyle(color: AppColors.primary))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('موعدك القادم',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          Text(upcoming.first.doctor.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              '${upcoming.first.date.day}/${upcoming.first.date.month} - ${upcoming.first.time}',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary),
                      onPressed: () => Get.offAllNamed('/appointments'),
                      child: const Text('عرض'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Specialties
            const Text('التخصصات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SpecialtyCard(
                    icon: Icons.pregnant_woman,
                    title: 'نساء وتوليد',
                    color: AppColors.primary,
                    onTap: () => Get.toNamed('/search', arguments: 'gynecology')),
                _SpecialtyCard(
                    icon: Icons.face_retouching_natural,
                    title: 'جلدية',
                    color: Colors.purple,
                    onTap: () => Get.toNamed('/search', arguments: 'dermatology')),
                _SpecialtyCard(
                    icon: Icons.psychology,
                    title: 'نفسية',
                    color: Colors.blue,
                    onTap: () => Get.toNamed('/search', arguments: 'psychology')),
              ],
            ),
            const SizedBox(height: 24),

            // Top Doctors
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('أفضل الدكتورات',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () => Get.toNamed('/search'),
                    child: const Text('عرض الكل')),
              ],
            ),
            const SizedBox(height: 12),
            ...doctors.map((d) => DoctorCard(
                  name: d.name,
                  specialty: d.specialtyAr,
                  rating: d.rating,
                  reviewsCount: d.reviewsCount,
                  experience: d.experienceYears,
                  fee: d.consultationFee,
                )),
          ],
        ),
      ),
    );
  }
}

class _SpecialtyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  const _SpecialtyCard(
      {required this.icon,
      required this.title,
      required this.color,
      required this.onTap});

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
                  borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 32)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
