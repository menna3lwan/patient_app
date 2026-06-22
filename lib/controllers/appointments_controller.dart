import 'package:get/get.dart';
import '../models/models.dart';

class AppointmentsController extends GetxController {
  final _appointments = RxList<AppointmentModel>(MockData.appointments);
  final isLoading = false.obs;

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

  Future<AppointmentModel> bookAppointment({
    required DoctorModel doctor,
    required DateTime date,
    required String time,
    required String type,
    required double amount,
  }) async {
    isLoading.value = true;

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

    isLoading.value = false;

    return appointment;
  }

  void cancelAppointment(String id) => _updateStatus(id, 'cancelled');

  void confirmAppointment(String id) => _updateStatus(id, 'confirmed');

  void completeAppointment(String id) => _updateStatus(id, 'completed');

  void _updateStatus(String id, String status) {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index == -1) return;

    _appointments[index] = _appointments[index].copyWith(status: status);
  }
}
