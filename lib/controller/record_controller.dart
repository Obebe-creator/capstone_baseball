import 'package:capstone_baseball/data/baseball_data.dart';
import 'package:capstone_baseball/model/game_record.dart';
import 'package:capstone_baseball/model/stadium.dart';
import 'package:capstone_baseball/model/team.dart';
import 'package:capstone_baseball/service/record_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordController extends GetxController {
  final RecordService recordService;

  RecordController(this.recordService);

  // 선택된 값
  final selectedDate = DateTime.now().obs;
  final myTeam = BaseballData.teams.first.obs;
  final opponentTeam = BaseballData.teams[1].obs;
  final selectedStadium = BaseballData.stadiums.first.obs;

  // 경기 결과
  final myScore = 0.obs;
  final opponentScore = 0.obs;
  final isCancelled = false.obs;

  // 오늘의 경기 일기
  final TextEditingController diaryController = TextEditingController();

  // 옵션 리스트
  List<Team> get teamOptions => BaseballData.teams;
  List<Stadium> get stadiumOptions => BaseballData.stadiums;

  // 나중에 RecordService 연동하기 전까지 임시 저장/디버그 용도
  void saveRecord() {
    final record = GameRecord(
      date: selectedDate.value,
      stadium: selectedStadium.value,
      myTeam: myTeam.value,
      opponentTeam: opponentTeam.value,
      myScore: myScore.value,
      opponentScore: opponentScore.value,
      isCancelled: isCancelled.value,
      diary: diaryController.text,
    );
    recordService.addRecord(record);
  }

  // 초기화
  void resetForm() {
    selectedDate.value = DateTime.now();
    selectedStadium.value = stadiumOptions.first;
    myTeam.value = teamOptions.first;
    opponentTeam.value = teamOptions.length > 1
        ? teamOptions[1]
        : teamOptions.first;

    myScore.value = 0;
    opponentScore.value = 0;
    isCancelled.value = false;
    diaryController.clear();
  }

  @override
  void onClose() {
    diaryController.dispose();
    super.onClose();
  }
}
