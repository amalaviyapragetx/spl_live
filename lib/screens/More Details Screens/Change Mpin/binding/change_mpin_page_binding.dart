import 'package:get/get.dart';

import '../controller/change_mpin_controller.dart';

class ChangeMpinPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangeMpinPageController());
  }
}
