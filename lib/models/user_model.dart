// User Model
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String governorate;
  final String? avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.governorate,
    this.avatar,
  });
}

// Doctor Model
class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String specialtyAr;
  final double rating;
  final int reviewsCount;
  final int experienceYears;
  final int patientsCount;
  final double consultationFee;
  final String bio;
  final String? avatar;
  final bool isOnlineAvailable;
  final List<String> availableDays;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.specialtyAr,
    required this.rating,
    required this.reviewsCount,
    required this.experienceYears,
    required this.patientsCount,
    required this.consultationFee,
    required this.bio,
    this.avatar,
    this.isOnlineAvailable = true,
    this.availableDays = const [
      'السبت',
      'الأحد',
      'الاثنين',
      'الثلاثاء',
      'الأربعاء'
    ],
  });
}

// Appointment Model
class AppointmentModel {
  final String id;
  final DoctorModel doctor;
  final DateTime date;
  final String time;
  final String type; // online / clinic
  final String status; // pending, confirmed, completed, cancelled
  final double amount;

  AppointmentModel({
    required this.id,
    required this.doctor,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
    required this.amount,
  });

  String get statusAr {
    switch (status) {
      case 'pending':
        return 'في الانتظار';
      case 'confirmed':
        return 'مؤكد';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }
}

// Mock Data
class MockData {
  static List<DoctorModel> get doctors => [
        DoctorModel(
          id: '1',
          name: 'د. منة ماهر',
          specialty: 'gynecology',
          specialtyAr: 'نساء وتوليد',
          rating: 4.9,
          reviewsCount: 324,
          experienceYears: 15,
          patientsCount: 1250,
          consultationFee: 200,
          bio:
              'استشارية أمراض النساء والتوليد، خبرة 15 عام في المستشفيات الكبرى',
        ),
        DoctorModel(
          id: '2',
          name: 'د. منى محمد',
          specialty: 'dermatology',
          specialtyAr: 'جلدية وتجميل',
          rating: 4.8,
          reviewsCount: 256,
          experienceYears: 12,
          patientsCount: 980,
          consultationFee: 250,
          bio: 'أخصائية الأمراض الجلدية والتجميل، متخصصة في علاج مشاكل البشرة',
        ),
        DoctorModel(
          id: '3',
          name: 'د. شهد  بدوي',
          specialty: 'psychology',
          specialtyAr: 'نفسية',
          rating: 4.9,
          reviewsCount: 189,
          experienceYears: 10,
          patientsCount: 650,
          consultationFee: 300,
          bio: 'استشارية الطب النفسي، متخصصة في علاج القلق والاكتئاب',
        ),
        DoctorModel(
          id: '4',
          name: 'د. هدى علي',
          specialty: 'gynecology',
          specialtyAr: 'نساء وتوليد',
          rating: 4.7,
          reviewsCount: 198,
          experienceYears: 8,
          patientsCount: 720,
          consultationFee: 180,
          bio: 'أخصائية أمراض النساء والتوليد، رعاية متكاملة للمرأة',
        ),
        DoctorModel(
          id: '5',
          name: 'د. فاطمة عبدالله',
          specialty: 'dermatology',
          specialtyAr: 'جلدية وتجميل',
          rating: 4.6,
          reviewsCount: 145,
          experienceYears: 7,
          patientsCount: 520,
          consultationFee: 220,
          bio: 'أخصائية الجلدية والتجميل، علاج حب الشباب والتصبغات',
        ),
      ];

  static List<AppointmentModel> get appointments => [
        AppointmentModel(
          id: '1',
          doctor: doctors[0],
          date: DateTime.now().add(const Duration(days: 2)),
          time: '10:00 ص',
          type: 'online',
          status: 'confirmed',
          amount: 200,
        ),
        AppointmentModel(
          id: '2',
          doctor: doctors[1],
          date: DateTime.now().add(const Duration(days: 5)),
          time: '02:00 م',
          type: 'clinic',
          status: 'pending',
          amount: 250,
        ),
        AppointmentModel(
          id: '3',
          doctor: doctors[2],
          date: DateTime.now().subtract(const Duration(days: 3)),
          time: '11:00 ص',
          type: 'online',
          status: 'completed',
          amount: 300,
        ),
      ];
}
