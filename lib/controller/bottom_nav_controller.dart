import 'dart:io';
import 'package:get/get.dart';

// 하단 탭 화면 구분
enum Page {
  home, // 0
  history, // 1
  analysis, // 2
  settings, // 3
}

class BottomNavController extends GetxController {
  /// 현재 페이지 인덱스 (처음은 홈)
  final RxInt _pageIndex = 0.obs;

  /// 뒤로가기를 위한 history stack
  final List<int> _history = [0];

  int get index => _pageIndex.value;

  void changeIndex(int value) {
    final page = Page.values[value];

    switch (page) {
      case Page.home:
      case Page.history:
      case Page.analysis:
      case Page.settings:
        _moveToPage(value);
        break;
    }
  }

  /// 페이지 이동 처리 + 히스토리 관리
  void _moveToPage(int value) {
    if (Platform.isAndroid && _history.last != value) {
      _history.add(value);
    }
    _pageIndex(value);
  }

  /// 뒤로가기 처리
  ///
  /// - history.length == 1 → 앱 종료 허용(true)
  /// - 그 외엔 이전 탭으로 이동(false)
  Future<bool> popAction() async {
    if (_history.length == 1) {
      return true; // 종료 허용
    } else {
      _history.removeLast();
      _pageIndex(_history.last);
      return false; // 뒤로가기 소비
    }
  }

  /// PopScope / WillPopScope 에서 호출되는 헬퍼
  Future<void> handleBack() async {
    await popAction();
  }
}
