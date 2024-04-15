import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/ui_utils.dart';

import '../../../../api_services/api_service.dart';

class ChangeMpinPageController extends GetxController {
  TextEditingController oldMPIN = TextEditingController();
  TextEditingController newMPIN = TextEditingController();
  TextEditingController reEnterMPIN = TextEditingController();
  final FocusNode oldMPINFocusNode = FocusNode();
  final FocusNode newMPINFocusNode = FocusNode();
  final FocusNode reEnterMPINFocusNode = FocusNode();
  RxBool isObscureOldPin = true.obs;
  RxBool isObscureNewPin = true.obs;
  RxBool isObscureConfirmPin = true.obs;
  RxString newPinMessage = "".obs;
  RxString confirmPinMessage = "".obs;
  RxString oldPinMessage = "".obs;
  RxBool isValidate = false.obs;

  @override
  void dispose() {
    oldMPINFocusNode.dispose();
    newMPINFocusNode.dispose();
    reEnterMPINFocusNode.dispose();
    super.dispose();
  }

  changePassBody() async {
    final verifyUserBody = {
      "oldMPin": oldMPIN.text,
      "confirmMPin": newMPIN.text,
      "mPin": reEnterMPIN.text,
    };

    return verifyUserBody;
  }

  void changePasswordApi() async {
    ApiService().changeMPIN(await changePassBody()).then((value) async {
      if (value['status']) {
        Get.back();
        AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  void onTapOfContinue() {
    if (oldMPIN.text.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "Please Enter Old MPIN");
    } else if (reEnterMPIN.text != newMPIN.text) {
      AppUtils.showErrorSnackBar(bodyText: "Please Re-Enter Valid New MPIN");
    } else {
      changePasswordApi();
    }
  }

  onChanged3(String value) {
    if (value.isEmpty) {
      confirmPinMessage.value = "pin is required";
    } else if (value.length != 4) {
      confirmPinMessage.value = "Pin must be 4 digit";
    } else {
      confirmPinMessage.value = "";
    }
    if (value == newMPIN.text) {
      isValidate.value = true;
      confirmPinMessage.value = "Pin Matched";
    }
    if (oldMPIN.text.length == 4 && reEnterMPIN.text.length == 4 && newMPIN.text.length == 4) {
      isValidate.value = true;
    } else {
      isValidate.value = false;
    }
    if (value != newMPIN.text) {
      isValidate.value = false;
      confirmPinMessage.value = "Pin does not match";
    }
  }

  onChanged2(String value) {
    if (value.isEmpty) {
      newPinMessage.value = "pin is required";
    } else if (value.length != 4) {
      newPinMessage.value = "Pin must be 4 digit";
    } else {
      newPinMessage.value = "";
    }

    if (value == reEnterMPIN.text) {
      isValidate.value = true;
      confirmPinMessage.value = "Pin Matched";
      if (oldMPIN.text.length == 4 && reEnterMPIN.text.length == 4 && newMPIN.text.length == 4) {
        isValidate.value = true;
      } else {
        isValidate.value = false;
      }
    }
    if (value != reEnterMPIN.text) {
      isValidate.value = false;
      confirmPinMessage.value = "Pin does not match";
    }
  }

  onChanged1(String value) {
    if (value.isEmpty) {
      oldPinMessage.value = "pin is required";
    } else {
      oldPinMessage.value = "";
    }
    if (oldMPIN.text.length == 4 && reEnterMPIN.text.length == 4 && newMPIN.text.length == 4) {
      isValidate.value = true;
    } else {
      isValidate.value = false;
    }
  }
}
