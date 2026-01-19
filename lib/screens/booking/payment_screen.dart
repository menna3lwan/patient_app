import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import '../../widgets/widgets.dart';

class PaymentScreen extends StatefulWidget {
  final String doctorId;
  const PaymentScreen({super.key, required this.doctorId});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'credit';
  final _promoController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() { _promoController.dispose(); super.dispose(); }

  Future<void> _confirmPayment() async {
    setState(() => _isLoading = true);
    final doctors = Provider.of<DoctorsProvider>(context, listen: false);
    final booking = Provider.of<BookingProvider>(context, listen: false);
    final appointments = Provider.of<AppointmentsProvider>(context, listen: false);
    final doctor = doctors.getDoctorById(widget.doctorId);
    
    if (doctor == null || booking.selectedDate == null || booking.selectedTime == null) return;
    
    await Future.delayed(const Duration(seconds: 1));
    final apt = await appointments.bookAppointment(
      doctor: doctor,
      date: booking.selectedDate!,
      time: booking.selectedTime!,
      type: booking.consultationType,
      amount: booking.calculateTotal(doctor.consultationFee),
    );
    
    if (mounted) context.go('/booking-success', extra: apt.id);
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

    final fee = doctor.consultationFee;
    final discount = fee * booking.discount;
    final serviceFee = 10.0;
    final total = fee - discount + serviceFee;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Iconsax.arrow_right_3), onPressed: () => context.pop()),
        title: Text(locale.get('payment')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appointment summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Row(children: [
                    CircleAvatar(radius: 24, backgroundColor: AppColors.primaryLight, child: Text(doctor.name.length > 3 ? doctor.name[3] : doctor.name[0], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(doctor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(doctor.specialtyAr, style: Theme.of(context).textTheme.bodySmall),
                    ])),
                  ]),
                  const Divider(height: 24),
                  _InfoRow(icon: Iconsax.calendar, label: locale.get('selectDate'), value: '${booking.selectedDate?.day}/${booking.selectedDate?.month}/${booking.selectedDate?.year}'),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Iconsax.clock, label: locale.get('selectTime'), value: booking.selectedTime ?? ''),
                  const SizedBox(height: 8),
                  _InfoRow(icon: booking.consultationType == 'online' ? Iconsax.video : Iconsax.building, label: locale.get('consultationType'), value: booking.consultationType == 'online' ? locale.get('online') : locale.get('clinic')),
                ]),
              ),
            ),
            const SizedBox(height: 24),
            // Payment method
            Text(locale.get('paymentMethod'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _PaymentMethod(icon: Iconsax.card, title: locale.get('creditCard'), subtitle: 'Visa, Mastercard', isSelected: _selectedMethod == 'credit', onTap: () => setState(() => _selectedMethod = 'credit')),
            _PaymentMethod(icon: Iconsax.wallet, title: locale.get('wallet'), subtitle: 'Vodafone Cash, Fawry', isSelected: _selectedMethod == 'wallet', onTap: () => setState(() => _selectedMethod = 'wallet')),
            _PaymentMethod(icon: Iconsax.money, title: locale.get('cash'), subtitle: '', isSelected: _selectedMethod == 'cash', onTap: () => setState(() => _selectedMethod = 'cash')),
            const SizedBox(height: 24),
            // Promo code
            Text(locale.get('promoCode'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextField(controller: _promoController, decoration: InputDecoration(hintText: locale.get('promoCode')))),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  final success = booking.applyPromoCode(_promoController.text);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success ? locale.get('codeApplied') : locale.get('error')), backgroundColor: success ? AppColors.success : AppColors.error));
                },
                child: Text(locale.get('applyCode')),
              ),
            ]),
            const SizedBox(height: 24),
            // Price breakdown
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  _PriceRow(label: locale.get('subtotal'), value: '${fee.toInt()} ${locale.get('egp')}'),
                  if (booking.discount > 0) _PriceRow(label: locale.get('discount'), value: '-${discount.toInt()} ${locale.get('egp')}', isDiscount: true),
                  _PriceRow(label: locale.get('serviceFee'), value: '${serviceFee.toInt()} ${locale.get('egp')}'),
                  const Divider(height: 24),
                  _PriceRow(label: locale.get('total'), value: '${total.toInt()} ${locale.get('egp')}', isTotal: true),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]),
        child: SafeArea(child: AppButton(text: '${locale.get('confirmPayment')} • ${total.toInt()} ${locale.get('egp')}', onPressed: _confirmPayment, isLoading: _isLoading)),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, size: 18, color: AppColors.primary), const SizedBox(width: 8), Text(label, style: Theme.of(context).textTheme.bodySmall), const Spacer(), Text(value, style: const TextStyle(fontWeight: FontWeight.w600))]);
}

class _PaymentMethod extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  const _PaymentMethod({required this.icon, required this.title, required this.subtitle, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: isSelected ? AppColors.primary : Theme.of(context).dividerColor, width: isSelected ? 2 : 1)),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.primary)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w600)), if (subtitle.isNotEmpty) Text(subtitle, style: Theme.of(context).textTheme.bodySmall)])),
          Icon(isSelected ? Iconsax.tick_circle5 : Iconsax.tick_circle, color: isSelected ? AppColors.primary : Theme.of(context).dividerColor),
        ]),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label, value;
  final bool isDiscount, isTotal;
  const _PriceRow({required this.label, required this.value, this.isDiscount = false, this.isTotal = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : null, fontSize: isTotal ? 16 : null)),
      Text(value, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : null, fontSize: isTotal ? 16 : null, color: isDiscount ? AppColors.success : (isTotal ? AppColors.primary : null))),
    ]),
  );
}
