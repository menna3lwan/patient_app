import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedGovernorate;
  bool _agreeToTerms = false;

  @override
  void dispose() { _nameController.dispose(); _emailController.dispose(); _phoneController.dispose(); _passwordController.dispose(); _confirmPasswordController.dispose(); super.dispose(); }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يجب الموافقة على الشروط والأحكام'))); return; }
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.register(name: _nameController.text.trim(), email: _emailController.text.trim(), phone: _phoneController.text.trim(), password: _passwordController.text, governorate: _selectedGovernorate ?? 'القاهرة');
    if (success && mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Iconsax.arrow_right_3), onPressed: () => context.pop())),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Text(locale.get('register'), style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 8),
                Text(locale.get('appSlogan'), style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color)),
                const SizedBox(height: 32),
                // Error message
                if (auth.error != null) Container(
                  padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: AppColors.errorLight, borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [const Icon(Iconsax.warning_2, color: AppColors.error, size: 20), const SizedBox(width: 12), Expanded(child: Text(auth.error!, style: const TextStyle(color: AppColors.error)))]),
                ),
                // Name field
                AppTextField(
                  controller: _nameController, label: locale.get('fullName'), prefixIcon: const Icon(Iconsax.user),
                  textInputAction: TextInputAction.next,
                  validator: (v) { if (v == null || v.isEmpty) return locale.get('nameRequired'); if (v.length < 3) return locale.get('nameTooShort'); return null; },
                ),
                const SizedBox(height: 16),
                // Email field
                AppTextField(
                  controller: _emailController, label: locale.get('email'), hint: 'example@email.com',
                  keyboardType: TextInputType.emailAddress, prefixIcon: const Icon(Iconsax.sms),
                  textInputAction: TextInputAction.next,
                  validator: (v) { if (v == null || v.isEmpty) return locale.get('emailRequired'); if (!v.contains('@')) return locale.get('emailInvalid'); return null; },
                ),
                const SizedBox(height: 16),
                // Phone field
                AppTextField(
                  controller: _phoneController, label: locale.get('phone'), hint: '01xxxxxxxxx',
                  keyboardType: TextInputType.phone, prefixIcon: const Icon(Iconsax.call),
                  textInputAction: TextInputAction.next,
                  validator: (v) { if (v == null || v.isEmpty) return locale.get('required'); return null; },
                ),
                const SizedBox(height: 16),
                // Governorate dropdown
                DropdownButtonFormField<String>(
                  value: _selectedGovernorate,
                  decoration: InputDecoration(labelText: locale.get('governorate'), prefixIcon: const Icon(Iconsax.location)),
                  items: MockData.governorates.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (v) => setState(() => _selectedGovernorate = v),
                  validator: (v) => v == null ? locale.get('required') : null,
                ),
                const SizedBox(height: 16),
                // Password field
                AppTextField(
                  controller: _passwordController, label: locale.get('password'), obscureText: true, showPasswordToggle: true,
                  prefixIcon: const Icon(Iconsax.lock), textInputAction: TextInputAction.next,
                  validator: (v) { if (v == null || v.isEmpty) return locale.get('passwordRequired'); if (v.length < 6) return locale.get('passwordTooShort'); return null; },
                ),
                const SizedBox(height: 16),
                // Confirm password field
                AppTextField(
                  controller: _confirmPasswordController, label: locale.get('confirmPassword'), obscureText: true, showPasswordToggle: true,
                  prefixIcon: const Icon(Iconsax.lock_1), textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _register(),
                  validator: (v) { if (v != _passwordController.text) return locale.get('passwordMismatch'); return null; },
                ),
                const SizedBox(height: 16),
                // Terms checkbox
                Row(
                  children: [
                    Checkbox(value: _agreeToTerms, onChanged: (v) => setState(() => _agreeToTerms = v ?? false), activeColor: AppColors.primary),
                    Expanded(child: Wrap(children: [Text(locale.get('agreeTerms') + ' ', style: Theme.of(context).textTheme.bodySmall), GestureDetector(onTap: () {}, child: Text(locale.get('termsAndConditions'), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)))])),
                  ],
                ),
                const SizedBox(height: 24),
                // Register button
                AppButton(text: locale.get('register'), onPressed: _register, isLoading: auth.isLoading),
                const SizedBox(height: 24),
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(locale.get('hasAccount'), style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(onPressed: () => context.pop(), child: Text(locale.get('login'), style: const TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
