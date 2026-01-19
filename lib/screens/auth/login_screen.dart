import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../config/providers.dart';
import '../../widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() { _emailController.dispose(); _passwordController.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.login(_emailController.text.trim(), _passwordController.text);
    if (success && mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(28)),
                  child: const Icon(Iconsax.health5, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 24),
                // Title
                Text(locale.get('appName'), style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppColors.primary), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(locale.get('welcomeBack'), style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color), textAlign: TextAlign.center),
                const SizedBox(height: 40),
                // Error message
                if (auth.error != null) Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: AppColors.errorLight, borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [const Icon(Iconsax.warning_2, color: AppColors.error, size: 20), const SizedBox(width: 12), Expanded(child: Text(auth.error!, style: const TextStyle(color: AppColors.error)))]),
                ),
                // Email field
                AppTextField(
                  controller: _emailController,
                  label: locale.get('email'),
                  hint: 'example@email.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Iconsax.sms),
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.isEmpty) return locale.get('emailRequired');
                    if (!v.contains('@')) return locale.get('emailInvalid');
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password field
                AppTextField(
                  controller: _passwordController,
                  label: locale.get('password'),
                  obscureText: true,
                  showPasswordToggle: true,
                  prefixIcon: const Icon(Iconsax.lock),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _login(),
                  validator: (v) {
                    if (v == null || v.isEmpty) return locale.get('passwordRequired');
                    if (v.length < 6) return locale.get('passwordTooShort');
                    return null;
                  },
                ),
                // Forgot password
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(onPressed: () {}, child: Text(locale.get('forgotPassword'))),
                ),
                const SizedBox(height: 8),
                // Login button
                AppButton(text: locale.get('login'), onPressed: _login, isLoading: auth.isLoading),
                const SizedBox(height: 24),
                // Social login
                Row(children: [const Expanded(child: Divider()), Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(locale.get('orLoginWith'), style: Theme.of(context).textTheme.bodySmall)), const Expanded(child: Divider())]),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialButton(icon: 'G', color: AppColors.error, onPressed: () {}),
                    const SizedBox(width: 16),
                    _SocialButton(icon: 'f', color: const Color(0xFF1877F2), onPressed: () {}),
                    const SizedBox(width: 16),
                    _SocialButton(icon: '', color: Colors.black, onPressed: () {}),
                  ],
                ),
                const SizedBox(height: 32),
                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(locale.get('noAccount'), style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(onPressed: () => context.push('/register'), child: Text(locale.get('register'), style: const TextStyle(fontWeight: FontWeight.bold))),
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

class _SocialButton extends StatelessWidget {
  final String icon;
  final Color color;
  final VoidCallback onPressed;
  const _SocialButton({required this.icon, required this.color, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 56, height: 56,
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
        child: Center(child: icon.isEmpty ? Icon(Icons.apple, size: 28, color: color) : Text(icon, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color))),
      ),
    );
  }
}
