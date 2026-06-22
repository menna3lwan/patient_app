import 'package:get/get.dart';
import '../models/models.dart';
import '../repositories/auth_repository.dart';

class AuthController extends GetxController {
  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final error = Rxn<String>();

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    error.value = null;

    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || !email.contains('@')) {
      error.value = 'البريد الإلكتروني غير صالح';
      isLoading.value = false;
      return false;
    }

    if (password.length < 6) {
      error.value = 'كلمة المرور قصيرة';
      isLoading.value = false;
      return false;
    }

    final authRepo = AuthRepository();
    user.value = await authRepo.login(email, password);

    if (user.value == null) {
      error.value = 'بيانات الدخول غير صحيحة';
      isLoading.value = false;
      return false;
    }

    isLoggedIn.value = true;
    isLoading.value = false;
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String governorate,
  }) async {
    isLoading.value = true;
    error.value = null;

    await Future.delayed(const Duration(seconds: 1));

    if (name.length < 3) {
      error.value = 'الاسم قصير';
      isLoading.value = false;
      return false;
    }

    user.value = UserModel(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      governorate: governorate,
    );

    isLoggedIn.value = true;
    isLoading.value = false;
    return true;
  }

  void updateProfile({
    String? name,
    String? phone,
    String? governorate,
    String? avatar,
  }) {
    if (user.value == null) return;
    user.value = user.value!.copyWith(
      name: name,
      phone: phone,
      governorate: governorate,
      avatar: avatar,
    );
  }

  void logout() {
    user.value = null;
    isLoggedIn.value = false;
    error.value = null;
  }

  void clearError() {
    error.value = null;
  }
}
