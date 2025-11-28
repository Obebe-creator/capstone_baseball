import 'package:capstone_baseball/model/game_record.dart';
import 'package:get/get.dart';

class RecordService extends GetxService {
  /// 전체 기록 리스트
  final RxList<GameRecord> records = <GameRecord>[].obs;

  /// 기록 추가
  void addRecord(GameRecord record) {
    records.add(record);
  }

  /// 특정 날짜의 기록들 가져오기 (달력/홈에서 사용 예정)
  List<GameRecord> getRecordsByDate(DateTime date) {
    return records
        .where(
          (r) =>
              r.date.year == date.year &&
              r.date.month == date.month &&
              r.date.day == date.day,
        )
        .toList();
  }
}
