// lib/app.dart
import 'package:capstone_baseball/binding/main_bindings.dart';
import 'package:capstone_baseball/theme/app_colors.dart';
import 'package:capstone_baseball/view/home/home_main.dart';
import 'package:flutter/material.dart';
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
          title: 'Capstone Baseball',
          initialBinding: MainBindings(),
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor)
                .copyWith(
                  primary: AppColors.mainColor,
                  onPrimary: AppColors.white,
                ),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.mainColor,
            ),
          ),
          // ✅ 로그인 없이 바로 홈 화면으로 진입
          home: const HomeMain(),
        );
      },
    );
  }
}
