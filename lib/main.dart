import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_ui/shared_ui.dart';
import 'config/locale.dart';
import 'config/bindings.dart';
import 'config/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Global Error Caught: ${details.exception}');
  };

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const HenLehenPatientApp());
}

class HenLehenPatientApp extends StatelessWidget {
  const HenLehenPatientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'هُنَّ لَهُنَّ',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      getPages: AppRoutes.pages,
      initialRoute: AppRoutes.onboarding,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        final themeCtrl = Get.find<ThemeController>();
        final localeCtrl = Get.find<LocaleController>();
        return Obx(() {
          // Access reactive values to trigger rebuild
          final _ = themeCtrl.themeMode.value;
          final __ = localeCtrl.isArabic.value;
          return Directionality(
            textDirection: localeCtrl.textDirection,
            child: Theme(
              data: themeCtrl.isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
              child: child!,
            ),
          );
        });
      },
    );
  }
}
