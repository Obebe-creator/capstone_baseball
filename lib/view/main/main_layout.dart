import 'package:capstone_baseball/controller/bottom_nav_controller.dart';
import 'package:capstone_baseball/theme/app_colors.dart';
import 'package:capstone_baseball/theme/font_styles.dart';
import 'package:capstone_baseball/theme/image_paths.dart';
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

  // 탭
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
    final currentIndex = controller.index;

    return Container(
      height: 64.h, // Visily 기준 height: 64
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
      child: Row(
        children: [
          _buildNavItem(
            index: 0,
            currentIndex: currentIndex,
            label: '캘린더',
            iconPath: ImagePaths.navCalendar,
          ),
          _buildNavItem(
            index: 1,
            currentIndex: currentIndex,
            label: '기록',
            iconPath: ImagePaths.navRecord,
          ),
          _buildNavItem(
            index: 2,
            currentIndex: currentIndex,
            label: '통계',
            iconPath: ImagePaths.navStats,
          ),
          _buildNavItem(
            index: 3,
            currentIndex: currentIndex,
            label: '설정',
            iconPath: ImagePaths.navSetting,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required int currentIndex,
    required String label,
    required String iconPath,
  }) {
    final bool isSelected = index == currentIndex;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => controller.changeIndex(index),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 24.w,
                height: 24.h,
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                  color: isSelected ? AppColors.mainColor : AppColors.grey_04,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: FontStyles.KBO_medium_8.copyWith(
                  color: isSelected ? AppColors.mainColor : AppColors.grey_04,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
