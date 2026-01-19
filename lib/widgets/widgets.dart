import 'package:flutter/material.dart';
import '../config/theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading, isOutlined, isFullWidth;
  final Color? color;
  final IconData? icon;
  final double height;

  const AppButton({super.key, required this.text, this.onPressed, this.isLoading = false, this.isOutlined = false, this.isFullWidth = true, this.color, this.icon, this.height = 52});

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? AppColors.primary;
    Widget child = isLoading ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: isOutlined ? btnColor : Colors.white)) : Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)], Text(text)]);
    if (isOutlined) return SizedBox(width: isFullWidth ? double.infinity : null, height: height, child: OutlinedButton(onPressed: isLoading ? null : onPressed, style: OutlinedButton.styleFrom(foregroundColor: btnColor, side: BorderSide(color: btnColor, width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: child));
    return SizedBox(width: isFullWidth ? double.infinity : null, height: height, child: ElevatedButton(onPressed: isLoading ? null : onPressed, style: ElevatedButton.styleFrom(backgroundColor: btnColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 2, shadowColor: btnColor.withOpacity(0.3)), child: child));
  }
}

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label, hint;
  final bool obscureText, showPasswordToggle, enabled, readOnly;
  final TextInputType? keyboardType;
  final Widget? prefixIcon, suffixIcon;
  final String? Function(String?)? validator;
  final int maxLines;
  final void Function(String)? onChanged, onSubmitted;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;

  const AppTextField({super.key, this.controller, this.label, this.hint, this.obscureText = false, this.showPasswordToggle = false, this.keyboardType, this.prefixIcon, this.suffixIcon, this.validator, this.maxLines = 1, this.onChanged, this.onSubmitted, this.enabled = true, this.readOnly = false, this.onTap, this.textInputAction});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;
  @override
  void initState() { super.initState(); _obscureText = widget.obscureText; }
  @override
  Widget build(BuildContext context) {
    return TextFormField(controller: widget.controller, obscureText: widget.showPasswordToggle ? _obscureText : widget.obscureText, keyboardType: widget.keyboardType, maxLines: widget.obscureText ? 1 : widget.maxLines, onChanged: widget.onChanged, onFieldSubmitted: widget.onSubmitted, enabled: widget.enabled, readOnly: widget.readOnly, onTap: widget.onTap, textInputAction: widget.textInputAction, decoration: InputDecoration(labelText: widget.label, hintText: widget.hint, prefixIcon: widget.prefixIcon, suffixIcon: widget.showPasswordToggle ? IconButton(icon: Icon(_obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textSecondaryLight), onPressed: () => setState(() => _obscureText = !_obscureText)) : widget.suffixIcon), validator: widget.validator);
  }
}

class DoctorCard extends StatelessWidget {
  final String name, specialty;
  final double rating, fee;
  final int reviewsCount, experience;
  final bool isOnline, isFavorite;
  final VoidCallback? onTap, onFavoritePressed;

  const DoctorCard({super.key, required this.name, required this.specialty, required this.rating, required this.reviewsCount, required this.experience, required this.fee, this.isOnline = true, this.isFavorite = false, this.onTap, this.onFavoritePressed});

  @override
  Widget build(BuildContext context) {
    return Card(margin: const EdgeInsets.only(bottom: 12), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
      Stack(children: [CircleAvatar(radius: 30, backgroundColor: AppColors.primaryLight, child: Text(name.length > 3 ? name[3] : name[0], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary))), if (isOnline) Positioned(bottom: 2, right: 2, child: Container(width: 14, height: 14, decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))))]),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 4), Text(specialty, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 13)), const SizedBox(height: 8), Row(children: [Icon(Icons.star_rounded, size: 18, color: Colors.amber.shade600), const SizedBox(width: 4), Text('$rating', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Text(' ($reviewsCount)', style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color)), const SizedBox(width: 12), Icon(Icons.work_outline_rounded, size: 16, color: Theme.of(context).textTheme.bodySmall?.color), const SizedBox(width: 4), Text('$experience سنة', style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color))])])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [IconButton(icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? AppColors.error : AppColors.textSecondaryLight), onPressed: onFavoritePressed, padding: EdgeInsets.zero, constraints: const BoxConstraints()), const SizedBox(height: 12), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)), child: Text('${fee.toInt()} جنيه', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12)))])
    ]))));
  }
}

