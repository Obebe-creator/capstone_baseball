import 'package:capstone_baseball/controller/analysis_controller.dart';
import 'package:capstone_baseball/model/game_record.dart';
import 'package:capstone_baseball/theme/app_colors.dart';
import 'package:capstone_baseball/theme/font_styles.dart';
import 'package:capstone_baseball/view/analysis/analysis_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AnalysisMain extends GetView<AnalysisController> {
  const AnalysisMain({super.key});

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  // MARK: - 바디
  Widget _body() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(),
          SizedBox(height: 16.h),
          _winRateSection(),
          SizedBox(height: 16.h),
          _sectionDivider(),
          SizedBox(height: 16.h),
          _recordListSection(),
        ],
      ),
    );
  }

  // MARK: - 타이틀
  Widget _title() {
    return Center(
      child: Text(
        '통계',
        style: FontStyles.KBO_bold_17.copyWith(color: AppColors.grey_title),
      ),
    );
  }

  // MARK: - 나의 직관 승률 섹션 (상단 텍스트)
  Widget _winRateSection() {
    return Obx(() {
      final winRate = controller.winRate; // 0 ~ 100
      final played = controller.playedCount;
      final win = controller.winCount;
      final lose = controller.loseCount;
      final draw = controller.drawCount;
      final cancel = controller.cancelCount;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목 + 상세보기
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '나의 직관 승률',
                style: FontStyles.KBO_medium_13.copyWith(
                  color: AppColors.grey_title,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: 상세 통계 페이지로 이동
                  Get.to(() => const AnalysisDetailPage());
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  children: [
                    Text(
                      '상세보기',
                      style: FontStyles.KBO_medium_12.copyWith(
                        color: AppColors.grey_04,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // 승률 + 전적
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                played == 0 ? '--%' : '${winRate.toStringAsFixed(0)}%',
                style: FontStyles.KBO_bold_17.copyWith(
                  color: AppColors.mainColor,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '$win승 $lose패 $draw무',
                style: FontStyles.KBO_medium_13.copyWith(
                  color: AppColors.grey_title,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            '취소 $cancel경기 포함',
            style: FontStyles.KBO_medium_11.copyWith(color: AppColors.grey_04),
          ),
        ],
      );
    });
  }

  // MARK: - 섹션 구분선
  Widget _sectionDivider() {
    return Divider(height: 1, thickness: 1, color: AppColors.grey_01);
  }

  // MARK: - 내 직관 기록 섹션
  Widget _recordListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내 직관 기록',
          style: FontStyles.KBO_medium_13.copyWith(color: AppColors.grey_title),
        ),
        SizedBox(height: 12.h),
        _recordList(),
      ],
    );
  }

  // MARK: - 전체 기록 리스트
  Widget _recordList() {
    return Obx(() {
      final records = controller.records;

      if (records.isEmpty) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 40.h),
          alignment: Alignment.center,
          child: Text(
            '아직 기록이 없습니다.\n기록 탭에서 첫 경기를 남겨보세요.',
            textAlign: TextAlign.center,
            style: FontStyles.KBO_medium_13.copyWith(color: AppColors.grey_04),
          ),
        );
      }

      // 최신 경기 먼저
      final sorted = records.reversed.toList();

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sorted.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, index) {
          final record = sorted[index];
          return _recordCard(record);
        },
      );
    });
  }

  // MARK: - 개별 경기 카드
  Widget _recordCard(GameRecord record) {
    final result = controller.getResult(record);

    String resultLabel;
    Color resultColor;

    switch (result) {
      case GameResult.win:
        resultLabel = '승리';
        resultColor = AppColors.blue_01;
        break;
      case GameResult.lose:
        resultLabel = '패배';
        resultColor = AppColors.red_01;
        break;
      case GameResult.draw:
        resultLabel = '무승부';
        resultColor = AppColors.grey_05;
        break;
      case GameResult.cancel:
        resultLabel = '취소';
        resultColor = AppColors.grey_04;
        break;
    }

    final dateText = DateFormat('yyyy년 M월 d일', 'ko_KR').format(record.date);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 날짜
          Text(
            dateText,
            style: FontStyles.KBO_medium_11.copyWith(color: AppColors.grey_04),
          ),
          SizedBox(height: 4.h),

          // 경기장
          Text(
            record.stadium.name,
            style: FontStyles.KBO_medium_13.copyWith(
              color: AppColors.grey_title,
            ),
          ),
          SizedBox(height: 8.h),

          // VS + 스코어 + 결과 배지
          Row(
            children: [
              Expanded(
                child: Text(
                  '${record.myTeam.shortName}  VS  ${record.opponentTeam.shortName}',
                  style: FontStyles.KBO_medium_13.copyWith(
                    color: AppColors.grey_title,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '${record.myScore} - ${record.opponentScore}',
                style: FontStyles.KBO_bold_13.copyWith(
                  color: AppColors.mainColor,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: resultColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  resultLabel,
                  style: FontStyles.KBO_medium_11.copyWith(color: resultColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
