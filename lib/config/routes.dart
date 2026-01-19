import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers.dart';
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
  static const String doctorProfile = '/doctor/:id';
  static const String booking = '/booking/:id';
  static const String payment = '/payment';
  static const String bookingSuccess = '/booking-success';
  static const String appointmentDetails = '/appointment/:id';
  static const String chat = '/chat/:id';
  static const String createPost = '/create-post';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String favorites = '/favorites';

  static GoRouter router(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    return GoRouter(
      initialLocation: authProvider.isLoggedIn ? main : onboarding,
      routes: [
        GoRoute(path: onboarding, builder: (_, __) => const OnboardingScreen()),
        GoRoute(path: login, builder: (_, __) => const LoginScreen()),
        GoRoute(path: register, builder: (_, __) => const RegisterScreen()),
        GoRoute(path: main, builder: (_, __) => const MainScreen()),
        GoRoute(path: search, builder: (_, state) => SearchScreen(specialty: state.uri.queryParameters['specialty'])),
        GoRoute(path: doctorProfile, builder: (_, state) => DoctorProfileScreen(doctorId: state.pathParameters['id']!)),
        GoRoute(path: booking, builder: (_, state) => BookingScreen(doctorId: state.pathParameters['id']!)),
        GoRoute(path: payment, builder: (_, state) => PaymentScreen(doctorId: state.extra as String)),
        GoRoute(path: bookingSuccess, builder: (_, state) => BookingSuccessScreen(appointmentId: state.extra as String)),
        GoRoute(path: appointmentDetails, builder: (_, state) => AppointmentDetailsScreen(appointmentId: state.pathParameters['id']!)),
        GoRoute(path: chat, builder: (_, state) => ChatScreen(appointmentId: state.pathParameters['id']!)),
        GoRoute(path: createPost, builder: (_, __) => const CreatePostScreen()),
        GoRoute(path: editProfile, builder: (_, __) => const EditProfileScreen()),
        GoRoute(path: settings, builder: (_, __) => const SettingsScreen()),
        GoRoute(path: notifications, builder: (_, __) => const NotificationsScreen()),
        GoRoute(path: favorites, builder: (_, __) => const FavoritesScreen()),
      ],
    );
  }
}
