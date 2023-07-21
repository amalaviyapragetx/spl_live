import 'package:get/get.dart';

import '../controller/change_password_controller.dart';

class ChangePasswordPageBidings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangepasswordPageController());
  }
}
