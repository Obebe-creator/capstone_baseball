import 'package:capstone_baseball/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeMain extends GetView<HomeController> {
  const HomeMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  Widget _body() {
    return Column();
  }
}
