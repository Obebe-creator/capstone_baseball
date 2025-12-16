import 'package:capstone_baseball/controller/analysis_controller.dart';
import 'package:capstone_baseball/controller/setting_controller.dart';
import 'package:capstone_baseball/model/game_record.dart';
import 'package:capstone_baseball/model/team.dart';
import 'package:capstone_baseball/theme/app_colors.dart';
import 'package:capstone_baseball/theme/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:capstone_baseball/view/analysis/widgets/analysis_share_card.dart';

class AnalysisDetailPage extends GetView<AnalysisController> {
  const AnalysisDetailPage({super.key});

  static final GlobalKey _shareKey = GlobalKey();

  Future<Uint8List> _captureShareCardPng() async {
    await Future.delayed(const Duration(milliseconds: 80));

    final boundary =
        _shareKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _openShareCardDialog({
    required String teamName,
    String? teamLogoAsset,
    required int total,
    required int win,
    required int lose,
    required int draw,
    required int cancel,
  }) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '공유 카드 미리보기',
                style: FontStyles.KBO_bold_15.copyWith(
                  color: AppColors.grey_title,
                ),
              ),
              SizedBox(height: 12.h),

              RepaintBoundary(
                key: _shareKey,
                child: AnalysisShareCard(
                  teamName: teamName,
                  teamLogoAsset: teamLogoAsset, // 없으면 null 유지
                  total: total,
                  win: win,
                  lose: lose,
                ),
              ),

