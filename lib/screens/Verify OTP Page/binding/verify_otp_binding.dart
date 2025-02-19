import 'package:get/get.dart';

import '../controller/verify_otp_controller.dart';

class VerifyOTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerifyOTPController());
  }
}
