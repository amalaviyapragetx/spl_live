import 'package:get/get.dart';

import '../controller/check_withdrawal_history_controller.dart';

class CheckWithdrawalPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CheckWithdrawalPageController());
  }
}
