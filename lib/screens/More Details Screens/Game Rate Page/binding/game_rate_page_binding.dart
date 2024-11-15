import 'package:get/get.dart';

import '../controller/game_rate_page_controller.dart';

class GameRatePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GameRatePageController());
  }
}
