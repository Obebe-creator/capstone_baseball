import 'package:capstone_baseball/data/baseball_data.dart';
import 'package:capstone_baseball/model/game_record.dart';
import 'package:capstone_baseball/model/game_emotion.dart';
import 'package:capstone_baseball/model/stadium.dart';
import 'package:capstone_baseball/model/team.dart';
import 'package:capstone_baseball/service/record_service.dart';
import 'package:capstone_baseball/utils/helper/logger.dart';
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

  // 감정
  final Rx<GameEmotion> emotion = GameEmotion.happy.obs;

  // 옵션 리스트
  List<Team> get teamOptions => BaseballData.teams;
  List<Stadium> get stadiumOptions => BaseballData.stadiums;

  void setEmotion(GameEmotion e) {
    emotion.value = e;
  }

  //
  Future<void> saveRecord() async {
    final record = GameRecord(
      date: selectedDate.value,
      stadium: selectedStadium.value,
      myTeam: myTeam.value,
      opponentTeam: opponentTeam.value,
      myScore: myScore.value,
      opponentScore: opponentScore.value,
      isCancelled: isCancelled.value,
      diary: diaryController.text,
      emotion: emotion.value,
    );

    // 저장
    await recordService.addRecord(record);

    logger.i('---- Record Saved ----');
    logger.i('Date: ${record.date}');
    logger.i('Stadium: ${record.stadium.name}');
    logger.i('Cheering Team: ${record.myTeam.shortName}');
    logger.i('Opponent: ${record.opponentTeam.shortName}');
    logger.i('Score: ${record.myScore} : ${record.opponentScore}');
    logger.i('Cancel: ${record.isCancelled}');
    logger.i('Diary: ${record.diary}');
    logger.i('Emotion: ${record.emotion}');
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
    emotion.value = GameEmotion.happy;
  }

  @override
  void onClose() {
    diaryController.dispose();
    super.onClose();
  }
}
