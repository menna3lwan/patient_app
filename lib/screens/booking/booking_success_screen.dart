import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import '../../widgets/widgets.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String appointmentId;
  const BookingSuccessScreen({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final appointments = Provider.of<AppointmentsProvider>(context);
    final apt = appointments.getAppointmentById(appointmentId);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Success icon
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
                child: const Icon(Iconsax.tick_circle5, size: 60, color: AppColors.success),
              ),
              const SizedBox(height: 32),
              Text(locale.get('bookingSuccess'), style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 12),
              Text('تم حجز موعدك بنجاح وسيتم تأكيده قريباً', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color), textAlign: TextAlign.center),
              const SizedBox(height: 32),
              // Appointment details card
              if (apt != null) Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Row(children: [
                      CircleAvatar(radius: 24, backgroundColor: AppColors.primaryLight, child: Text(apt.doctor.name.length > 3 ? apt.doctor.name[3] : apt.doctor.name[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary))),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(apt.doctor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(apt.doctor.specialtyAr, style: Theme.of(context).textTheme.bodySmall),
                      ])),
                    ]),
                    const Divider(height: 28),
                    _DetailRow(icon: Iconsax.calendar, text: '${apt.date.day}/${apt.date.month}/${apt.date.year}'),
                    const SizedBox(height: 12),
                    _DetailRow(icon: Iconsax.clock, text: apt.time),
                    const SizedBox(height: 12),
                    _DetailRow(icon: apt.type == 'online' ? Iconsax.video : Iconsax.building, text: apt.typeAr),
                    const SizedBox(height: 12),
                    _DetailRow(icon: Iconsax.wallet_money, text: '${apt.amount.toInt()} ${locale.get('egp')}'),
                  ]),
                ),
              ),
              const Spacer(),
              // Buttons
              AppButton(text: locale.get('myAppointments'), onPressed: () => context.go('/')),
              const SizedBox(height: 12),
              AppButton(text: locale.get('home'), onPressed: () => context.go('/'), isOutlined: true),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _DetailRow({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, size: 20, color: AppColors.primary), const SizedBox(width: 12), Text(text, style: const TextStyle(fontWeight: FontWeight.w500))]);
}
