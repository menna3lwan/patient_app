import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();
    final doctorsProvider = context.watch<DoctorsProvider>();
    
    final favoriteDoctors = doctorsProvider.allDoctors
        .where((d) => favoritesProvider.isFavorite(d.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.get('favorites')),
        actions: [
          if (favoriteDoctors.isNotEmpty)
            IconButton(
              icon: const Icon(Iconsax.trash),
              onPressed: () => _showClearConfirmation(context, locale, favoritesProvider),
            ),
        ],
      ),
      body: favoriteDoctors.isEmpty
          ? EmptyState(
              icon: Iconsax.heart,
              title: locale.get('noFavorites'),
              subtitle: locale.get('addFavoritesHint'),
              buttonText: locale.get('browseDoctors'),
              onButtonPressed: () => context.push('/search'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteDoctors.length,
              itemBuilder: (context, index) {
                final doctor = favoriteDoctors[index];
                return DoctorCard(
                  name: doctor.name,
                  specialty: doctor.specialtyAr,
                  rating: doctor.rating,
                  reviewsCount: doctor.reviewsCount,
                  experience: doctor.experienceYears,
                  fee: doctor.consultationFee,
                  isOnline: doctor.isOnline,
                  isFavorite: true,
                  onTap: () => context.push('/doctor/${doctor.id}'),
                  onFavoritePressed: () {
                    favoritesProvider.toggleFavorite(doctor.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(locale.get('removedFromFavorites')),
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: locale.get('cancel'),
                          onPressed: () => favoritesProvider.addFavorite(doctor.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _showClearConfirmation(BuildContext context, LocaleProvider locale, FavoritesProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(locale.get('clearFavorites')),
        content: Text(locale.get('clearFavoritesConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(locale.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearAll();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(locale.get('delete')),
          ),
        ],
      ),
    );
  }
}
