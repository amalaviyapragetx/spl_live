import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/routes/app_routes_name.dart';
import '../../../api_services/api_service.dart';
import '../../../components/DeviceInfo/device_info.dart';
import '../../../helper_files/constant_variables.dart';
import '../../Local Storage.dart';

class SignInPageController extends GetxController {
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  RxBool visiblePassword = false.obs;
  Timer? cursorTimer;
  // var countryCode = '+91'.obs;

  @override
  void dispose() {
    cursorTimer?.cancel();
    mobileNumberController.dispose();
    passwordController.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  void onTapOfVisibilityIcon() {
    visiblePassword.value = !visiblePassword.value;
  }

  void callSignInApi() async {
    ApiService().signInAPI(await signInBody()).then((value) async {
      if (value['status']) {
        // AppUtils.showSuccessSnackBar(
        //     bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
        if (value['data'] != null) {
          String authToken = value['data']['Token'] ?? "Null From API";
          // bool isMpinSet = value['data']['IsMPinSet'] ?? false;
          bool isActive = value['data']['IsActive'] ?? false;
          bool isVerified = value['data']['IsVerified'] ?? false;
          bool isUserDetailSet = value['data']['IsUserDetailSet'] ?? false;
          await LocalStorage.write(ConstantsVariables.authToken, authToken);
          // await LocalStorage.write(ConstantsVariables.isMpinSet, isMpinSet);
          await LocalStorage.write(ConstantsVariables.isActive, isActive);
          await LocalStorage.write(ConstantsVariables.isVerified, isVerified);
          await LocalStorage.write(ConstantsVariables.userData, value['data']);
          await LocalStorage.write(
              ConstantsVariables.isUserDetailSet, isUserDetailSet);

          if (isUserDetailSet) {
            Get.toNamed(AppRoutName.setMPINPage);
          } else {
            Get.toNamed(AppRoutName.userDetailsPage);
          }
        } else {
          AppUtils.showErrorSnackBar(bodyText: "Something went wrong!!!");
        }
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  Future<Map> signInBody() async {
    final signInBody = {
      "phoneNumber": mobileNumberController.text,
      "password": passwordController.text,
      "countryCode": "+92",
      "deviceId": DeviceInfo.deviceId,
      // "deviceId": "954f4d94fdsa94fdsf",
      // "fcmToken": fcmToken,
    };

    return signInBody;
  }

  void onTapOfSignIn() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.closeAllSnackbars();
    if (mobileNumberController.text.isEmpty) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERMOBILENUMBER".tr,
      );
    } else if (mobileNumberController.text.length < 10) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERVALIDNUMBER".tr,
      );
    } else if (passwordController.text.isEmpty) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERPASSWORD".tr,
      );
    } else {
      callSignInApi();
    }
  }
}
