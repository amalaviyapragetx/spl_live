import 'package:get/get.dart';
import 'package:spllive/screens/home_screen/controller/homepage_controller.dart';

class HomePageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageController());
  }
}
