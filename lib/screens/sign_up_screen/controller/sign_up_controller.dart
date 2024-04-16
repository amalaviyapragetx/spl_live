import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/components/DeviceInfo/device_info.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../../../api_services/api_service.dart';

class SignUpPageController extends GetxController {
  var mobileNumberController = TextEditingController();
  var whatsappNumberController = TextEditingController();

  var countryCode = '+91'.obs;

  // bool get kDebugMode => null;

  void onChangeCountryCode(String code) {
    countryCode.value = code;
  }

  void callSignUpApi() async {
    ApiService().signUpAPI(await signUpBody()).then((value) async {
      if (value['data'] != null && value['status']) {
        AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
        Get.toNamed(AppRoutName.verifyOTPPage, arguments: {
          "countryCode": countryCode.value,
          "phoneNumber": mobileNumberController.text,
        });
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  Future<Map<String, dynamic>> signUpBody() async {
    final signUpBody = {
      // "appVersion": deviceInfo.appVersion,
      // "brandName": deviceInfo.brandName,
      // "model": deviceInfo.model,
      // "deviceOs": deviceInfo.deviceOs,
      // "manufacturer": deviceInfo.manufacturer,
      // "osVersion": deviceInfo.osVersion,
      "countryCode": countryCode.value,
      "phoneNumber": mobileNumberController.text,
      "deviceId": DeviceInfo.deviceId,
    };
    if (kDebugMode) {}
    return signUpBody;
  }

  void onTapOfSendOtp() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.closeCurrentSnackbar();
    if (mobileNumberController.text.isEmpty) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERMOBILENUMBER".tr,
      );
    } else if (mobileNumberController.text.toString().length < 10) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERVALIDNUMBER".tr,
      );
    } else {
      callSignUpApi();
    }
  }
}
