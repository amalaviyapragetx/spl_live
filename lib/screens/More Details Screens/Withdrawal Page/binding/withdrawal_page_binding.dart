import 'package:get/get.dart';
import 'package:spllive/screens/More%20Details%20Screens/Withdrawal%20Page/controller/withdrawal_page_controller.dart';

class WithdrawalPageBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WithdrawalPageController());
  }
}
