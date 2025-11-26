import 'package:capstone_baseball/controller/bottom_nav_controller.dart';
import 'package:get/get.dart';

class MainBindings implements Bindings {
  @override
  void dependencies() {
    // 바텀네비게이션 / 뒤로가기 관리
    Get.put(BottomNavController());
    // Get.put(HomeController());
  }
}
