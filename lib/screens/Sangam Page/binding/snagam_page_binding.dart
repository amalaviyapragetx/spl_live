import 'package:get/get.dart';
import 'package:spllive/screens/Sangam%20Page/controller/sangam_page_controller.dart';

class SangamPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SangamPageController());
  }
}
