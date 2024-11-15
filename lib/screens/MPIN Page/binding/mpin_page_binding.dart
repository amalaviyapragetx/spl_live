import 'package:get/get.dart';

import '../controller/mpin_page_controller.dart';

class MPINPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MPINPageController());
  }
}
