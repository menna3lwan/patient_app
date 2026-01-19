import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import '../../widgets/widgets.dart';

class AppointmentsTab extends StatefulWidget {
  const AppointmentsTab({super.key});
  @override
  State<AppointmentsTab> createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends State<AppointmentsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() { super.initState(); _tabController = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final appointments = Provider.of<AppointmentsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.get('myAppointments')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: locale.get('upcoming')),
            Tab(text: locale.get('completed')),
            Tab(text: locale.get('cancelled')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Upcoming
          _AppointmentList(
            appointments: appointments.upcomingAppointments,
            emptyIcon: Iconsax.calendar_1,
            emptyTitle: locale.get('noAppointments'),
            emptySubtitle: locale.get('searchDoctors'),
            emptyButtonText: locale.get('topDoctors'),
            onEmptyButtonPressed: () => context.push('/search'),
            onCancel: (id) => _showCancelDialog(context, id, appointments, locale),
            onStart: (id) => context.push('/chat/$id'),
          ),
          // Completed
          _AppointmentList(
            appointments: appointments.completedAppointments,
            emptyIcon: Iconsax.tick_circle,
            emptyTitle: locale.get('noAppointments'),
          ),
          // Cancelled
          _AppointmentList(
            appointments: appointments.cancelledAppointments,
            emptyIcon: Iconsax.close_circle,
            emptyTitle: locale.get('noAppointments'),
          ),
        ],
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
          ElevatedButton(
            onPressed: () { provider.cancelAppointment(id); Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(locale.get('appointmentCancelled')))); },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(locale.get('yes')),
          ),
        ],
      ),
    );
  }
}

class _AppointmentList extends StatelessWidget {
  final List appointments;
  final IconData emptyIcon;
  final String emptyTitle;
  final String? emptySubtitle, emptyButtonText;
  final VoidCallback? onEmptyButtonPressed;
  final Function(String)? onCancel, onStart;

  const _AppointmentList({required this.appointments, required this.emptyIcon, required this.emptyTitle, this.emptySubtitle, this.emptyButtonText, this.onEmptyButtonPressed, this.onCancel, this.onStart});

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return EmptyState(icon: emptyIcon, title: emptyTitle, subtitle: emptySubtitle, buttonText: emptyButtonText, onButtonPressed: onEmptyButtonPressed);
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final apt = appointments[index];
        return AppointmentCard(
          doctorName: apt.doctor.name,
          specialty: apt.doctor.specialtyAr,
          date: '${apt.date.day}/${apt.date.month}/${apt.date.year}',
          time: apt.time,
          type: apt.type,
          status: apt.status,
          onTap: () => context.push('/appointment/${apt.id}'),
          onCancel: onCancel != null ? () => onCancel!(apt.id) : null,
          onStart: onStart != null && apt.status == 'confirmed' ? () => onStart!(apt.id) : null,
        );
      },
    );
  }
}
