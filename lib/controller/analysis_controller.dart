import 'package:capstone_baseball/model/game_record.dart';
import 'package:capstone_baseball/service/record_service.dart';
import 'package:get/get.dart';

/// 경기 결과 타입
enum GameResult { win, lose, draw, cancel }

class AnalysisController extends GetxController {
  final RecordService recordService;

  AnalysisController(this.recordService);

  /// 전체 기록 (RecordService에서 바로 가져옴)
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
}