              SizedBox(height: 10.h),
              Text(
                '총 ${total + cancel}경기 (취소 $cancel경기 포함) · $win승 $lose패 $draw무',
                style: FontStyles.KBO_medium_11.copyWith(
                  color: AppColors.grey_04,
                ),
              ),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        '닫기',
                        style: FontStyles.KBO_bold_13.copyWith(
                          color: AppColors.grey_title,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          final bytes = await _captureShareCardPng();
                          Get.snackbar(
                            '완료',
                            '이미지 생성 성공 (${bytes.lengthInBytes} bytes)',
                          );
                        } catch (e) {
                          Get.snackbar('실패', '이미지 생성 실패: $e');
                        }
                      },
                      child: Text(
                        '이미지 생성',
                        style: FontStyles.KBO_bold_13.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '승률 상세',
          style: FontStyles.KBO_bold_15.copyWith(color: AppColors.grey_title),
        ),
        iconTheme: IconThemeData(color: AppColors.grey_title),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _overallWinRateSection(),
          SizedBox(height: 24.h),
          _opponentSection(),
          SizedBox(height: 24.h), // ← 간격
          _recordListSection(), // ← 새 섹션
        ],
      ),
    );
  }

  // MARK: - 전체 직관 승률 섹션
  Widget _overallWinRateSection() {
    final settingController = Get.find<SettingController>();

    return Obx(() {
      final winRate = controller.winRate; // 0 ~ 100
      final played = controller.playedCount;
      final win = controller.winCount;
      final lose = controller.loseCount;
      final draw = controller.drawCount;
      final cancel = controller.cancelCount;

      final favorite = settingController.selectedTeam; // 응원팀
      final teamName = favorite?.shortName ?? '응원팀';

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '나의 전체 직관 승률',
              style: FontStyles.KBO_medium_13.copyWith(
                color: AppColors.grey_title,
              ),
            ),
            SizedBox(height: 12.h),

            // 승률 + 전적
            // ✅ 승률 + 전적 + (오른쪽) 카드로 보기 버튼
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            played == 0
                                ? '--%'
                                : '${winRate.toStringAsFixed(0)}%',
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
                        '총 ${played + cancel}경기 (취소 $cancel경기 포함)',
                        style: FontStyles.KBO_medium_11.copyWith(
                          color: AppColors.grey_04,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 12.w),

                SizedBox(
                  width: 62.w,
                  height: 28.h,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.mainColor, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: favorite == null
                        ? null
                        : () {
                            _openShareCardDialog(
                              teamName: teamName,
                              teamLogoAsset: null, // 로고 asset 있으면 넣기
                              total: played,
                              win: win,
                              lose: lose,
                              draw: draw,
                              cancel: cancel,
                            );
                          },
                    child: Text(
                      '카드로 보기',
                      style: FontStyles.KBO_bold_10.copyWith(
                        color: favorite == null
                            ? AppColors.grey_04
                            : AppColors.mainColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // MARK: - 상대 구단별 전적 섹션
  Widget _opponentSection() {
    final settingController = Get.find<SettingController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '상대 구단별 전적',
          style: FontStyles.KBO_medium_13.copyWith(color: AppColors.grey_title),
        ),
        SizedBox(height: 4.h),
        Text(
          '설정 탭에서 선택한 응원팀 기준으로 보여줘요.',
          style: FontStyles.KBO_medium_11.copyWith(color: AppColors.grey_04),
        ),
        SizedBox(height: 12.h),
        Obx(() {
          final favorite = settingController.selectedTeam;

          if (favorite == null) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '응원팀이 설정되어 있지 않습니다.\n마이 페이지에서 응원 팀을 먼저 선택해 주세요.',
                style: FontStyles.KBO_medium_13.copyWith(
                  color: AppColors.grey_04,
                ),
              ),
            );
          }

          final stats = _buildOpponentStats(controller.records, favorite);

          if (stats.isEmpty) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '아직 ${favorite.shortName}를 응원한 경기 기록이 없습니다.',
                style: FontStyles.KBO_medium_13.copyWith(
                  color: AppColors.grey_04,
                ),
              ),
            );
          }

          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h),
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
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stats.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, thickness: 0.5, color: AppColors.grey_01),
              itemBuilder: (_, index) {
                final s = stats[index];
                return _opponentRow(s);
              },
            ),
          );
        }),
      ],
    );
  }

  // MARK: - 상대 구단 한 줄 UI
  Widget _opponentRow(_OpponentStats stats) {
    final winRateText = stats.played == 0
        ? '--%'
        : '${stats.winRate.toStringAsFixed(0)}%';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          // 구단 이름
          Expanded(
            flex: 2,
            child: Text(
              stats.team.shortName,
              style: FontStyles.KBO_medium_13.copyWith(
                color: AppColors.grey_title,
              ),
            ),
          ),

          // 승률
          Expanded(
            flex: 2,
            child: Text(
              '승률 $winRateText',
              style: FontStyles.KBO_medium_13.copyWith(
                color: AppColors.mainColor,
              ),
            ),
          ),

          // 전적
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${stats.win}승 ${stats.lose}패 ${stats.draw}무  (${stats.played}경기, 취소 ${stats.cancel}경기)',
                style: FontStyles.KBO_medium_11.copyWith(
                  color: AppColors.grey_05,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - 응원팀 기준 상대 구단별 통계 계산
  List<_OpponentStats> _buildOpponentStats(
    List<GameRecord> records,
    Team favorite,
  ) {
    // key: opponentTeamId
    final Map<String, _OpponentStats> map = {};

    for (final record in records) {
      // 내가 응원한 팀이 favorite 인 경기만
      if (record.myTeam.id != favorite.id) continue;

      final opponent = record.opponentTeam;
      final key = opponent.id;

      map.putIfAbsent(key, () => _OpponentStats(team: opponent));

      final entry = map[key]!;

      final result = controller.getResult(record);

      switch (result) {
        case GameResult.win:
          entry.win++;
          entry.played++;
          break;
        case GameResult.lose:
          entry.lose++;
          entry.played++;
          break;
        case GameResult.draw:
          entry.draw++;
          entry.played++;
          break;
        case GameResult.cancel:
          entry.cancel++;
          // played는 올리지 않음
          break;
      }
    }

    final list = map.values.toList();

    // 팀 이름 기준으로 정렬 (보기 좋게)
    list.sort((a, b) => a.team.shortName.compareTo(b.team.shortName));

    return list;
  }

  // MARK: - 직관 기록 목록 섹션
  Widget _recordListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '직관 기록 목록',
          style: FontStyles.KBO_medium_13.copyWith(color: AppColors.grey_title),
        ),
        SizedBox(height: 4.h),
        Text(
          '승률에 반영되는 개별 직관 기록들을 관리할 수 있어요.',
          style: FontStyles.KBO_medium_11.copyWith(color: AppColors.grey_04),
        ),
        SizedBox(height: 12.h),
        Obx(() {
          final records = controller.records;

          if (records.isEmpty) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '아직 직관 기록이 없습니다.\n기록 탭에서 첫 직관을 기록해 보세요!',
                style: FontStyles.KBO_medium_13.copyWith(
                  color: AppColors.grey_04,
                ),
              ),
            );
          }

          return Container(
            width: double.infinity,
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
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, thickness: 0.5, color: AppColors.grey_01),
              itemBuilder: (_, index) {
                final record = records[index];
                return _recordRow(record);
              },
            ),
          );
        }),
      ],
    );
  }

  // MARK: - 직관 기록 한 줄 UI (수정/삭제 아이콘 포함)
  Widget _recordRow(GameRecord record) {
    // GameRecord에 DateTime date 필드 있다고 가정
    final date = record.date;
    final dateText =
        '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';

    final myTeamName = record.myTeam.shortName;
    final oppTeamName = record.opponentTeam.shortName;
    final resultLabel = controller.getResultLabel(record); // 승/패/무/취소

    final scoreText = record.isCancelled
        ? '경기 취소'
        : '${record.myScore} : ${record.opponentScore} ($resultLabel)';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          // 왼쪽: 날짜 + 매치 정보 + 스코어
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateText,
                  style: FontStyles.KBO_medium_11.copyWith(
                    color: AppColors.grey_04,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '$myTeamName vs $oppTeamName',
                  style: FontStyles.KBO_medium_13.copyWith(
                    color: AppColors.grey_title,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  scoreText,
                  style: FontStyles.KBO_medium_11.copyWith(
                    color: AppColors.mainColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 상대 구단별 전적 모델 (이 페이지 내부에서만 사용)
class _OpponentStats {
  final Team team;
  int played = 0; // 정상 진행 경기 수 (승/패/무)
  int win = 0;
  int lose = 0;
  int draw = 0;
  int cancel = 0;

  _OpponentStats({required this.team});

  double get winRate => played == 0 ? 0 : (win / played * 100);
}
