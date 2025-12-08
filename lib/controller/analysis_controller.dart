import 'package:capstone_baseball/model/game_record.dart';
import 'package:capstone_baseball/service/record_service.dart';
import 'package:capstone_baseball/view/record/record_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 경기 결과 타입
enum GameResult { win, lose, draw, cancel }

class AnalysisController extends GetxController {
  final RecordService recordService;

  AnalysisController(this.recordService);

  // 전체 기록 (RecordService에서 바로 가져옴)
  RxList<GameRecord> get records => recordService.records;

  /// 취소 아닌 경기만
  List<GameRecord> get playedRecords =>
      records.where((r) => !r.isCancelled).toList();

  int get totalGames => records.length;

  int get cancelCount => records.where((r) => r.isCancelled).length;

  int get winCount =>
      playedRecords.where((r) => r.myScore > r.opponentScore).length;

  int get loseCount =>
      playedRecords.where((r) => r.myScore < r.opponentScore).length;

  int get drawCount =>
      playedRecords.where((r) => r.myScore == r.opponentScore).length;

  /// 취소 제외 경기 수
  int get playedCount => playedRecords.length;

  /// 직관 승률 (취소 제외)
  double get winRate {
    if (playedCount == 0) return 0;
    return (winCount / playedCount) * 100;
  }

  /// 개별 기록의 결과 타입
  GameResult getResult(GameRecord record) {
    if (record.isCancelled) {
      return GameResult.cancel;
    }
    if (record.myScore > record.opponentScore) {
      return GameResult.win;
    }
    if (record.myScore < record.opponentScore) {
      return GameResult.lose;
    }
    return GameResult.draw;
  }

  /// UI에서 쓸 결과 텍스트
  String getResultLabel(GameRecord record) {
    final result = getResult(record);
    switch (result) {
      case GameResult.win:
        return '승';
      case GameResult.lose:
        return '패';
      case GameResult.draw:
        return '무';
      case GameResult.cancel:
        return '취소';
    }
  }

  /// 기록 삭제
  Future<void> deleteRecord(GameRecord record) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('기록 삭제'),
        content: const Text('이 직관 기록을 삭제할까요?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // ✅ 실제 데이터 삭제/저장은 서비스에게 위임
    await recordService.deleteRecord(record);
  }

  void editRecord(GameRecord record) {
    Get.off(() => RecordEditPage(record: record));
  }
}
