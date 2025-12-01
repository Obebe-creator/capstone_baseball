import 'package:capstone_baseball/controller/setting_controller.dart';
import 'package:capstone_baseball/theme/app_colors.dart';
import 'package:capstone_baseball/theme/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingMain extends GetView<SettingController> {
  const SettingMain({super.key});

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
            '마이 페이지',
            style: FontStyles.KBO_bold_17.copyWith(color: AppColors.grey_title),
          ),
          SizedBox(height: 182.h),
          // 선택 팀 로고
          Obx(() {
            return GestureDetector(
              onTap: () => _showTeamPicker(Get.context!),
              child: Container(
                width: 110.w,
                height: 110.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grey_01,
                ),
                padding: EdgeInsets.all(12.w),
                child: Image.asset(
                  controller.selectedTeamLogo,
                  fit: BoxFit.contain,
                ),
              ),
            );
          }),

          SizedBox(height: 28.h),
          Container(),
          // 응원 팀 선택
          Obx(() {
            return Text(
              '응원 팀: ${controller.selectedTeamName}',
              style: FontStyles.KBO_medium_13.copyWith(
                color: AppColors.grey_title,
              ),
            );
          }),
        ],
      ),
    );
  }

  // 응원 팀 선택 바텀시트
  void _showTeamPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true, // ← 높이 크게 할 때 필수
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) {
        return SizedBox(
          height: Get.height * 0.65, // ← 화면의 65%까지 올라옴
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '응원 팀 선택',
                    style: FontStyles.KBO_bold_15.copyWith(
                      color: AppColors.grey_title,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                Expanded(
                  child: ListView(
                    children: controller.teamOptions.map((team) {
                      return ListTile(
                        leading: Image.asset(
                          controller.logoForTeam(team),
                          width: 32.w,
                          height: 32.w,
                        ),
                        title: Text(
                          team.name,
                          style: FontStyles.KBO_medium_13.copyWith(
                            color: AppColors.grey_title,
                          ),
                        ),
                        trailing: controller.selectedTeam?.id == team.id
                            ? Icon(Icons.check, color: AppColors.mainColor)
                            : null,
                        onTap: () {
                          controller.changeTeam(team);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
