import '../models/models.dart';
import '../services/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<UserModel?> login(String email, String password) async {
    // TODO: Replace with actual API call
    // final response = await _apiClient.client.post('/auth/login', data: {'email': email, 'password': password});
    await Future.delayed(const Duration(seconds: 1));
    
    if (email == 'test@test.com' && password == '123456') {
      return UserModel(
        id: 'p1',
        name: 'منة علوان',
        email: email,
        phone: '01012345678',
        governorate: 'القاهرة',
        bloodType: 'A+',
      );
    }
    return null;
  }

  Future<UserModel?> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String governorate,
  }) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      governorate: governorate,
    );
  }
}
