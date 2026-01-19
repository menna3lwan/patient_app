import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class BookingScreen extends StatefulWidget {
  final String doctorId;
  const BookingScreen({super.key, required this.doctorId});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => Provider.of<BookingProvider>(context, listen: false).reset());
  }

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final doctors = Provider.of<DoctorsProvider>(context);
    final booking = Provider.of<BookingProvider>(context);
    final doctor = doctors.getDoctorById(widget.doctorId);

    if (doctor == null) {
      return Scaffold(appBar: AppBar(), body: Center(child: Text(locale.get('error'))));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Iconsax.arrow_right_3), onPressed: () => context.pop()),
        title: Text(locale.get('bookAppointment')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  CircleAvatar(radius: 28, backgroundColor: AppColors.primaryLight, child: Text(doctor.name.length > 3 ? doctor.name[3] : doctor.name[0], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary))),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(doctor.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(doctor.specialtyAr, style: Theme.of(context).textTheme.bodySmall),
                  ])),
                  Text('${doctor.consultationFee.toInt()} ${locale.get('egp')}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                ]),
              ),
            ),
            const SizedBox(height: 24),
            // Consultation type
            Text(locale.get('consultationType'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _TypeCard(icon: Iconsax.video, title: locale.get('online'), isSelected: booking.consultationType == 'online', onTap: () => booking.setConsultationType('online'))),
              const SizedBox(width: 12),
              Expanded(child: _TypeCard(icon: Iconsax.building, title: locale.get('clinic'), isSelected: booking.consultationType == 'clinic', onTap: () => booking.setConsultationType('clinic'), enabled: doctor.clinicAddress != null)),
            ]),
            const SizedBox(height: 24),
            // Date selection
            Text(locale.get('selectDate'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 14,
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index + 1));
                  final isSelected = booking.selectedDate?.day == date.day && booking.selectedDate?.month == date.month;
                  return _DateCard(date: date, isSelected: isSelected, onTap: () => booking.setDate(date));
                },
              ),
            ),
            const SizedBox(height: 24),
            // Time selection
            Text(locale.get('selectTime'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            if (booking.selectedDate == null)
              Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(locale.get('selectDate'), style: Theme.of(context).textTheme.bodySmall)))
            else
              Wrap(
                spacing: 10, runSpacing: 10,
                children: MockData.timeSlots.map((slot) => _TimeSlot(time: slot.time, isAvailable: slot.isAvailable, isSelected: booking.selectedTime == slot.time, onTap: slot.isAvailable ? () => booking.setTime(slot.time) : null)).toList(),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
        child: SafeArea(child: AppButton(text: locale.get('continueToPayment'), onPressed: booking.canProceed ? () => context.push('/payment', extra: widget.doctorId) : null)),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected, enabled;
  final VoidCallback? onTap;
  const _TypeCard({required this.icon, required this.title, required this.isSelected, this.onTap, this.enabled = true});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : Theme.of(context).dividerColor),
        ),
        child: Column(children: [
          Icon(icon, size: 32, color: isSelected ? Colors.white : (enabled ? AppColors.primary : Theme.of(context).dividerColor)),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? Colors.white : (enabled ? null : Theme.of(context).dividerColor))),
        ]),
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;
  const _DateCard({required this.date, required this.isSelected, required this.onTap});
  
  String get dayName => ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'][date.weekday % 7];
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 65,
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: isSelected ? AppColors.primary : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: isSelected ? AppColors.primary : Theme.of(context).dividerColor)),
        child: Column(children: [
          Text(dayName, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white70 : Theme.of(context).textTheme.bodySmall?.color)),
          const SizedBox(height: 4),
          Text('${date.day}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : null)),
          Text('${date.month}/${date.year.toString().substring(2)}', style: TextStyle(fontSize: 11, color: isSelected ? Colors.white70 : Theme.of(context).textTheme.bodySmall?.color)),
        ]),
      ),
    );
  }
}

class _TimeSlot extends StatelessWidget {
  final String time;
  final bool isAvailable, isSelected;
  final VoidCallback? onTap;
  const _TimeSlot({required this.time, required this.isAvailable, required this.isSelected, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : (isAvailable ? Theme.of(context).cardColor : Theme.of(context).dividerColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : (isAvailable ? Theme.of(context).dividerColor : Colors.transparent)),
        ),
        child: Text(time, style: TextStyle(fontWeight: isSelected ? FontWeight.w600 : null, color: isSelected ? Colors.white : (isAvailable ? null : Theme.of(context).textTheme.bodySmall?.color))),
      ),
    );
  }
}
