import 'package:get/get.dart';

import '../controller/starline_terms_page_controller.dart';

class StarlineTermsPageBindig extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StarlineTermsPageController());
  }
}
