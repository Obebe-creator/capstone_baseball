// lib/view/record/record_edit_page.dart
import 'package:capstone_baseball/controller/analysis_controller.dart';
import 'package:capstone_baseball/model/game_record.dart';
import 'package:capstone_baseball/model/game_emotion.dart';
import 'package:capstone_baseball/theme/app_colors.dart';
import 'package:capstone_baseball/theme/font_styles.dart';
import 'package:capstone_baseball/view/record/record_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RecordEditPage extends StatefulWidget {
  final GameRecord record;

  const RecordEditPage({super.key, required this.record});

  @override
  State<RecordEditPage> createState() => _RecordEditPageState();
}

class _RecordEditPageState extends State<RecordEditPage> {
  late TextEditingController _diaryController;

  GameRecord get record => widget.record;

  @override
  void initState() {
    super.initState();
    // 기존 일기 내용을 초기값으로
    _diaryController = TextEditingController(text: record.diary);
  }

  @override
  void dispose() {
    _diaryController.dispose();
    super.dispose();
  }

  /// ✅ 저장 버튼 (AppBar 오른쪽 "완료")
  Future<void> _save() async {
    final newDiary = _diaryController.text;

    final analysis = Get.find<AnalysisController>();

    // ✅ 실제 저장 + 업데이트된 GameRecord 받아오기
    final updated = await analysis.recordService.updateDiary(record, newDiary);

    // ✅ 이전 상세 페이지를 교체하면서 새로운 상세 페이지로 이동
    Get.off(() => RecordDetailPage(record: updated));
  }

  @override
  Widget build(BuildContext context) {
    final dateText =
        '${record.date.year}년 ${record.date.month}월 ${record.date.day}일';

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
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              '완료',
              style: FontStyles.KBO_bold_13.copyWith(
                color: AppColors.mainColor,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 상세 페이지와 같은 헤더 (날짜 + 감정 표시만, 수정은 일기만)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  dateText,
                  style: FontStyles.KBO_bold_15.copyWith(
                    color: AppColors.grey_title,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  _emotionEmoji(record.emotion),
                  style: const TextStyle(fontSize: 20),
                ),
                SizedBox(width: 4.w),
                Text(
                  _emotionLabel(record.emotion),
                  style: FontStyles.KBO_medium_13.copyWith(
                    color: AppColors.grey_05,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _infoCard(),
            SizedBox(height: 16.h),
            _resultCard(),
            SizedBox(height: 16.h),
            _diaryEditCard(), // ✅ 여기만 수정 가능
          ],
        ),
      ),
    );
  }

  // 직관 정보 카드 (읽기 전용)
  Widget _infoCard() {
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
          _rowItem(
            '날짜',
            '${record.date.year}년 ${record.date.month}월 ${record.date.day}일',
          ),
          SizedBox(height: 8.h),
          _rowItem('경기장', record.stadium.name),
          SizedBox(height: 8.h),
          _rowItem('응원팀', record.myTeam.name),
          SizedBox(height: 4.h),
          Center(
            child: Text(
              'VS',
              style: FontStyles.KBO_medium_13.copyWith(
                color: AppColors.grey_04,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          _rowItem('상대팀', record.opponentTeam.name),
        ],
      ),
    );
  }

  // 경기 결과 카드 (읽기 전용)
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

          _rowItem(
            '오늘 기분',
            '${_emotionEmoji(record.emotion)}  ${_emotionLabel(record.emotion)}',
          ),
          SizedBox(height: 8.h),

          // 스코어
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '스코어',
                style: FontStyles.KBO_medium_13.copyWith(
                  color: AppColors.grey_05,
                ),
              ),
              Text(
                '${record.myTeam.shortName}  '
                '${record.myScore} : ${record.opponentScore}  '
                '${record.opponentTeam.shortName}',
                style: FontStyles.KBO_bold_13.copyWith(
                  color: AppColors.grey_title,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          _rowItem('취소 여부', record.isCancelled ? '취소된 경기' : '정상 진행된 경기'),
        ],
      ),
    );
  }

  // ✅ 오늘의 경기 일기 (수정 가능)
  Widget _diaryEditCard() {
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
            controller: _diaryController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: '경기에서 있었던 일을 자유롭게 적어보세요.',
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
            style: FontStyles.KBO_medium_13.copyWith(
              color: AppColors.grey_title,
            ),
          ),
        ],
      ),
    );
  }

  // 공통 행 UI (레이블 + 값)
  Widget _rowItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: FontStyles.KBO_medium_13.copyWith(color: AppColors.grey_05),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: FontStyles.KBO_medium_13.copyWith(
                color: AppColors.grey_title,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 감정 이모지
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

  // 감정 텍스트
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
