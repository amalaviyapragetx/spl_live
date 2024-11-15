import 'package:get/get.dart';

import '../controller/about_page_controller.dart';

class AboutUsPageBiding extends Bindings {
  @override
  void dependencies() {
    Get.put(AboutUsPageController());
  }
}
