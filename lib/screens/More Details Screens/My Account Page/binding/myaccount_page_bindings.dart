import 'package:get/get.dart';

import '../controller/myaccount_page_controller.dart';

class MyAccountPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyAccountPageController());
  }
}
