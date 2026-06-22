import 'package:get/get.dart';
import 'package:shared_ui/shared_ui.dart';
import 'locale.dart';
import '../controllers/auth_controller.dart';
import '../controllers/doctors_controller.dart';
import '../controllers/appointments_controller.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/community_controller.dart';
import '../controllers/notifications_controller.dart';
import '../controllers/booking_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController(), permanent: true);
    Get.put(LocaleController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(DoctorsController(), permanent: true);
    Get.put(AppointmentsController(), permanent: true);
    Get.put(FavoritesController(), permanent: true);
    Get.put(CommunityController(), permanent: true);
    Get.put(NotificationsController(), permanent: true);
    Get.put(BookingController(), permanent: true);
  }
}
