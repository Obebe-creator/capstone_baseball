import 'package:capstone_baseball/model/game_record.dart';
import 'package:capstone_baseball/model/game_emotion.dart';
import 'package:capstone_baseball/theme/app_colors.dart';
import 'package:capstone_baseball/theme/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordDetailPage extends StatelessWidget {
  final GameRecord record;

  const RecordDetailPage({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.grey_title),
        title: Text(
          '경기 기록 상세',
          style: FontStyles.KBO_bold_13.copyWith(color: AppColors.grey_title),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            SizedBox(height: 16.h),
            _infoCard(),
            SizedBox(height: 16.h),
            _resultCard(),
            SizedBox(height: 16.h),
            _diaryCard(),
          ],
        ),
      ),
    );
  }

  // 상단 날짜 + 감정
  Widget _header() {
    final dateText =
        '${record.date.year}년 ${record.date.month}월 ${record.date.day}일';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          dateText,
          style: FontStyles.KBO_bold_15.copyWith(color: AppColors.grey_title),
        ),
        SizedBox(width: 8.w),
        Text(
          _emotionEmoji(record.emotion),
          style: const TextStyle(fontSize: 20),
        ),
        SizedBox(width: 4.w),
        Text(
          _emotionLabel(record.emotion),
          style: FontStyles.KBO_medium_13.copyWith(color: AppColors.grey_05),
        ),
      ],
    );
  }

  // 직관 정보 카드 (날짜, 경기장, 팀)
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

  // 경기 결과 카드 (감정, 스코어, 취소 여부)
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

          // 감정
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

          // 취소 여부
          _rowItem('취소 여부', record.isCancelled ? '취소된 경기' : '정상 진행된 경기'),
        ],
      ),
    );
  }

  // 일기 카드
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
          Text(
            record.diary.isEmpty ? '작성된 일기가 없습니다.' : record.diary,
            style: FontStyles.KBO_medium_13.copyWith(
              color: AppColors.grey_title,
            ),
          ),
        ],
      ),
    );
  }

  // 공통 행 UI
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
