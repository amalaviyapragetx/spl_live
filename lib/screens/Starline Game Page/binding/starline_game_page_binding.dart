import 'package:get/get.dart';

import '../controller/starline_game_page_controller.dart';

class StarLineGamePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StarLineGamePageController());
  }
}
