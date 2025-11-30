import 'package:capstone_baseball/binding/main_bindings.dart';
import 'package:capstone_baseball/theme/app_colors.dart';
import 'package:capstone_baseball/view/main/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 720),
      builder: (_, __) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HOUNG',
          initialBinding: MainBindings(),
          // Localization
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
          locale: const Locale('ko', 'KR'),
          // MARK: 전역 테마
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.bgColor,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor),
          ),

          home: MainLayout(),
        );
      },
    );
  }
}
