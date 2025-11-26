class MemCache {
  static final Map<MemCacheKey, dynamic> _map = {};

  /// 캐시 저장
  static void put(MemCacheKey key, dynamic value) {
    _map[key] = value;
  }

  /// 캐시 가져오기
  static dynamic get(MemCacheKey key) {
    return _map[key];
  }

  /// 해당 키가 캐시에 있는지 확인
  static bool contains(MemCacheKey key) {
    return _map.containsKey(key);
  }

  /// 캐시 제거
  static dynamic remove(MemCacheKey key) {
    return _map.remove(key);
  }

  /// 전체 클리어
  static void clear() {
    _map.clear();
  }
}

enum MemCacheKey {
  userJson, // 로그인한 유저 정보 (필요 시 사용)
  accessToken, // Firebase or 서버 토큰 필요할 때
}
