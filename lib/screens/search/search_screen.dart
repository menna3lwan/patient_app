import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  final String? specialty;
  const SearchScreen({super.key, this.specialty});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final doctors = Provider.of<DoctorsProvider>(context, listen: false);
      doctors.clearFilters();
      if (widget.specialty != null) doctors.setSpecialty(widget.specialty);
    });
  }

  @override
  void dispose() { _searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final doctors = Provider.of<DoctorsProvider>(context);
    final favorites = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Iconsax.arrow_right_3), onPressed: () => context.pop()),
        title: Text(locale.get('search')),
        actions: [IconButton(icon: const Icon(Iconsax.filter), onPressed: () => _showFilterSheet(context, doctors, locale))],
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: doctors.setSearchQuery,
              decoration: InputDecoration(
                hintText: locale.get('searchDoctors'),
                prefixIcon: const Icon(Iconsax.search_normal),
                suffixIcon: _searchController.text.isNotEmpty ? IconButton(icon: const Icon(Iconsax.close_circle), onPressed: () { _searchController.clear(); doctors.setSearchQuery(''); }) : null,
              ),
            ),
          ),
          // Specialties chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(label: locale.get('all'), isSelected: doctors.selectedSpecialty == null, onTap: () => doctors.setSpecialty(null)),
                const SizedBox(width: 8),
                ...MockData.specialties.map((s) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _FilterChip(label: locale.isArabic ? s.nameAr : s.nameEn, isSelected: doctors.selectedSpecialty == s.id, onTap: () => doctors.setSpecialty(s.id)),
                )),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Text('${doctors.doctors.length} ${locale.get('topDoctors')}', style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
                PopupMenuButton<String>(
                  onSelected: doctors.setSortBy,
                  child: Row(children: [Icon(Iconsax.sort, size: 18, color: Theme.of(context).textTheme.bodySmall?.color), const SizedBox(width: 4), Text(locale.get('sort'), style: Theme.of(context).textTheme.bodySmall)]),
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'rating', child: Text(locale.get('rating'))),
                    PopupMenuItem(value: 'experience', child: Text(locale.get('experience'))),
                    PopupMenuItem(value: 'fee', child: Text(locale.get('consultationFee'))),
                  ],
                ),
              ],
            ),
          ),
          // Results list
          Expanded(
            child: doctors.doctors.isEmpty
                ? EmptyState(icon: Iconsax.search_normal, title: locale.get('noResults'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: doctors.doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors.doctors[index];
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
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context, DoctorsProvider doctors, LocaleProvider locale) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(locale.get('filter'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text(locale.get('specialties'), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                _FilterChip(label: locale.get('all'), isSelected: doctors.selectedSpecialty == null, onTap: () { doctors.setSpecialty(null); Navigator.pop(ctx); }),
                ...MockData.specialties.map((s) => _FilterChip(label: locale.isArabic ? s.nameAr : s.nameEn, isSelected: doctors.selectedSpecialty == s.id, onTap: () { doctors.setSpecialty(s.id); Navigator.pop(ctx); })),
              ],
            ),
            const SizedBox(height: 24),
            AppButton(text: locale.get('done'), onPressed: () => Navigator.pop(ctx)),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: isSelected ? AppColors.primary : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: isSelected ? AppColors.primary : Theme.of(context).dividerColor)),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : null, fontWeight: isSelected ? FontWeight.w600 : null, fontSize: 13)),
      ),
    );
  }
}
