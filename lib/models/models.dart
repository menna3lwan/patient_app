class UserModel {
  final String id, name, email, phone, governorate;
  final String? avatar, bloodType;
  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.governorate,
      this.avatar,
      this.bloodType});
  UserModel copyWith(
          {String? name, String? phone, String? governorate, String? avatar}) =>
      UserModel(
          id: id,
          name: name ?? this.name,
          email: email,
          phone: phone ?? this.phone,
          governorate: governorate ?? this.governorate,
          avatar: avatar ?? this.avatar,
          bloodType: bloodType);
}

class DoctorModel {
  final String id, name, specialty, specialtyAr, bio;
  final double rating, consultationFee;
  final int reviewsCount, experienceYears, patientsCount;
  final String? avatar, clinicAddress;
  final bool isOnline, isVerified;
  DoctorModel(
      {required this.id,
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
      this.clinicAddress,
      this.isOnline = true,
      this.isVerified = true});
}

class AppointmentModel {
  final String id, time, type, status;
  final DoctorModel doctor;
  final DateTime date, createdAt;
  final double amount;
  final String? notes;
  AppointmentModel(
      {required this.id,
      required this.doctor,
      required this.date,
      required this.time,
      required this.type,
      required this.status,
      required this.amount,
      this.notes,
      DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();
  String get statusAr =>
      {
        'pending': 'في الانتظار',
        'confirmed': 'مؤكد',
        'completed': 'مكتمل',
        'cancelled': 'ملغي'
      }[status] ??
      status;
  String get typeAr => type == 'online' ? 'أونلاين' : 'في العيادة';
  AppointmentModel copyWith({String? status, String? notes}) =>
      AppointmentModel(
          id: id,
          doctor: doctor,
          date: date,
          time: time,
          type: type,
          status: status ?? this.status,
          amount: amount,
          notes: notes ?? this.notes,
          createdAt: createdAt);
}

class PostModel {
  final String id, userId, userName, content;
  final String? userAvatar;
  int likes, commentsCount;
  final DateTime createdAt;
  bool isLiked, isAnonymous;
  List<CommentModel> comments;
  PostModel(
      {required this.id,
      required this.userId,
      required this.userName,
      required this.content,
      this.userAvatar,
      this.likes = 0,
      this.commentsCount = 0,
      DateTime? createdAt,
      this.isLiked = false,
      this.isAnonymous = false,
      List<CommentModel>? comments})
      : createdAt = createdAt ?? DateTime.now(),
        comments = comments ?? [];
  String get timeAgo {
    final d = DateTime.now().difference(createdAt);
    if (d.inMinutes < 60) return 'منذ ${d.inMinutes} دقيقة';
    if (d.inHours < 24) return 'منذ ${d.inHours} ساعة';
    return 'منذ ${d.inDays} يوم';
  }
}

class CommentModel {
  final String id, userId, userName, content;
  final String? userAvatar;
  final DateTime createdAt;
  bool isAnonymous;
  CommentModel(
      {required this.id,
      required this.userId,
      required this.userName,
      required this.content,
      this.userAvatar,
      DateTime? createdAt,
      this.isAnonymous = false})
      : createdAt = createdAt ?? DateTime.now();
}

class NotificationModel {
  final String id, title, body, type;
  final DateTime createdAt;
  bool isRead;
  NotificationModel(
      {required this.id,
      required this.title,
      required this.body,
      required this.type,
      DateTime? createdAt,
      this.isRead = false})
      : createdAt = createdAt ?? DateTime.now();
  String get timeAgo {
    final d = DateTime.now().difference(createdAt);
    if (d.inMinutes < 60) return 'منذ ${d.inMinutes} دقيقة';
    if (d.inHours < 24) return 'منذ ${d.inHours} ساعة';
    return 'منذ ${d.inDays} يوم';
  }
}

class ReviewModel {
  final String id, userName, comment;
  final double rating;
  final DateTime createdAt;
  ReviewModel(
      {required this.id,
      required this.userName,
      required this.rating,
      required this.comment,
      DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();
}

class TimeSlotModel {
  final String time;
  final bool isAvailable;
  TimeSlotModel({required this.time, this.isAvailable = true});
}

class SpecialtyModel {
  final String id, nameAr, nameEn, icon;
  final int color;
  SpecialtyModel(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.icon,
      required this.color});
}

class MockData {
  static List<SpecialtyModel> get specialties => [
        SpecialtyModel(
            id: 'gynecology',
            nameAr: 'نساء وتوليد',
            nameEn: 'Gynecology',
            icon: '👩‍⚕️',
            color: 0xFFE91E8C),
        SpecialtyModel(
            id: 'dermatology',
            nameAr: 'جلدية وتجميل',
            nameEn: 'Dermatology',
            icon: '✨',
            color: 0xFF9C27B0),
        SpecialtyModel(
            id: 'psychology',
            nameAr: 'نفسية',
            nameEn: 'Psychology',
            icon: '🧠',
            color: 0xFF3F51B5),
        SpecialtyModel(
            id: 'nutrition',
            nameAr: 'تغذية',
            nameEn: 'Nutrition',
            icon: '🥗',
            color: 0xFF4CAF50),
        SpecialtyModel(
            id: 'pediatrics',
            nameAr: 'أطفال',
            nameEn: 'Pediatrics',
            icon: '👶',
            color: 0xFF00BCD4),
        SpecialtyModel(
            id: 'general',
            nameAr: 'طب عام',
            nameEn: 'General',
            icon: '🏥',
            color: 0xFF607D8B),
      ];

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
            bio: 'استشارية أمراض النساء والتوليد، خبرة 15 عام',
            isOnline: true,
            clinicAddress: 'مدينة نصر'),
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
            bio: 'أخصائية الأمراض الجلدية والتجميل',
            isOnline: true,
            clinicAddress: 'المعادي'),
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
            bio: 'استشارية الطب النفسي',
            isOnline: true),
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
            bio: 'أخصائية أمراض النساء',
            isOnline: true,
            clinicAddress: 'الدقي'),
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
            bio: 'أخصائية الجلدية',
            isOnline: false,
            clinicAddress: 'الإسكندرية'),
        DoctorModel(
            id: '6',
            name: 'د. ليلى إبراهيم',
            specialty: 'psychology',
            specialtyAr: 'نفسية',
            rating: 4.8,
            reviewsCount: 167,
            experienceYears: 9,
            patientsCount: 480,
            consultationFee: 280,
            bio: 'أخصائية نفسية',
            isOnline: true),
        DoctorModel(
            id: '7',
            name: 'د. رنا سمير',
            specialty: 'nutrition',
            specialtyAr: 'تغذية',
            rating: 4.7,
            reviewsCount: 210,
            experienceYears: 6,
            patientsCount: 890,
            consultationFee: 150,
            bio: 'أخصائية تغذية علاجية',
            isOnline: true),
        DoctorModel(
            id: '8',
            name: 'د. أميرة خالد',
            specialty: 'pediatrics',
            specialtyAr: 'أطفال',
            rating: 4.9,
            reviewsCount: 298,
            experienceYears: 11,
            patientsCount: 1100,
            consultationFee: 200,
            bio: 'أخصائية طب الأطفال',
            isOnline: true,
            clinicAddress: 'مصر الجديدة'),
      ];

  static List<AppointmentModel> get appointments => [
        AppointmentModel(
            id: '1',
            doctor: doctors[0],
            date: DateTime.now().add(const Duration(days: 2)),
            time: '10:00 ص',
            type: 'online',
            status: 'confirmed',
            amount: 200),
        AppointmentModel(
            id: '2',
            doctor: doctors[1],
            date: DateTime.now().add(const Duration(days: 5)),
            time: '02:00 م',
            type: 'clinic',
            status: 'pending',
            amount: 250),
        AppointmentModel(
            id: '3',
            doctor: doctors[2],
            date: DateTime.now().subtract(const Duration(days: 3)),
            time: '11:00 ص',
            type: 'online',
            status: 'completed',
            amount: 300),
        AppointmentModel(
            id: '4',
            doctor: doctors[3],
            date: DateTime.now().subtract(const Duration(days: 10)),
            time: '09:00 ص',
            type: 'clinic',
            status: 'completed',
            amount: 180),
        AppointmentModel(
            id: '5',
            doctor: doctors[4],
            date: DateTime.now().subtract(const Duration(days: 15)),
            time: '04:00 م',
            type: 'online',
            status: 'cancelled',
            amount: 220),
      ];

  static List<PostModel> get posts => [
        PostModel(
            id: '1',
            userId: 'u1',
            userName: 'منة',
            content: 'هل فيه حد جرب علاج معين لتساقط الشعر ؟ ',
            likes: 24,
            commentsCount: 8,
            createdAt: DateTime.now().subtract(const Duration(hours: 2))),
        PostModel(
            id: '2',
            userId: 'u2',
            userName: 'منى',
            content: 'شكراً لكم على المجتمع الرائع ده ',
            likes: 45,
            commentsCount: 12,
            createdAt: DateTime.now().subtract(const Duration(hours: 5))),
        PostModel(
            id: '3',
            userId: 'u3',
            userName: 'شهد ',
            content: 'نصيحة: شرب الماء مهم جداً للبشرة 💧',
            likes: 67,
            commentsCount: 15,
            createdAt: DateTime.now().subtract(const Duration(hours: 8))),
        PostModel(
            id: '4',
            userId: 'u4',
            userName: 'هدى',
            content: 'التجربة مع د. منة ماهر كانت ممتازة ⭐',
            likes: 32,
            commentsCount: 6,
            createdAt: DateTime.now().subtract(const Duration(days: 1))),
        PostModel(
            id: '5',
            userId: 'u5',
            userName: '',
            content: 'حد يعرف أعراض نقص فيتامين د؟',
            likes: 18,
            commentsCount: 9,
            isAnonymous: true,
            createdAt: DateTime.now().subtract(const Duration(days: 1))),
      ];

  static List<NotificationModel> get notifications => [
        NotificationModel(
            id: '1',
            title: 'تأكيد الموعد',
            body: 'تم تأكيد موعدك مع د. منة ماهر',
            type: 'appointment',
            isRead: false,
            createdAt: DateTime.now().subtract(const Duration(hours: 1))),
        NotificationModel(
            id: '2',
            title: 'تذكير بالموعد',
            body: 'موعدك غداً الساعة 2:00 م',
            type: 'appointment',
            isRead: false,
            createdAt: DateTime.now().subtract(const Duration(hours: 3))),
        NotificationModel(
            id: '3',
            title: 'رسالة جديدة',
            body: 'لديك رسالة من د. شهد  بدوي',
            type: 'message',
            isRead: true,
            createdAt: DateTime.now().subtract(const Duration(days: 1))),
        NotificationModel(
            id: '4',
            title: 'عرض خاص! 🎉',
            body: 'خصم 20% على أول استشارة',
            type: 'promotion',
            isRead: true,
            createdAt: DateTime.now().subtract(const Duration(days: 2))),
      ];

  static List<ReviewModel> get reviews => [
        ReviewModel(
            id: '1',
            userName: 'مريم ماهر',
            rating: 5,
            comment: 'دكتورة ممتازة ومتفهمة جداً',
            createdAt: DateTime.now().subtract(const Duration(days: 7))),
        ReviewModel(
            id: '2',
            userName: 'نور محمد',
            rating: 5,
            comment: 'تجربة رائعة وأنصح بها بشدة',
            createdAt: DateTime.now().subtract(const Duration(days: 14))),
        ReviewModel(
            id: '3',
            userName: 'سلمى علي',
            rating: 4,
            comment: 'شكراً على الاهتمام والمتابعة',
            createdAt: DateTime.now().subtract(const Duration(days: 30))),
      ];

  static List<TimeSlotModel> get timeSlots => [
        TimeSlotModel(time: '09:00 ص'),
        TimeSlotModel(time: '09:30 ص', isAvailable: false),
        TimeSlotModel(time: '10:00 ص'),
        TimeSlotModel(time: '10:30 ص'),
        TimeSlotModel(time: '11:00 ص', isAvailable: false),
        TimeSlotModel(time: '11:30 ص'),
        TimeSlotModel(time: '12:00 م'),
        TimeSlotModel(time: '02:00 م'),
        TimeSlotModel(time: '02:30 م', isAvailable: false),
        TimeSlotModel(time: '03:00 م'),
        TimeSlotModel(time: '03:30 م'),
        TimeSlotModel(time: '04:00 م'),
      ];

  static List<String> get governorates => [
        'القاهرة',
        'الجيزة',
        'الإسكندرية',
        'الدقهلية',
        'الشرقية',
        'المنوفية',
        'القليوبية',
        'الغربية',
        'كفر الشيخ',
        'دمياط',
        'البحيرة',
        'الفيوم',
        'بني سويف',
        'المنيا',
        'أسيوط',
        'سوهاج',
        'قنا',
        'الأقصر',
        'أسوان',
        'البحر الأحمر',
        'بورسعيد',
        'السويس',
        'الإسماعيلية'
      ];
}
