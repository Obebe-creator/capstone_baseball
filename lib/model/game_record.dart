import 'package:capstone_baseball/data/baseball_data.dart';
import 'package:capstone_baseball/model/game_emotion.dart';
import 'package:capstone_baseball/model/stadium.dart';
import 'package:capstone_baseball/model/team.dart';

class GameRecord {
  final DateTime date;
  final Stadium stadium;
  final Team myTeam;
  final Team opponentTeam;
  final int myScore;
  final int opponentScore;
  final bool isCancelled;
  final String diary;
  final GameEmotion emotion;

  const GameRecord({
    required this.date,
    required this.stadium,
    required this.myTeam,
    required this.opponentTeam,
    required this.myScore,
    required this.opponentScore,
    required this.isCancelled,
    required this.diary,
    required this.emotion,
  });

  // JSON 변환 (나중에 SharedPreferences 쓸 때 사용)
  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'stadiumId': stadium.id,
    'myTeamId': myTeam.id,
    'opponentTeamId': opponentTeam.id,
    'myScore': myScore,
    'opponentScore': opponentScore,
    'isCancelled': isCancelled,
    'diary': diary,
    'emotion': emotion.name,
  };

  factory GameRecord.fromJson(Map<String, dynamic> json) {
    final stadium = BaseballData.stadiums.firstWhere(
      (s) => s.id == json['stadiumId'],
      orElse: () => BaseballData.stadiums.first,
    );
    final myTeam = BaseballData.teams.firstWhere(
      (t) => t.id == json['myTeamId'],
      orElse: () => BaseballData.teams.first,
    );
    final opponentTeam = BaseballData.teams.firstWhere(
      (t) => t.id == json['opponentTeamId'],
      orElse: () => BaseballData.teams.first,
    );

    // ✅ 문자열 → enum
    final emotionStr = json['emotion'] as String?;
    final emotion = GameEmotion.values.firstWhere(
      (e) => e.name == emotionStr,
      orElse: () => GameEmotion.happy, // 없으면 기본값
    );

    return GameRecord(
      date: DateTime.parse(json['date'] as String),
      stadium: stadium,
      myTeam: myTeam,
      opponentTeam: opponentTeam,
      myScore: json['myScore'] as int,
      opponentScore: json['opponentScore'] as int,
      isCancelled: json['isCancelled'] as bool,
      diary: json['diary'] as String,
      emotion: emotion,
    );
  }
}
