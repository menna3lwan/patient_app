import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme.dart';
import '../../config/locale.dart';
import '../../widgets/widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(icon: Iconsax.health, title: 'onboardingTitle1', description: 'onboardingDesc1', color: AppColors.primary),
    OnboardingData(icon: Iconsax.shield_tick, title: 'onboardingTitle2', description: 'onboardingDesc2', color: AppColors.secondary),
    OnboardingData(icon: Iconsax.people, title: 'onboardingTitle3', description: 'onboardingDesc3', color: AppColors.success),
  ];

  @override
  void dispose() { _pageController.dispose(); super.dispose(); }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: Text(locale.get('skip'), style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
              ),
            ),
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon container
                        Container(
                          width: 160, height: 160,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [page.color.withOpacity(0.2), page.color.withOpacity(0.1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Icon(page.icon, size: 80, color: page.color),
                        ),
                        const SizedBox(height: 48),
                        // Title
                        Text(locale.get(page.title), style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        // Description
                        Text(locale.get(page.description), style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color, height: 1.6), textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Indicators and button
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 32 : 8, height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  // Next/Get Started button
                  AppButton(
                    text: _currentPage == _pages.length - 1 ? locale.get('getStarted') : locale.get('next'),
                    onPressed: _nextPage,
                    icon: _currentPage == _pages.length - 1 ? Iconsax.login : Iconsax.arrow_left_2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title, description;
  final Color color;
  OnboardingData({required this.icon, required this.title, required this.description, required this.color});
}
