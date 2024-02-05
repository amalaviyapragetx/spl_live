import 'package:get/get.dart';
import 'package:spllive/helper_files/constant_variables.dart';
import 'package:spllive/screens/Local%20Storage.dart';

import '../../../../api_services/api_service.dart';
import '../../../../helper_files/ui_utils.dart';

class NotificationDetailsPageController extends GetxController {
  // RxBool marketNotification = true.obs;
  // RxBool starlineNotification = true.obs;
  RxBool marketNotificationFromLocal = true.obs;
  RxBool starlineNotificationFromLocal = true.obs;

  @override
  void onInit() async {
    marketNotificationFromLocal.value =
        await LocalStorage.read(ConstantsVariables.marketNotification);
    starlineNotificationFromLocal.value =
        await LocalStorage.read(ConstantsVariables.starlineNotification);
    if (marketNotificationFromLocal.value == null) {
      await LocalStorage.write(ConstantsVariables.marketNotification, true);
      await LocalStorage.write(ConstantsVariables.starlineNotification, true);
      callNotification();
    }
    super.onInit();
  }

  void callNotification() async {
    ApiService().marketNotifications(await marketBody()).then((value) async {
      
      if (value['status']) {
        await LocalStorage.write(ConstantsVariables.marketNotification,
            marketNotificationFromLocal.value);
        await LocalStorage.write(ConstantsVariables.starlineNotification,
            starlineNotificationFromLocal.value);
        
        // AppUtils.showSuccessSnackBar(
        //     bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  marketBody() {
    var data = {
      "isMarketNotification": "$marketNotificationFromLocal",
      "isStarlineMarketNotification": "$starlineNotificationFromLocal"
    };
    return data;
  }
}
