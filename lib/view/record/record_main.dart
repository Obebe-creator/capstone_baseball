import 'package:capstone_baseball/controller/record_controller.dart';
import 'package:capstone_baseball/model/stadium.dart';
import 'package:capstone_baseball/model/team.dart';
import 'package:capstone_baseball/theme/app_colors.dart';
import 'package:capstone_baseball/theme/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecordMain extends GetView<RecordController> {
  const RecordMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(),
            SizedBox(height: 16.h),
            _infoCard(context),
            SizedBox(height: 16.h),
            _resultCard(),
            SizedBox(height: 16.h),
            _diaryCard(),
            SizedBox(height: 24.h),
            _saveButton(context),
          ],
        ),
      ),
    );
  }

  // 상단 타이틀
  Widget _title() {
    return Text(
      '오늘의 경기 기록',
      style: FontStyles.KBO_bold_13.copyWith(color: AppColors.grey_title),
    );
  }

  // MARK: - 직관 정보 카드
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

  // ---------- 경기 결과 카드 ----------
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

  // ---------- 오늘의 경기 일기 ----------
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

  // MARK: - 저장 버튼
  Widget _saveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: () async {
          await controller.saveRecord(); // 저장은 컨트롤러가
          controller.resetForm(); // 초기화도 컨트롤러가

          // UI는 여기(View)가 담당
          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('저장 완료', style: FontStyles.KBO_medium_13),
              content: Text('기록이 저장되었습니다.', style: FontStyles.KBO_medium_13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('확인', style: FontStyles.KBO_medium_13),
                ),
              ],
            ),
          );
        },
        child: Text(
          '기록 저장',
          style: FontStyles.KBO_bold_13.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  // MARK: - 공통 위젯
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
}
