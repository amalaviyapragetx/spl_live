import 'package:get/get.dart';

import '../controller/reset_password_controller.dart';

class ResetPasswordBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => ResetPasswordController());
  }
}