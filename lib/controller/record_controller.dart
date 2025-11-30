import 'package:capstone_baseball/data/baseball_data.dart';
import 'package:capstone_baseball/model/stadium.dart';
import 'package:capstone_baseball/model/team.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordController extends GetxController {
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
    debugPrint('---- Record Saved ----');
    debugPrint('날짜: $selectedDate');
    debugPrint('경기장: ${selectedStadium.value.name}');
    debugPrint('응원팀: ${myTeam.value.shortName}');
    debugPrint('상대팀: ${opponentTeam.value.shortName}');
    debugPrint('스코어: ${myScore.value} : ${opponentScore.value}');
    debugPrint('취소 여부: ${isCancelled.value}');
    debugPrint('일기: ${diaryController.text}');
  }

  @override
  void onClose() {
    diaryController.dispose();
    super.onClose();
  }
}
