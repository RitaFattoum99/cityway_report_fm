import 'package:cityway_report_fm/splash/splash_bindings.dart';
import 'package:cityway_report_fm/splash/splash_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '/auth/signin/signin.dart';
import '/auth/signin/signin_bindings.dart';
import '/core/resource/color_manager.dart';
import '/create_report/report_bindings.dart';
import '/create_report/create_report_screen.dart';
import '/homepage/report_list_bindings.dart';
import '/homepage/homepage_screen.dart';
import '/notification_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: AppColorManager.mainAppColor),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''),
      ],

      locale: const Locale('ar', ''),
      initialRoute: '/splash',

      //Navigate to report screen

      getPages: [
        GetPage(
            name: '/splash', page: () => const Splash(), binding: SplashBindings()),
        GetPage(
            name: '/signin',
            page: () => const SignIn(),
            binding: SigninBindings()),
        GetPage(
          name: '/home',
          page: () => const DynamicTabBarWithReports(),
          binding: ReportListBindings(),
        ),
        GetPage(
            name: '/create',
            page: () => const CreateReport(),
            binding: ReportBindings()),
        GetPage(
          name: '/notification',
          page: () => const NotificationListScreen(),
        ),
      ],
      builder: EasyLoading.init(),
    );
  }
}
