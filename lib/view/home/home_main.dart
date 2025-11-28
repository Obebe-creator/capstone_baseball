import 'package:capstone_baseball/controller/home_controller.dart';
import 'package:capstone_baseball/theme/app_colors.dart';
import 'package:capstone_baseball/theme/font_styles.dart';
import 'package:capstone_baseball/view/home/widget/home_calendar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeMain extends GetView<HomeController> {
  const HomeMain({super.key});

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          // top widget
          Text(
            'HO·UNG',
            style: FontStyles.KBO_bold_17.copyWith(color: AppColors.grey_title),
          ),
          SizedBox(height: 32.h),
          // MARK: - 캘린더
          Container(
            width: 312.w,
            height: 320.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const HomeCalendar(),
          ),
          SizedBox(height: 14.h),
          // MARK: - 내용
          Container(
            width: 312.w,
            height: 190.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
