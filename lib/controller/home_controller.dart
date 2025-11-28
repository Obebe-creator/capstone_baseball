import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  /// 선택된 날짜 (기본: 오늘)
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  /// 현재 보고 있는 달 (캘린더 페이지)
  final Rx<DateTime> focusedMonth = DateTime.now().obs;

  /// 예: 나중에 날짜별 기록 맵
  /// key: yyyymmdd 문자열, value: 간단 메모
  final RxMap<String, String> recordsByDate = <String, String>{}.obs;

  /// 날짜 포맷 키
  String _dateKey(DateTime date) => DateFormat('yyyyMMdd').format(date);

  /// 선택한 날짜 변경
  void onDaySelected(DateTime day, DateTime focusedDay) {
    selectedDate.value = day;
    focusedMonth.value = focusedDay;
  }

  /// 나중에 기록 저장용 (History 탭에서 추가해도 사용 가능)
  void saveRecord(DateTime date, String text) {
    recordsByDate[_dateKey(date)] = text;
  }

  /// 선택한 날짜의 기록 가져오기
  String? get recordOfSelectedDate {
    return recordsByDate[_dateKey(selectedDate.value)];
  }
}
