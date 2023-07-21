import 'package:get/get.dart';
import '../controller/game_pages_controller.dart';

class GameModepageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GameModePagesController());
  }
}
