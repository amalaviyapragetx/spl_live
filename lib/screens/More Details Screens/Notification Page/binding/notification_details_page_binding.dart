import 'package:get/get.dart';
import 'package:spllive/screens/More%20Details%20Screens/Notification%20Page/controller/notification_details_controller.dart';

class NotificationDetailsPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationDetailsPageController());
  }
}
