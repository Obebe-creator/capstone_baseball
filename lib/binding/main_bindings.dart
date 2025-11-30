import 'package:capstone_baseball/controller/bottom_nav_controller.dart';
import 'package:capstone_baseball/controller/home_controller.dart';
import 'package:capstone_baseball/controller/record_controller.dart';
import 'package:capstone_baseball/service/record_service.dart';
import 'package:get/get.dart';

class MainBindings implements Bindings {
  @override
  void dependencies() {
    // 바텀네비게이션 / 뒤로가기 관리
    Get.put(BottomNavController());
    Get.put(HomeController());
    Get.put<RecordService>(RecordService());
    Get.put<RecordController>(RecordController(Get.find<RecordService>()));
  }
}
