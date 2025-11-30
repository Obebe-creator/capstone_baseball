import 'dart:convert';
import 'package:capstone_baseball/model/game_record.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class RecordService extends GetxService {
  static const String _storageKey = 'game_records_v1';

  /// 전체 기록 리스트 (메모리 + 화면 바인딩)
  final RxList<GameRecord> records = <GameRecord>[].obs;

  SharedPreferences? _prefs;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  /// SharedPreferences 인스턴스 가져오기 (lazy)
  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// 로컬에서 기록 불러오기
  Future<void> _loadFromStorage() async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null || jsonString.isEmpty) return;

    try {
      final List<dynamic> list = jsonDecode(jsonString) as List<dynamic>;
      final loaded = list
          .map((e) => GameRecord.fromJson(e as Map<String, dynamic>))
          .toList();
      records.assignAll(loaded);
      debugPrint(
        'RecordService: loaded ${records.length} records from storage',
      );
    } catch (e, st) {
      debugPrint('RecordService: load error $e\n$st');
    }
  }

  /// 현재 records 리스트 전체를 로컬에 저장
  Future<void> _saveToStorage() async {
    final prefs = await _getPrefs();
    final list = records.map((r) => r.toJson()).toList();
    final jsonString = jsonEncode(list);
    await prefs.setString(_storageKey, jsonString);
    debugPrint('RecordService: saved ${records.length} records to storage');
  }

  /// 기록 추가 + 로컬 저장
  Future<void> addRecord(GameRecord record) async {
    records.add(record);
    await _saveToStorage();
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

  /// 전부 삭제 (테스트용)
  Future<void> clearAll() async {
    records.clear();
    final prefs = await _getPrefs();
    await prefs.remove(_storageKey);
  }
}
