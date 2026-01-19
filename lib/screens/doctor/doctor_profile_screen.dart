import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class DoctorProfileScreen extends StatelessWidget {
  final String doctorId;
  const DoctorProfileScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final doctors = Provider.of<DoctorsProvider>(context);
    final favorites = Provider.of<FavoritesProvider>(context);
    final doctor = doctors.getDoctorById(doctorId);

    if (doctor == null) {
      return Scaffold(appBar: AppBar(), body: Center(child: Text(locale.get('error'))));
    }

    final isFav = favorites.isFavorite(doctor.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            leading: IconButton(icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)), child: const Icon(Iconsax.arrow_right_3, color: Colors.white)), onPressed: () => context.pop()),
            actions: [
              IconButton(icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)), child: Icon(isFav ? Iconsax.heart5 : Iconsax.heart, color: isFav ? AppColors.error : Colors.white)), onPressed: () => favorites.toggleFavorite(doctor.id)),
              IconButton(icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)), child: const Icon(Iconsax.share, color: Colors.white)), onPressed: () {}),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(radius: 45, backgroundColor: Colors.white, child: Text(doctor.name.length > 3 ? doctor.name[3] : doctor.name[0], style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary))),
                    const SizedBox(height: 12),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(doctor.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      if (doctor.isVerified) ...[const SizedBox(width: 6), const Icon(Iconsax.verify5, color: Colors.white, size: 20)],
                    ]),
                    const SizedBox(height: 4),
                    Text(doctor.specialtyAr, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
          // Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(child: StatCard(icon: Iconsax.star1, value: '${doctor.rating}', label: locale.get('rating'), color: Colors.amber)),
                  const SizedBox(width: 12),
                  Expanded(child: StatCard(icon: Iconsax.people, value: '${doctor.patientsCount}+', label: locale.get('patients'), color: AppColors.info)),
                  const SizedBox(width: 12),
                  Expanded(child: StatCard(icon: Iconsax.briefcase, value: '${doctor.experienceYears}', label: locale.get('years'), color: AppColors.success)),
                ],
              ),
            ),
          ),
          // About
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(locale.get('about'), style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(doctor.bio, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
                  if (doctor.clinicAddress != null) ...[
                    const SizedBox(height: 16),
                    Row(children: [const Icon(Iconsax.location, size: 18, color: AppColors.primary), const SizedBox(width: 8), Text(doctor.clinicAddress!, style: Theme.of(context).textTheme.bodyMedium)]),
                  ],
                  const SizedBox(height: 16),
                  Row(children: [Icon(doctor.isOnline ? Iconsax.tick_circle : Iconsax.close_circle, size: 18, color: doctor.isOnline ? AppColors.success : AppColors.error), const SizedBox(width: 8), Text(doctor.isOnline ? 'متاحة للاستشارات الأونلاين' : 'غير متاحة حالياً', style: TextStyle(color: doctor.isOnline ? AppColors.success : AppColors.error))]),
                ],
              ),
            ),
          ),
          // Consultation fee
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Icon(Iconsax.wallet_money, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(locale.get('consultationFee'), style: const TextStyle(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text('${doctor.consultationFee.toInt()} ${locale.get('egp')}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
                ],
              ),
            ),
          ),
          // Reviews
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: '${locale.get('reviews')} (${doctor.reviewsCount})', actionText: locale.get('seeAll'), onActionPressed: () {}),
                  ...MockData.reviews.take(3).map((r) => _ReviewCard(review: r)),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
        child: SafeArea(child: AppButton(text: locale.get('bookNow'), onPressed: () => context.push('/booking/${doctor.id}'))),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  const _ReviewCard({required this.review});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(radius: 18, backgroundColor: AppColors.primaryLight, child: Text(review.userName[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                RatingBarIndicator(rating: review.rating, itemSize: 14, itemBuilder: (_, __) => const Icon(Icons.star_rounded, color: Colors.amber)),
              ])),
              Text('${review.createdAt.day}/${review.createdAt.month}', style: Theme.of(context).textTheme.bodySmall),
            ]),
            const SizedBox(height: 12),
            Text(review.comment, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
