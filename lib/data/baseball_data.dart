import 'package:capstone_baseball/model/team.dart';
import 'package:capstone_baseball/model/stadium.dart';

class BaseballData {
  // KBO 팀 목록
  static const List<Team> teams = [
    Team(id: 'DOOSAN', name: '두산 베어스', shortName: '두산'),
    Team(id: 'LG', name: 'LG 트윈스', shortName: 'LG'),
    Team(id: 'KIA', name: 'KIA 타이거즈', shortName: 'KIA'),
    Team(id: 'KT', name: 'KT 위즈', shortName: 'KT'),
    Team(id: 'SAMSUNG', name: '삼성 라이온즈', shortName: '삼성'),
    Team(id: 'LOTTE', name: '롯데 자이언츠', shortName: '롯데'),
    Team(id: 'SSG', name: 'SSG 랜더스', shortName: 'SSG'),
    Team(id: 'HANWHA', name: '한화 이글스', shortName: '한화'),
    Team(id: 'NC', name: 'NC 다이노스', shortName: 'NC'),
    Team(id: 'KIWOOM', name: '키움 히어로즈', shortName: '키움'),
  ];

  // 경기장 목록
  static const List<Stadium> stadiums = [
    Stadium(id: 'JAMSIL', name: '잠실종합운동장야구장', city: '서울'),
    Stadium(id: 'GOCHUK', name: '고척스카이돔', city: '서울'),
    Stadium(id: 'SUWON', name: '수원 KT 위즈 파크', city: '수원'),
    Stadium(id: 'DAEGU', name: '대구 삼성 라이온즈 파크', city: '대구'),
    Stadium(id: 'BUSAN', name: '사직야구장', city: '부산'),
    Stadium(id: 'GWANGJU', name: '광주-기아 챔피언스필드', city: '광주'),
    Stadium(id: 'DAEJEON', name: '대전 한화생명볼파크', city: '대전'),
    Stadium(id: 'INCHEON', name: '인천SSG 랜더스필드', city: '인천'),
    Stadium(id: 'CHANGWON', name: '창원NC파크', city: '창원'),
  ];
}