class SpecialtyCard extends StatelessWidget {
  final String name, icon;
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  const SpecialtyCard({super.key, required this.name, required this.icon, required this.color, this.isSelected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: 85, padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: isSelected ? color.withOpacity(0.15) : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: isSelected ? color : Colors.transparent, width: 2), boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))] : null), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(14)), child: Center(child: Text(icon, style: const TextStyle(fontSize: 24)))), const SizedBox(height: 8), Text(name, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? color : null), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis)])));
  }
}

class AppointmentCard extends StatelessWidget {
  final String doctorName, specialty, date, time, type, status;
  final VoidCallback? onTap, onCancel, onStart;

  const AppointmentCard({super.key, required this.doctorName, required this.specialty, required this.date, required this.time, required this.type, required this.status, this.onTap, this.onCancel, this.onStart});

  Color get statusColor => {'pending': AppColors.warning, 'confirmed': AppColors.success, 'completed': AppColors.info, 'cancelled': AppColors.error}[status] ?? AppColors.textSecondaryLight;
  String get statusText => {'pending': 'في الانتظار', 'confirmed': 'مؤكد', 'completed': 'مكتمل', 'cancelled': 'ملغي'}[status] ?? status;

  @override
  Widget build(BuildContext context) {
    return Card(margin: const EdgeInsets.only(bottom: 12), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
      Row(children: [CircleAvatar(radius: 24, backgroundColor: AppColors.primaryLight, child: Text(doctorName.length > 3 ? doctorName[3] : doctorName[0], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(doctorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text(specialty, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color))])), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600)))]),
      const Divider(height: 24),
      Row(children: [_InfoItem(icon: Icons.calendar_today_rounded, text: date), const SizedBox(width: 16), _InfoItem(icon: Icons.access_time_rounded, text: time), const SizedBox(width: 16), _InfoItem(icon: type == 'online' ? Icons.videocam_rounded : Icons.location_on_rounded, text: type == 'online' ? 'أونلاين' : 'عيادة', color: type == 'online' ? AppColors.info : AppColors.success)]),
      if (status == 'confirmed' || status == 'pending') ...[const SizedBox(height: 16), Row(children: [if (status == 'pending' || status == 'confirmed') Expanded(child: OutlinedButton(onPressed: onCancel, style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)), child: const Text('إلغاء'))), if (status == 'confirmed') ...[const SizedBox(width: 12), Expanded(child: ElevatedButton.icon(onPressed: onStart, icon: const Icon(Icons.videocam_rounded, size: 18), label: const Text('بدء')))]])]
    ]))));
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  const _InfoItem({required this.icon, required this.text, this.color});
  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).textTheme.bodySmall?.color;
    return Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 16, color: c), const SizedBox(width: 4), Text(text, style: TextStyle(fontSize: 12, color: c))]);
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value, label;
  final Color color;
  const StatCard({super.key, required this.icon, required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)), child: Column(children: [Icon(icon, color: color, size: 28), const SizedBox(height: 8), Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color)), const SizedBox(height: 4), Text(label, style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color), textAlign: TextAlign.center)]));
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle, buttonText;
  final VoidCallback? onButtonPressed;
  const EmptyState({super.key, required this.icon, required this.title, this.subtitle, this.buttonText, this.onButtonPressed});
  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 80, color: Theme.of(context).dividerColor), const SizedBox(height: 24), Text(title, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center), if (subtitle != null) ...[const SizedBox(height: 8), Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color), textAlign: TextAlign.center)], if (buttonText != null && onButtonPressed != null) ...[const SizedBox(height: 24), AppButton(text: buttonText!, onPressed: onButtonPressed, isFullWidth: false)]])));
  }
}

class LoadingIndicator extends StatelessWidget {
  final String? message;
  const LoadingIndicator({super.key, this.message});
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3), if (message != null) ...[const SizedBox(height: 16), Text(message!, style: Theme.of(context).textTheme.bodyMedium)]]));
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionPressed;
  const SectionHeader({super.key, required this.title, this.actionText, this.onActionPressed});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: Theme.of(context).textTheme.titleLarge), if (actionText != null) TextButton(onPressed: onActionPressed, child: Text(actionText!))]));
}
