import 'package:get/get.dart';

import '../controller/sign_up_controller.dart';

class SignUpPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpPageController());
  }
}
