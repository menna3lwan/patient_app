import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../config/providers.dart';
import '../../models/models.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('مواعيدي'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'القادمة (${provider.upcomingAppointments.length})'),
            Tab(text: 'المكتملة (${provider.completedAppointments.length})'),
            Tab(text: 'الملغية (${provider.cancelledAppointments.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(context, provider.upcomingAppointments, 'upcoming'),
          _buildList(context, provider.completedAppointments, 'completed'),
          _buildList(context, provider.cancelledAppointments, 'cancelled'),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<AppointmentModel> list,
    String type,
  ) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == 'upcoming'
                  ? Icons.calendar_today
                  : type == 'completed'
                      ? Icons.check_circle_outline
                      : Icons.cancel_outlined,
              size: 64,
              color: Theme.of(context).dividerColor,
            ),
            const SizedBox(height: 16),
            Text(
              type == 'upcoming'
                  ? 'لا توجد مواعيد قادمة'
                  : type == 'completed'
                      ? 'لا توجد مواعيد مكتملة'
                      : 'لا توجد مواعيد ملغية',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (type == 'upcoming') ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.push('/search'),
                icon: const Icon(Icons.search),
                label: const Text('البحث عن دكتورة'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final apt = list[i];
        return _AppointmentCard(
          appointment: apt,
          onChat: apt.status == 'confirmed'
              ? () => context.push('/chat/${apt.id}')
              : null,
          onCancel: (apt.status == 'pending' || apt.status == 'confirmed')
              ? () => _showCancelDialog(context, apt)
              : null,
          onRate:
              apt.status == 'completed' ? () => _showRatingDialog(context) : null,
          onRebook: (apt.status == 'cancelled' || apt.status == 'completed')
              ? () => context.push('/doctor/${apt.doctor.id}')
              : null,
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, AppointmentModel apt) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إلغاء الموعد'),
        content: const Text(
          'هل أنت متأكدة من إلغاء هذا الموعد؟\nسيتم استرداد العربون خلال 3-5 أيام عمل.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('لا'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () {
              context
                  .read<AppointmentsProvider>()
                  .cancelAppointment(apt.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إلغاء الموعد'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: const Text('نعم، إلغاء'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    double rating = 5;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('تقييم الاستشارة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    icon: Icon(
                      Icons.star,
                      color: i < rating ? Colors.amber : Colors.grey.shade300,
                    ),
                    onPressed: () => setState(() => rating = i + 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'تعليقك (اختياري)',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('شكراً لتقييمك! ⭐'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('إرسال'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onChat;
  final VoidCallback? onCancel;
  final VoidCallback? onRate;
  final VoidCallback? onRebook;

  const _AppointmentCard({
    required this.appointment,
    this.onChat,
    this.onCancel,
    this.onRate,
    this.onRebook,
  });

  Color get _statusColor {
    switch (appointment.status) {
      case 'pending':
        return AppColors.warning;
      case 'confirmed':
        return AppColors.success;
      case 'completed':
        return AppColors.info;
      case 'cancelled':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    appointment.doctor.name[0],
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctor.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        appointment.doctor.specialtyAr,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    appointment.statusAr,
                    style: TextStyle(
                      color: _statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
