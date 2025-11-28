class GameRecord {
  final DateTime date; // 직관 날짜
  final String stadium; // 경기장
  final String myTeam; // 응원팀
  final String opponentTeam; // 상대팀
  final int myScore; // 응원팀 점수
  final int opponentScore; // 상대팀 점수
  final bool isCancelled; // 취소 여부 (우천취소 등)
  final String diary; // 오늘의 경기 일기

  GameRecord({
    required this.date,
    required this.stadium,
    required this.myTeam,
    required this.opponentTeam,
    required this.myScore,
    required this.opponentScore,
    required this.isCancelled,
    required this.diary,
  });
}
