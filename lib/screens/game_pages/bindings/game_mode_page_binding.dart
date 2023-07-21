import 'package:get/get.dart';

import '../controller/game_page_controller.dart';

class GamepageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GamePageController());
  }
}
