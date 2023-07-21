import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../../../api_services/api_service.dart';
import '../../../components/DeviceInfo/device_info.dart';
import '../../../helper_files/constant_variables.dart';
import '../../Local Storage.dart';

class MPINPageController extends GetxController {
  StreamController<ErrorAnimationType> mpinErrorController =
      StreamController<ErrorAnimationType>();
  RxString mpin = "".obs;

  var arguments = Get.arguments;

  var userId = "";

  @override
  void onInit() {
    super.onInit();
    userId = arguments['id'].toString();
  }

  void onCompleteMPIN() {
    if (mpin.isEmpty || mpin.value.length < 4) {
      mpinErrorController.add(ErrorAnimationType.shake);
    } else {
      verifyMPIN();
    }
  }

  void verifyMPIN() async {
    ApiService().verifyMPIN(await verifyMPINBody()).then((value) async {
      debugPrint("Verify MPIN Api Response :- $value");
      if (value != null && value['status']) {
        // AppUtils.showSuccessSnackBar(
        //   bodyText: "${value['message']}",
        //   headerText: "SUCCESSMESSAGE".tr,
        // );
        var userData = value['data'];
        if (userData != null) {
          String authToken = userData['Token'] ?? "Null From API";
          await LocalStorage.write(ConstantsVariables.authToken, authToken);
        } else {
          AppUtils.showErrorSnackBar(bodyText: "Something went wrong!!!");
        }
        Get.offAllNamed(AppRoutName.dashBoardPage);
      } else {
        mpinErrorController.add(ErrorAnimationType.shake);
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  Future<Map> verifyMPINBody() async {
    final verifyMPINBody = {
      "id": userId,
      "mPin": mpin.value,
      "deviceId": DeviceInfo.deviceId
    };
    return verifyMPINBody;
  }

  void forgotMPINApi() async {
    ApiService().forgotMPIN().then((value) async {
      debugPrint("Forgot MPIN Api Response :- $value");
      if (value['status']) {
        Get.toNamed(AppRoutName.verifyOTPPage);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }
}
