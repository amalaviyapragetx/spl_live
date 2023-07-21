import 'package:get/get.dart';

import '../controller/forgot_password_page_controller.dart';

class ForgotPasswordPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordController());
  }
}
