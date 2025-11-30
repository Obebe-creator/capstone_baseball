import 'package:capstone_baseball/controller/home_controller.dart';
import 'package:capstone_baseball/service/record_service.dart';
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
    final recordService = Get.find<RecordService>();

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
          // MARK: - 선택 날짜 기록 요약
          _recordSummary(recordService),
        ],
      ),
    );
  }

  Widget _recordSummary(RecordService recordService) {
    return Obx(() {
      final DateTime selectedDate = controller.selectedDate.value;
      final records = recordService.getRecordsByDate(selectedDate);
      return Container(
        width: 312.w,
        height: 190.h,
        padding: EdgeInsets.all(16.w),
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
        child: records.isEmpty
            ? Center(
                child: Text(
                  '선택된 날짜의 기록이 없습니다.',
                  style: FontStyles.KBO_medium_13.copyWith(
                    color: AppColors.grey_04,
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 날짜 텍스트 (예: 2025년 8월 26일)
                  Text(
                    '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일 경기',
                    style: FontStyles.KBO_medium_13.copyWith(
                      color: AppColors.grey_title,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // 첫 번째 기록만 간단 요약 (추후 리스트로 확장 가능)
                  Builder(
                    builder: (_) {
                      final record = records.first;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 응원팀
                          Expanded(
                            child: Text(
                              record.myTeam.shortName,
                              style: FontStyles.KBO_bold_13.copyWith(
                                color: AppColors.grey_title,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          SizedBox(width: 8.w),

                          // 스코어 "16 : 2"
                          Text(
                            '${record.myScore} : ${record.opponentScore}',
                            style: FontStyles.KBO_bold_13.copyWith(
                              color: AppColors.mainColor,
                            ),
                          ),

                          SizedBox(width: 8.w),

                          // 상대팀 (오른쪽 정렬)
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                record.opponentTeam.shortName,
                                style: FontStyles.KBO_bold_13.copyWith(
                                  color: AppColors.grey_title,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 8.h),

                  // 취소 여부 / 간단 태그 (옵션)
                  // 예: "취소 경기" or "정상 진행"
                  Text(
                    recordStatusText(records.first),
                    style: FontStyles.KBO_medium_13.copyWith(
                      color: AppColors.grey_05,
                    ),
                  ),
                ],
              ),
      );
    });
  }

  // 간단 상태 텍스트 (취소 여부)
  String recordStatusText(record) {
    if (record.isCancelled) {
      return '취소된 경기입니다.';
    }
    return '정상 진행된 경기입니다.';
  }
}
