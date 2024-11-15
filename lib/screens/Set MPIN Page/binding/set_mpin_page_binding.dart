import 'package:get/get.dart';
import '../controller/set_mpin_page_controller.dart';

class SetMPINPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetMPINPageController());
  }
}
