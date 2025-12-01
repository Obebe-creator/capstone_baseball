import 'package:capstone_baseball/controller/home_controller.dart';
import 'package:capstone_baseball/model/game_emotion.dart';
import 'package:capstone_baseball/service/record_service.dart';
import 'package:capstone_baseball/theme/app_colors.dart';
import 'package:capstone_baseball/theme/font_styles.dart';
import 'package:capstone_baseball/view/home/widget/home_calendar.dart';
import 'package:capstone_baseball/view/record/record_detail.dart';

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
        constraints: BoxConstraints(minHeight: 120.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.r,
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
            : _recordCardContent(selectedDate, records.first),
      );
    });
  }

  /// 실제 카드 내용 (날짜 + 감정 + 일기 요약 + > 아이콘)
  Widget _recordCardContent(DateTime date, record) {
    final dateText = '${date.year}년 ${date.month}월 ${date.day}일';
    final emoji = _emotionEmoji(record.emotion);
    final emotionLabel = _emotionLabel(record.emotion);

    return InkWell(
      onTap: () {
        // MARK: -상세 보기 페이지로 이동
        Get.to(() => RecordDetailPage(record: record));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 줄: 날짜 + 감정 + >
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      dateText,
                      style: FontStyles.KBO_medium_13.copyWith(
                        color: AppColors.grey_title,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(emoji, style: const TextStyle(fontSize: 16)),
                    SizedBox(width: 4.w),
                    Text(
                      emotionLabel,
                      style: FontStyles.KBO_medium_13.copyWith(
                        color: AppColors.grey_05,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 20, color: AppColors.grey_04),
            ],
          ),

          SizedBox(height: 10.h),

          // 일기 내용 요약
          Text(
            record.diary.isEmpty ? '작성된 일기가 없습니다.' : record.diary,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: FontStyles.KBO_medium_13.copyWith(
              color: AppColors.grey_title,
            ),
          ),
        ],
      ),
    );
  }

  /// 감정에 따른 이모지
  String _emotionEmoji(GameEmotion emotion) {
    switch (emotion) {
      case GameEmotion.veryHappy:
        return '😆';
      case GameEmotion.happy:
        return '😊';
      case GameEmotion.soso:
        return '😐';
      case GameEmotion.sad:
        return '😢';
    }
  }

  /// 감정에 따른 텍스트 라벨
  String _emotionLabel(GameEmotion emotion) {
    switch (emotion) {
      case GameEmotion.veryHappy:
        return '최고였던 경기';
      case GameEmotion.happy:
        return '기분 좋은 경기';
      case GameEmotion.soso:
        return '아쉬운 경기';
      case GameEmotion.sad:
        return '최악의 경기';
    }
  }

  // 간단 상태 텍스트 (취소 여부)
  String recordStatusText(record) {
    if (record.isCancelled) {
      return '취소된 경기입니다.';
    }
    return '정상 진행된 경기입니다.';
  }
}
