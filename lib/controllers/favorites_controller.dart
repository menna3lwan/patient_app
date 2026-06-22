import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final favoriteIds = RxSet<String>();

  int get count => favoriteIds.length;

  bool isFavorite(String doctorId) => favoriteIds.contains(doctorId);

  void toggleFavorite(String doctorId) {
    if (favoriteIds.contains(doctorId)) {
      favoriteIds.remove(doctorId);
    } else {
      favoriteIds.add(doctorId);
    }
  }

  void clearAll() {
    favoriteIds.clear();
  }

  void addFavorite(String doctorId) {
    favoriteIds.add(doctorId);
  }
}
