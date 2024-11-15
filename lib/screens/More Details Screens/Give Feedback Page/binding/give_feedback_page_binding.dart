import 'package:get/get.dart';

import '../controller/give_feedback_page_controller.dart';

class GiveFeedbackPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GiveFeedbackPageController());
  }
}
