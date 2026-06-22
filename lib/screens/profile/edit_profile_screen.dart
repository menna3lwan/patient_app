import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_ui/shared_ui.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import '../../models/models.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String? _selectedGovernorate;

  @override
  void initState() {
    super.initState();
    final auth = Get.find<AuthController>();
    _nameController = TextEditingController(text: auth.user.value?.name);
    _phoneController = TextEditingController(text: auth.user.value?.phone);
    _selectedGovernorate = auth.user.value?.governorate;
  }

  @override
  void dispose() { _nameController.dispose(); _phoneController.dispose(); super.dispose(); }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final auth = Get.find<AuthController>();
    final locale = Get.find<LocaleController>();
    auth.updateProfile(name: _nameController.text.trim(), phone: _phoneController.text.trim(), governorate: _selectedGovernorate);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(locale.get('profileUpdated')), backgroundColor: AppColors.success));
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocaleController>();
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Iconsax.arrow_right_3), onPressed: () => Get.back()),
        title: Text(locale.get('editProfile')),
        actions: [TextButton(onPressed: _save, child: Text(locale.get('save'), style: const TextStyle(fontWeight: FontWeight.bold)))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(28)),
                    child: Center(child: Text(auth.user.value?.name.isNotEmpty == true ? auth.user.value!.name[0] : '👩', style: const TextStyle(fontSize: 40, color: Colors.white))),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: GestureDetector(
                      onTap: () => _showPhotoOptions(context, locale),
                      child: Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Icon(Iconsax.camera, color: Colors.white, size: 16)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Name
              AppTextField(
                controller: _nameController,
                label: locale.get('fullName'),
                prefixIcon: const Icon(Iconsax.user),
                validator: (v) => v == null || v.isEmpty ? locale.get('nameRequired') : null,
              ),
              const SizedBox(height: 16),
              // Email (read-only)
              AppTextField(
                label: locale.get('email'),
                prefixIcon: const Icon(Iconsax.sms),
                enabled: false,
                controller: TextEditingController(text: auth.user.value?.email),
              ),
              const SizedBox(height: 16),
              // Phone
              AppTextField(
                controller: _phoneController,
                label: locale.get('phone'),
                prefixIcon: const Icon(Iconsax.call),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? locale.get('required') : null,
              ),
              const SizedBox(height: 16),
              // Governorate
              DropdownButtonFormField<String>(
                value: _selectedGovernorate,
                decoration: InputDecoration(labelText: locale.get('governorate'), prefixIcon: const Icon(Iconsax.location)),
                items: MockData.governorates.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (v) => setState(() => _selectedGovernorate = v),
              ),
              const SizedBox(height: 32),
              // Change password
              ListTile(
                onTap: () => _showChangePasswordDialog(context, locale),
                leading: Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)), child: const Icon(Iconsax.lock, color: AppColors.primary)),
                title: Text(locale.get('changePassword')),
                trailing: const Icon(Iconsax.arrow_left_2, size: 18),
              ),
              const SizedBox(height: 8),
              // Delete account
              ListTile(
                onTap: () => _showDeleteAccountDialog(context, locale, auth),
                leading: Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.errorLight, borderRadius: BorderRadius.circular(12)), child: const Icon(Iconsax.trash, color: AppColors.error)),
                title: Text(locale.get('deleteAccount'), style: const TextStyle(color: AppColors.error)),
                trailing: const Icon(Iconsax.arrow_left_2, size: 18, color: AppColors.error),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhotoOptions(BuildContext context, LocaleController locale) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(locale.get('changePhoto'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            ListTile(leading: const Icon(Iconsax.camera, color: AppColors.primary), title: Text(locale.get('camera')), onTap: () => Navigator.pop(ctx)),
            ListTile(leading: const Icon(Iconsax.gallery, color: AppColors.primary), title: Text(locale.get('gallery')), onTap: () => Navigator.pop(ctx)),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, LocaleController locale) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(locale.get('changePassword')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(label: locale.get('currentPassword'), obscureText: true, showPasswordToggle: true),
            const SizedBox(height: 12),
            AppTextField(label: locale.get('newPassword'), obscureText: true, showPasswordToggle: true),
            const SizedBox(height: 12),
            AppTextField(label: locale.get('confirmPassword'), obscureText: true, showPasswordToggle: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(locale.get('cancel'))),
          ElevatedButton(onPressed: () => Navigator.pop(ctx), child: Text(locale.get('save'))),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, LocaleController locale, AuthController auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(locale.get('deleteAccount')),
        content: Text(locale.get('deleteAccountConfirm')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(locale.get('cancel'))),
          ElevatedButton(onPressed: () { auth.logout(); Navigator.pop(ctx); Get.offAllNamed('/login'); }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.error), child: Text(locale.get('delete'))),
        ],
      ),
    );
  }
}
