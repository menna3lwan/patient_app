import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import '../../widgets/widgets.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final String appointmentId;
  const AppointmentDetailsScreen({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final appointments = Provider.of<AppointmentsProvider>(context);
    final apt = appointments.getAppointmentById(appointmentId);

    if (apt == null) {
      return Scaffold(appBar: AppBar(), body: Center(child: Text(locale.get('error'))));
    }

    final statusColor = {'pending': AppColors.warning, 'confirmed': AppColors.success, 'completed': AppColors.info, 'cancelled': AppColors.error}[apt.status] ?? AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Iconsax.arrow_right_3), onPressed: () => context.pop()),
        title: Text(locale.get('appointmentDetails')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(apt.statusAr, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
            // Doctor card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  CircleAvatar(radius: 32, backgroundColor: AppColors.primaryLight, child: Text(apt.doctor.name.length > 3 ? apt.doctor.name[3] : apt.doctor.name[0], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary))),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(apt.doctor.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(apt.doctor.specialtyAr, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Row(children: [const Icon(Icons.star_rounded, size: 16, color: Colors.amber), const SizedBox(width: 4), Text('${apt.doctor.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))]),
                  ])),
                  IconButton(icon: const Icon(Iconsax.arrow_left_2), onPressed: () => context.push('/doctor/${apt.doctor.id}')),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            // Details card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  _DetailItem(icon: Iconsax.calendar, title: locale.get('selectDate'), value: '${apt.date.day}/${apt.date.month}/${apt.date.year}'),
                  const Divider(height: 24),
                  _DetailItem(icon: Iconsax.clock, title: locale.get('selectTime'), value: apt.time),
                  const Divider(height: 24),
                  _DetailItem(icon: apt.type == 'online' ? Iconsax.video : Iconsax.building, title: locale.get('consultationType'), value: apt.typeAr),
                  const Divider(height: 24),
                  _DetailItem(icon: Iconsax.wallet_money, title: locale.get('total'), value: '${apt.amount.toInt()} ${locale.get('egp')}'),
                ]),
              ),
            ),
            const SizedBox(height: 24),
            // Actions
            if (apt.status == 'confirmed') AppButton(text: locale.get('startConsultation'), onPressed: () => context.push('/chat/$appointmentId'), icon: Iconsax.video),
            if (apt.status == 'pending' || apt.status == 'confirmed') ...[
              const SizedBox(height: 12),
              AppButton(text: locale.get('cancelAppointment'), onPressed: () => _showCancelDialog(context, apt.id, appointments, locale), isOutlined: true, color: AppColors.error),
            ],
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String id, AppointmentsProvider provider, LocaleProvider locale) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(locale.get('cancelAppointment')),
        content: Text(locale.get('cancelConfirm')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(locale.get('no'))),
          ElevatedButton(onPressed: () { provider.cancelAppointment(id); Navigator.pop(ctx); context.pop(); }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.error), child: Text(locale.get('yes'))),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title, value;
  const _DetailItem({required this.icon, required this.title, required this.value});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.primary, size: 20)),
    const SizedBox(width: 14),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.bodySmall), const SizedBox(height: 2), Text(value, style: const TextStyle(fontWeight: FontWeight.w600))]),
  ]);
}
