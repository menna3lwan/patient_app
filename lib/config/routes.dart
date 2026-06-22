import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/main_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/doctor/doctor_profile_screen.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/booking/payment_screen.dart';
import '../screens/booking/booking_success_screen.dart';
import '../screens/appointments/appointment_details_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/community/create_post_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/settings_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/favorites/favorites_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/';
  static const String search = '/search';
  static const String doctorProfile = '/doctor';
  static const String booking = '/booking';
  static const String payment = '/payment';
  static const String bookingSuccess = '/booking-success';
  static const String appointmentDetails = '/appointment';
  static const String chat = '/chat';
  static const String createPost = '/create-post';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String favorites = '/favorites';

  static String get initialRoute {
    final auth = Get.find<AuthController>();
    return auth.isLoggedIn.value ? main : onboarding;
  }

  static List<GetPage> get pages => [
        GetPage(
          name: onboarding,
          page: () => const OnboardingScreen(),
        ),
        GetPage(
          name: login,
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: register,
          page: () => const RegisterScreen(),
        ),
        GetPage(
          name: main,
          page: () => const MainScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: search,
          page: () => SearchScreen(specialty: Get.parameters['specialty']),
        ),
        GetPage(
          name: '$doctorProfile/:id',
          page: () => DoctorProfileScreen(doctorId: Get.parameters['id']!),
        ),
        GetPage(
          name: '$booking/:id',
          page: () => BookingScreen(doctorId: Get.parameters['id']!),
        ),
        GetPage(
          name: payment,
          page: () => PaymentScreen(doctorId: Get.arguments as String),
        ),
        GetPage(
          name: bookingSuccess,
          page: () => BookingSuccessScreen(appointmentId: Get.arguments as String),
        ),
        GetPage(
          name: '$appointmentDetails/:id',
          page: () => AppointmentDetailsScreen(appointmentId: Get.parameters['id']!),
        ),
        GetPage(
          name: '$chat/:id',
          page: () => ChatScreen(appointmentId: Get.parameters['id']!),
        ),
        GetPage(
          name: createPost,
          page: () => const CreatePostScreen(),
        ),
        GetPage(
          name: editProfile,
          page: () => const EditProfileScreen(),
        ),
        GetPage(
          name: settings,
          page: () => const SettingsScreen(),
        ),
        GetPage(
          name: notifications,
          page: () => const NotificationsScreen(),
        ),
        GetPage(
          name: favorites,
          page: () => const FavoritesScreen(),
        ),
      ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 0;

  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();
    if (!auth.isLoggedIn.value) {
      return const RouteSettings(name: AppRoutes.onboarding);
    }
    return null;
  }
}
