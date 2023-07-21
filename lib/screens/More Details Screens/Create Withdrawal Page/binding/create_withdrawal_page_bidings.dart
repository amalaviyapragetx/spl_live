import 'package:get/get.dart';
import 'package:spllive/screens/More%20Details%20Screens/Create%20Withdrawal%20Page/controller/create_withdrawal_page_controller.dart';

class CreateWithDrawalPageBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateWithDrawalPageController());
  }
}
