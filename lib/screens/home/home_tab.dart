import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final doctors = Provider.of<DoctorsProvider>(context);
    final favorites = Provider.of<FavoritesProvider>(context);
    final notifications = Provider.of<NotificationsProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(child: Text(auth.user?.name.isNotEmpty == true ? auth.user!.name[0] : '👩', style: const TextStyle(fontSize: 24, color: Colors.white))),
                    ),
                    const SizedBox(width: 14),
                    // Greeting
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${locale.get('hello')}، ${auth.user?.name.split(' ').first ?? locale.get('guest')} 👋', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 2),
                          Text(locale.get('howAreYou'), style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    // Notifications
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Iconsax.notification),
                          onPressed: () => context.push('/notifications'),
                        ),
                        if (notifications.hasUnread) Positioned(top: 8, right: 8, child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle))),
                      ],
                    ),
                    // Favorites
                    IconButton(icon: const Icon(Iconsax.heart), onPressed: () => context.push('/favorites')),
                  ],
                ),
              ),
            ),
            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => context.push('/search'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
                    ),
                    child: Row(children: [Icon(Iconsax.search_normal, color: Theme.of(context).textTheme.bodySmall?.color), const SizedBox(width: 12), Text(locale.get('searchDoctors'), style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color))]),
                  ),
                ),
              ),
            ),
            // Specialties section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: SectionHeader(title: locale.get('specialties'), actionText: locale.get('seeAll'), onActionPressed: () => context.push('/search')),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 110,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: MockData.specialties.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final specialty = MockData.specialties[index];
                    return SpecialtyCard(
                      name: locale.isArabic ? specialty.nameAr : specialty.nameEn,
                      icon: specialty.icon,
                      color: Color(specialty.color),
                      onTap: () => context.push('/search?specialty=${specialty.id}'),
                    );
                  },
                ),
              ),
            ),
            // Top doctors section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: SectionHeader(title: locale.get('topDoctors'), actionText: locale.get('seeAll'), onActionPressed: () => context.push('/search')),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final doctor = doctors.topDoctors[index];
                    return DoctorCard(
                      name: doctor.name,
                      specialty: doctor.specialtyAr,
                      rating: doctor.rating,
                      reviewsCount: doctor.reviewsCount,
                      experience: doctor.experienceYears,
                      fee: doctor.consultationFee,
                      isOnline: doctor.isOnline,
                      isFavorite: favorites.isFavorite(doctor.id),
                      onTap: () => context.push('/doctor/${doctor.id}'),
                      onFavoritePressed: () => favorites.toggleFavorite(doctor.id),
                    );
                  },
                  childCount: doctors.topDoctors.take(5).length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
