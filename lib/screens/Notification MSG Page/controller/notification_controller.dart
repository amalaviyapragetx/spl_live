import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api_services/api_service.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/notifiaction_models/get_all_notification_model.dart';
import '../../../models/notifiaction_models/notification_count_model.dart';

class NotificationController extends GetxController {
  RxList<Rows> notificationData = <Rows>[].obs;
  RxString getNotifiactionCount = "".obs;
  @override
  void onInit() {
    resetNotificationCount();
    getNotificationsData();
    super.onInit();
  }

  void getNotificationsData() async {
    ApiService().getAllNotifications().then((value) async {
      debugPrint("Notifiactions Data Api ------------- :- $value");
      if (value['status']) {
        GetAllNotificationsData model = GetAllNotificationsData.fromJson(value);
        notificationData.value = model.data!.rows as List<Rows>;
        if (model.message!.isNotEmpty) {
          // AppUtils.showSuccessSnackBar(
          //     bodyText: model.message, headerText: "SUCCESSMESSAGE".tr);
        }
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  void resetNotificationCount() async {
    ApiService().resetNotification().then((value) async {
      debugPrint("Notifiaction Count Api ------------- :- $value");
      if (value['status']) {
        NotifiactionCountModel model = NotifiactionCountModel.fromJson(value);
        getNotifiactionCount.value = model.data!.notificationCount.toString();
        if (model.message!.isNotEmpty) {
          // AppUtils.showSuccessSnackBar(
          //     bodyText: model.message, headerText: "SUCCESSMESSAGE".tr);
        }
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }
}
