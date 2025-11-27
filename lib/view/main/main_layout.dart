import 'package:capstone_baseball/controller/bottom_nav_controller.dart';
import 'package:capstone_baseball/theme/app_colors.dart';
import 'package:capstone_baseball/theme/font_styles.dart';
import 'package:capstone_baseball/view/home/home_main.dart';
import 'package:capstone_baseball/view/analysis/analysis_main.dart';
import 'package:capstone_baseball/view/record/record_main.dart';
import 'package:capstone_baseball/view/setting/setting_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainLayout extends GetView<BottomNavController> {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.bgColor,
        body: SafeArea(child: _body()),
        bottomNavigationBar: _bottomNav(),
      ),
    );
  }

  /// 4개의 탭 화면
  Widget _body() {
    return IndexedStack(
      index: controller.index,
      children: const [
        HomeMain(), // 0. 홈
        RecordMain(), // 1. 기록
        AnalysisMain(), // 2. 분석
        SettingMain(), // 3. 설정
      ],
    );
  }

  // MARK: 하단 네비게이션 바 설정
  Widget _bottomNav() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: controller.index,
        onTap: controller.changeIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: AppColors.grey,
        // selectedLabelStyle: FontStyles.navi_bold_10,
        // unselectedLabelStyle: FontStyles.navi_bold_10,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            activeIcon: Icon(Icons.event_note),
            label: '기록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.query_stats_outlined),
            activeIcon: Icon(Icons.query_stats),
            label: '분석',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
