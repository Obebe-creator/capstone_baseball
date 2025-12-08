// lib/view/record/record_edit_page.dart

import 'package:capstone_baseball/controller/record_controller.dart';
import 'package:capstone_baseball/model/game_record.dart';
import 'package:capstone_baseball/model/game_emotion.dart';
import 'package:capstone_baseball/model/stadium.dart';
import 'package:capstone_baseball/model/team.dart';
import 'package:capstone_baseball/theme/app_colors.dart';
import 'package:capstone_baseball/theme/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecordEditPage extends StatefulWidget {
  /// 수정할 기존 기록
  final GameRecord record;

  const RecordEditPage({super.key, required this.record});

  @override
  State<RecordEditPage> createState() => _RecordEditPageState();
}

class _RecordEditPageState extends State<RecordEditPage> {
  /// ➜ 새로 만드는 페이지에서도 동일한 RecordController 재사용
  final RecordController controller = Get.find<RecordController>();

  @override
  void initState() {
    super.initState();

    final r = widget.record;

    // ✅ 기존 기록으로 폼 상태 초기화 (RecordMain에서 쓰는 값들)
    controller.selectedDate.value = r.date;
    controller.selectedStadium.value = r.stadium;
    controller.myTeam.value = r.myTeam;
    controller.opponentTeam.value = r.opponentTeam;
    controller.myScore.value = r.myScore;
    controller.opponentScore.value = r.opponentScore;
    controller.isCancelled.value = r.isCancelled;
    controller.setEmotion(r.emotion);
    controller.diaryController.text = r.diary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.grey_title),
        centerTitle: true,
        title: Text(
          '경기 기록 수정',
          style: FontStyles.KBO_bold_13.copyWith(color: AppColors.grey_title),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(), // ⬅︎ 날짜 + 감정 (상세 페이지 느낌)
            SizedBox(height: 16.h),
            _infoCard(context), // ⬅︎ Dropdown/DatePicker
            SizedBox(height: 16.h),
            _resultCard(), // ⬅︎ 감정 칩 + 점수 + 스위치
            SizedBox(height: 16.h),
            _diaryCard(), // ⬅︎ 일기 TextField
          ],
        ),
      ),

      // 하단 "기록 수정 완료" 버튼
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
          child: SizedBox(
            height: 48.h,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: _save, // TODO: 실제 수정/저장 처리
              child: Text(
                '기록 수정 완료',
                style: FontStyles.KBO_bold_13.copyWith(color: AppColors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────── header: 날짜 + 감정 (상세 페이지 느낌 유지) ─────────────────

  Widget _header() {
    return Obx(() {
      final date = controller.selectedDate.value;
      final emotion = controller.emotion.value;

      final dateText = DateFormat('yyyy년 M월 d일', 'ko_KR').format(date);

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: controller.selectedDate.value,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                locale: const Locale('ko', 'KR'),
              );
              if (picked != null) {
                controller.selectedDate.value = picked;
              }
            },
            child: Row(
              children: [
                Text(
                  dateText,
                  style: FontStyles.KBO_bold_15.copyWith(
                    color: AppColors.grey_title,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(_emotionEmoji(emotion), style: const TextStyle(fontSize: 20)),
          SizedBox(width: 4.w),
          Text(
            _emotionLabel(emotion),
            style: FontStyles.KBO_medium_13.copyWith(color: AppColors.grey_05),
          ),
        ],
      );
    });
  }

  // ───────────────── 직관 정보 카드 (RecordMain 방식으로 선택 가능) ─────────────────

  Widget _infoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '직관 정보',
            style: FontStyles.KBO_medium_13.copyWith(
              color: AppColors.grey_title,
            ),
          ),
          SizedBox(height: 12.h),

          // 날짜
          _fieldLabel('날짜'),
          SizedBox(height: 4.h),
          Obx(
            () => GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedDate.value,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  locale: const Locale('ko', 'KR'),
                );

                if (picked != null) {
                  controller.selectedDate.value = picked;
                }
              },
              child: Container(
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: AppColors.grey_01,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  DateFormat(
                    'yyyy년 M월 d일',
                    'ko_KR',
                  ).format(controller.selectedDate.value),
                  style: FontStyles.KBO_medium_13.copyWith(
                    color: AppColors.grey_title,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // 경기장
          _fieldLabel('경기장'),
          SizedBox(height: 4.h),
          Obx(
            () => _roundedDropdown<Stadium>(
              value: controller.selectedStadium.value,
              items: controller.stadiumOptions,
              labelBuilder: (s) => s.name,
              onChanged: (v) {
                if (v != null) controller.selectedStadium.value = v;
              },
            ),
          ),

          SizedBox(height: 12.h),

          // 응원팀
          _fieldLabel('응원팀'),
          SizedBox(height: 4.h),
          Obx(
            () => _roundedDropdown<Team>(
              value: controller.myTeam.value,
              items: controller.teamOptions,
              labelBuilder: (t) => t.shortName,
              onChanged: (v) {
                if (v != null) controller.myTeam.value = v;
              },
            ),
          ),
          SizedBox(height: 8.h),
          Center(
            child: Text(
              'VS',
              style: FontStyles.KBO_medium_13.copyWith(
                color: AppColors.grey_04,
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // 상대팀 (응원팀 제외)
          _fieldLabel('상대팀'),
          SizedBox(height: 4.h),
          Obx(() {
            final options = controller.teamOptions
                .where((t) => t.id != controller.myTeam.value.id)
                .toList();

            if (!options.any((t) => t.id == controller.opponentTeam.value.id)) {
              controller.opponentTeam.value = options.first;
            }

            return _roundedDropdown<Team>(
              value: controller.opponentTeam.value,
              items: options,
              labelBuilder: (t) => t.shortName,
              onChanged: (v) {
                if (v != null) controller.opponentTeam.value = v;
              },
            );
          }),
        ],
      ),
    );
  }

  // ───────────────── 경기 결과 카드 (감정칩 + 스코어 + 취소 스위치) ─────────────────

  Widget _resultCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '경기 결과',
            style: FontStyles.KBO_medium_13.copyWith(
              color: AppColors.grey_title,
            ),
          ),
          SizedBox(height: 12.h),

          // 오늘 기분 (칩)
          _fieldLabel('오늘 기분'),
          SizedBox(height: 8.h),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _emotionChip(
                  GameEmotion.veryHappy,
                  '최고',
                  Icons.sentiment_very_satisfied,
                ),
                _emotionChip(
                  GameEmotion.happy,
                  '좋음',
                  Icons.sentiment_satisfied,
                ),
                _emotionChip(GameEmotion.soso, '아쉬움', Icons.sentiment_neutral),
                _emotionChip(
                  GameEmotion.sad,
                  '최악',
                  Icons.sentiment_dissatisfied,
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // 스코어
          _fieldLabel('스코어'),
          SizedBox(height: 4.h),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _scoreBox(
                  value: controller.myScore.value,
                  onMinus: () {
                    if (controller.myScore.value > 0) {
                      controller.myScore.value--;
                    }
                  },
                  onPlus: () => controller.myScore.value++,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    ':',
                    style: FontStyles.KBO_medium_13.copyWith(
                      color: AppColors.grey_title,
                    ),
                  ),
                ),
                _scoreBox(
                  value: controller.opponentScore.value,
                  onMinus: () {
                    if (controller.opponentScore.value > 0) {
                      controller.opponentScore.value--;
                    }
                  },
                  onPlus: () => controller.opponentScore.value++,
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // 취소 여부
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '취소',
                style: FontStyles.KBO_medium_13.copyWith(
                  color: AppColors.grey_title,
                ),
              ),
              Obx(
                () => Switch(
                  value: controller.isCancelled.value,
                  onChanged: (v) => controller.isCancelled.value = v,
                  activeThumbColor: AppColors.mainColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ───────────────── 오늘의 경기 일기 ─────────────────

  Widget _diaryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '오늘의 경기 일기',
            style: FontStyles.KBO_medium_13.copyWith(
              color: AppColors.grey_title,
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: controller.diaryController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: '오늘 직관은 어땠는지 자유롭게 기록해보세요.',
              hintStyle: FontStyles.KBO_medium_13.copyWith(
                color: AppColors.grey_04,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.grey_02),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.grey_02),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.mainColor, width: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── 저장 로직 (TODO: 서비스와 연동) ─────────────────

  void _save() async {
    // TODO:
    // 1) controller의 상태로부터 GameRecord를 하나 만들고
    // 2) 기존 widget.record를 업데이트하는 형태로 RecordService에 전달
    // 3) 저장 완료 후 Get.back() 또는 Navigator.pop(context) 호출

    // 예시 형태 (RecordController/RecordService 설계에 맞춰 수정 필요)
    // await controller.updateRecord(widget.record);
    // Get.back();
  }

  // ───────────────── 공통 위젯/헬퍼 (RecordMain에서 그대로 가져옴) ─────────────────

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: FontStyles.KBO_medium_13.copyWith(color: AppColors.grey_05),
    );
  }

  Widget _roundedDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.grey_01,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(
                    labelBuilder(e),
                    style: FontStyles.KBO_medium_13.copyWith(
                      color: AppColors.grey_title,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _scoreBox({
    required int value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Row(
      children: [
        IconButton(
          onPressed: onMinus,
          icon: const Icon(Icons.remove),
          visualDensity: VisualDensity.compact,
        ),
        Container(
          width: 32.w,
          alignment: Alignment.center,
          child: Text(
            '$value',
            style: FontStyles.KBO_medium_13.copyWith(
              color: AppColors.grey_title,
            ),
          ),
        ),
        IconButton(
          onPressed: onPlus,
          icon: const Icon(Icons.add),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Widget _emotionChip(GameEmotion type, String label, IconData icon) {
    final isSelected = controller.emotion.value == type;

    return GestureDetector(
      onTap: () => controller.setEmotion(type),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.mainColor : AppColors.grey_01,
            ),
            child: Icon(
              icon,
              size: 22,
              color: isSelected ? AppColors.white : AppColors.grey_04,
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
    );
  }

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
}
