import 'package:get/get.dart';

import '../controller/myprofile_page_controller.dart';

class MyProfilePageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyProfilePageController());
  }
}
