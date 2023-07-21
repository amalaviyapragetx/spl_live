import 'package:get/get.dart';
import 'package:spllive/screens/Select%20Bid%20Page/controller/selectbid_page_controller.dart';

class SelecteBidPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectBidPageController());
  }
}
