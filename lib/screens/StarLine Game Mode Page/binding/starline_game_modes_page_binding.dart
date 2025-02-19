import 'package:get/get.dart';

import '../controller/starline_game_modes_page_controller.dart';

class StarLineGameModesPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StarLineGameModesPageController());
  }
}
