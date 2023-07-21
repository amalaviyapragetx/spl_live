import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../../../../api_services/api_service.dart';

class ChangeMpinPageController extends GetxController {
  TextEditingController newMPIN = TextEditingController();
  TextEditingController reEnterMPIN = TextEditingController();
  RxBool isObscureNewPin = true.obs;
  RxBool isObscureConfirmPin = true.obs;
  RxString newPinMessage = "".obs;
  RxString confirmPinMessage = "".obs;

  changePassBody() async {
    final verifyUserBody = {
      "oldMPin": "0000",
      "confirmMPin": newMPIN.text,
      "mPin": reEnterMPIN.text,
    };
    debugPrint(verifyUserBody.toString());
    return verifyUserBody;
  }

  void changePasswordApi() async {
    ApiService().changeMPIN(await changePassBody()).then((value) async {
      debugPrint("Verify OTP Api Response :- $value");
      if (value['status']) {
        print(value['status']);
        AppUtils.showSuccessSnackBar(
            bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
        Get.offAndToNamed(AppRoutName.profilePage);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  validateMpin(String value) {
    if (value.isEmpty) {
      confirmPinMessage.value = "";
    } else {
      confirmPinMessage.value = "Pin does not match";
    }
  }
}
