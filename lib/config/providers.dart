import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'theme.dart';
import 'locale.dart';
import '../models/models.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DoctorsProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ];
}

/* ================= AUTH ================= */

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || !email.contains('@')) {
      _error = 'البريد الإلكتروني غير صالح';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _error = 'كلمة المرور قصيرة';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _user = UserModel(
      id: 'p1',
      name: 'منة علوان',
      email: email,
      phone: '01012345678',
      governorate: 'القاهرة',
      bloodType: 'A+',
    );

    _isLoggedIn = true;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String governorate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (name.length < 3) {
      _error = 'الاسم قصير';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _user = UserModel(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      governorate: governorate,
    );

    _isLoggedIn = true;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void updateProfile({
    String? name,
    String? phone,
    String? governorate,
    String? avatar,
  }) {
    if (_user == null) return;
    _user = _user!.copyWith(
      name: name,
      phone: phone,
      governorate: governorate,
      avatar: avatar,
    );
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

/* ================= DOCTORS ================= */

class DoctorsProvider extends ChangeNotifier {
  final List<DoctorModel> _doctors = List.from(MockData.doctors);

  String? _selectedSpecialty;
  String _searchQuery = '';
  String _sortBy = 'rating';

  List<DoctorModel> get doctors => _filteredDoctors;
  List<DoctorModel> get allDoctors => _doctors;
  String? get selectedSpecialty => _selectedSpecialty;

  List<DoctorModel> get _filteredDoctors {
    var result = List<DoctorModel>.from(_doctors);

    if (_selectedSpecialty != null && _selectedSpecialty!.isNotEmpty) {
      result = result.where((d) => d.specialty == _selectedSpecialty).toList();
    }

    if (_searchQuery.isNotEmpty) {
      result = result
          .where((d) =>
              d.name.contains(_searchQuery) ||
              d.specialtyAr.contains(_searchQuery))
          .toList();
    }

    switch (_sortBy) {
      case 'rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'experience':
        result.sort((a, b) => b.experienceYears.compareTo(a.experienceYears));
        break;
      case 'fee':
        result.sort((a, b) => a.consultationFee.compareTo(b.consultationFee));
        break;
    }

    return result;
  }

  DoctorModel? getDoctorById(String id) {
    try {
      return _doctors.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  void setSpecialty(String? specialty) {
    _selectedSpecialty = specialty;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void clearFilters() {
    _selectedSpecialty = null;
    _searchQuery = '';
    _sortBy = 'rating';
    notifyListeners();
  }
  // ✅ Top doctors (أعلى تقييم)
List<DoctorModel> get topDoctors {
  final list = List<DoctorModel>.from(_doctors);
  list.sort((a, b) => b.rating.compareTo(a.rating));
  return list;
}

}

/* ================= APPOINTMENTS ================= */

class AppointmentsProvider extends ChangeNotifier {
  final List<AppointmentModel> _appointments = List.from(MockData.appointments);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<AppointmentModel> get upcomingAppointments => _appointments
      .where((a) => a.status == 'pending' || a.status == 'confirmed')
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  List<AppointmentModel> get completedAppointments =>
      _appointments.where((a) => a.status == 'completed').toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  List<AppointmentModel> get cancelledAppointments =>
      _appointments.where((a) => a.status == 'cancelled').toList()
        ..sort((a, b) => b.date.compareTo(a.date));
  List<AppointmentModel> get upcoming => upcomingAppointments;

  AppointmentModel? getAppointmentById(String id) {
    try {
      return _appointments.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  // ✅ USED IN PaymentScreen
  Future<AppointmentModel> bookAppointment({
    required DoctorModel doctor,
    required DateTime date,
    required String time,
    required String type,
    required double amount,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final appointment = AppointmentModel(
      id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
      doctor: doctor,
      date: date,
      time: time,
      type: type,
      status: 'pending',
      amount: amount,
    );

    _appointments.insert(0, appointment);

    _isLoading = false;
    notifyListeners();

    return appointment;
  }

  void cancelAppointment(String id) => _updateStatus(id, 'cancelled');

  void confirmAppointment(String id) => _updateStatus(id, 'confirmed');

  void completeAppointment(String id) => _updateStatus(id, 'completed');

  void _updateStatus(String id, String status) {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index == -1) return;

    _appointments[index] = _appointments[index].copyWith(status: status);
    notifyListeners();
  }
}

/* ================= FAVORITES ================= */

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;
  int get count => _favoriteIds.length;

  bool isFavorite(String doctorId) => _favoriteIds.contains(doctorId);

  void toggleFavorite(String doctorId) {
    _favoriteIds.contains(doctorId)
        ? _favoriteIds.remove(doctorId)
        : _favoriteIds.add(doctorId);
    notifyListeners();
  }

  void clearAll() {
    _favoriteIds.clear();
    notifyListeners();
  }

  void addFavorite(String doctorId) {
    _favoriteIds.add(doctorId);
    notifyListeners();
  }
}

/* ================= COMMUNITY ================= */

class CommunityProvider extends ChangeNotifier {
  final List<PostModel> _posts = List.from(MockData.posts);
  bool _isLoading = false;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> addPost(String content, {bool isAnonymous = false}) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _posts.insert(
      0,
      PostModel(
        id: 'post_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'me',
        userName: isAnonymous ? '' : 'أنا',
        content: content,
        isAnonymous: isAnonymous,
      ),
    );

    _isLoading = false;
    notifyListeners();
  }

  void toggleLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    post.isLiked = !post.isLiked;
    post.likes += post.isLiked ? 1 : -1;
    notifyListeners();
  }

  void deletePost(String postId) {
    _posts.removeWhere((p) => p.id == postId);
    notifyListeners();
  }

  void addComment(
    String postId,
    String content, {
    bool isAnonymous = false,
  }) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    _posts[index].comments.add(
          CommentModel(
            id: 'c_${DateTime.now().millisecondsSinceEpoch}',
            userId: 'me',
            userName: isAnonymous ? '' : 'أنا',
            content: content,
            isAnonymous: isAnonymous,
          ),
        );

    _posts[index].commentsCount++;
    notifyListeners();
  }
}

/* ================= NOTIFICATIONS ================= */

class NotificationsProvider extends ChangeNotifier {
  final List<NotificationModel> _notifications =
      List.from(MockData.notifications);

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  bool get hasUnread => unreadCount > 0;
  int get unread => unreadCount;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;
    _notifications[index].isRead = true;
    notifyListeners();
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
  void deleteNotification(String id) {
  _notifications.removeWhere((n) => n.id == id);
  notifyListeners();
}

}

/* ================= BOOKING ================= */

class BookingProvider extends ChangeNotifier {
  DateTime? _selectedDate;
  String? _selectedTime;
  String _consultationType = 'online';

  String? _promoCode;
  double _discount = 0;

  DateTime? get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;
  String get consultationType => _consultationType;

  String? get promoCode => _promoCode;
  double get discount => _discount;

  bool get canProceed => _selectedDate != null && _selectedTime != null;

  // ================== METHODS ==================

  void setConsultationType(String type) {
    _consultationType = type;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    _selectedTime = null;
    notifyListeners();
  }

  void setTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  // ✅ USED IN PaymentScreen
  bool applyPromoCode(String code) {
    if (code.toUpperCase() == 'FIRST20') {
      _promoCode = code;
      _discount = 0.20;
      notifyListeners();
      return true;
    }
    if (code.toUpperCase() == 'SAVE10') {
      _promoCode = code;
      _discount = 0.10;
      notifyListeners();
      return true;
    }
    return false;
  }

  // ✅ USED IN PaymentScreen
  double calculateTotal(double fee) {
    return fee * (1 - _discount);
  }

  void reset() {
    _selectedDate = null;
    _selectedTime = null;
    _consultationType = 'online';
    _promoCode = null;
    _discount = 0;
    notifyListeners();
  }
}
