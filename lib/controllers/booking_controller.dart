import 'package:get/get.dart';

class BookingController extends GetxController {
  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<String>();
  final consultationType = 'online'.obs;
  final promoCode = Rxn<String>();
  final discount = 0.0.obs;

  bool get canProceed => selectedDate.value != null && selectedTime.value != null;

  void setConsultationType(String type) {
    consultationType.value = type;
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
    selectedTime.value = null;
  }

  void setTime(String time) {
    selectedTime.value = time;
  }

  bool applyPromoCode(String code) {
    if (code.toUpperCase() == 'FIRST20') {
      promoCode.value = code;
      discount.value = 0.20;
      return true;
    }
    if (code.toUpperCase() == 'SAVE10') {
      promoCode.value = code;
      discount.value = 0.10;
      return true;
    }
    return false;
  }

  double calculateTotal(double fee) {
    return fee * (1 - discount.value);
  }

  void reset() {
    selectedDate.value = null;
    selectedTime.value = null;
    consultationType.value = 'online';
    promoCode.value = null;
    discount.value = 0;
  }
}
