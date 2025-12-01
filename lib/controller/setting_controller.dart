import 'package:capstone_baseball/data/baseball_data.dart';
import 'package:capstone_baseball/model/team.dart';
import 'package:capstone_baseball/theme/image_paths.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  static const _favoriteTeamKey = 'favorite_team_id';

  /// 현재 선택된 응원팀 (없을 수 있음)
  final Rxn<Team> _selectedTeam = Rxn<Team>();

  Team? get selectedTeam => _selectedTeam.value;
  String get selectedTeamName => _selectedTeam.value?.shortName ?? '미선택';

  /// 팀 id → 로고 경로 매핑 (const 말고 final)
  static final Map<String, String> _teamLogoMap = {
    'DOOSAN': ImagePaths.doosanLogo,
    'LG': ImagePaths.lgLogo,
    'KIA': ImagePaths.kiaLogo,
    'KT': ImagePaths.ktLogo,
    'SAMSUNG': ImagePaths.samsungLogo,
    'LOTTE': ImagePaths.lotteLogo,
    'SSG': ImagePaths.ssgLogo,
    'HANWHA': ImagePaths.hanwhaLogo,
    'NC': ImagePaths.ncLogo,
    'KIWOOM': ImagePaths.kiwoomLogo,
  };

  /// 현재 팀의 로고 경로 (없으면 메인 로고)
  String get selectedTeamLogo {
    final team = _selectedTeam.value;
    if (team == null) return ImagePaths.mainLogo; // 기본 이미지
    return _teamLogoMap[team.id] ?? ImagePaths.mainLogo;
  }

  /// 팀 선택용 옵션
  List<Team> get teamOptions => BaseballData.teams;

  /// 특정 팀의 로고 경로
  String logoForTeam(Team team) {
    return _teamLogoMap[team.id] ?? ImagePaths.mainLogo;
  }

  @override
  void onInit() {
    super.onInit();
    _loadFavoriteTeam();
  }

  /// 앱 켜질 때 SharedPreferences에서 응원팀 불러오기
  Future<void> _loadFavoriteTeam() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_favoriteTeamKey);

    if (id == null) {
      // 아무 것도 선택 안 했던 상태 → null 유지 (mainLogo 노출)
      return;
    }

    final team = BaseballData.teams.firstWhere(
      (t) => t.id == id,
      orElse: () => BaseballData.teams.first,
    );

    _selectedTeam.value = team;
  }

  /// 응원팀 변경 + SharedPreferences 저장
  Future<void> changeTeam(Team team) async {
    _selectedTeam.value = team;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favoriteTeamKey, team.id);
  }
}
