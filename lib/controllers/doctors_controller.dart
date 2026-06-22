import 'package:get/get.dart';
import '../models/models.dart';

class DoctorsController extends GetxController {
  final _doctors = RxList<DoctorModel>(MockData.doctors);
  final selectedSpecialty = Rxn<String>();
  final searchQuery = ''.obs;
  final sortBy = 'rating'.obs;

  List<DoctorModel> get doctors => _filteredDoctors;
  List<DoctorModel> get allDoctors => _doctors;

  List<DoctorModel> get topDoctors {
    final list = List<DoctorModel>.from(_doctors);
    list.sort((a, b) => b.rating.compareTo(a.rating));
    return list;
  }

  List<DoctorModel> get _filteredDoctors {
    var result = List<DoctorModel>.from(_doctors);

    if (selectedSpecialty.value != null && selectedSpecialty.value!.isNotEmpty) {
      result = result.where((d) => d.specialty == selectedSpecialty.value).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      result = result
          .where((d) =>
              d.name.contains(searchQuery.value) ||
              d.specialtyAr.contains(searchQuery.value))
          .toList();
    }

    switch (sortBy.value) {
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
    selectedSpecialty.value = specialty;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setSortBy(String sort) {
    sortBy.value = sort;
  }

  void clearFilters() {
    selectedSpecialty.value = null;
    searchQuery.value = '';
    sortBy.value = 'rating';
  }
}
