import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../../../api_services/api_service.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../Local Storage.dart';

class SplashController extends GetxController {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  UserDetailsModel _userDetailsModel = UserDetailsModel();

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  callFcmApi(userId) async {
    var token = await LocalStorage.read(ConstantsVariables.fcmToken);
    print("===========$token");
    Timer(const Duration(milliseconds: 500), () {
      fsmApiCall(userId, token);
    });
  }

  fcmBody(userId, fcmToken) {
    var a = {
      "id": userId,
      "fcmToken": fcmToken,
    };
    return a;
  }

  void fsmApiCall(userId, fcmToken) async {
    ApiService().fcmToken(await fcmBody(userId, fcmToken)).then((value) async {
      debugPrint("Create Feedback Api Response :- $value");
      if (value['status']) {
        // AppUtils.showSuccessSnackBar(
        //     bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  Future<void> checkLogin() async {
    await LocalStorage.write(ConstantsVariables.timeOut, false);
    bool alreadyLoggedIn = await getStoredUserData();
    bool isActive =
        await LocalStorage.read(ConstantsVariables.isActive) ?? false;
    print(isActive);
    bool isVerified =
        await LocalStorage.read(ConstantsVariables.isVerified) ?? false;
    bool hasMPIN =
        await LocalStorage.read(ConstantsVariables.isMpinSet) ?? false;
    //print(LocalStorage.read(ConstantsVariables.authToken.));
    if (alreadyLoggedIn) {
      if (!isActive && !isVerified) {
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(AppRoutName.verifyOTPPage);
        });
      } else if (isVerified && !isActive) {
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(AppRoutName.userDetailsPage);
        });
      } else {
        if (hasMPIN) {
          callFcmApi(_userDetailsModel.id);
          Future.delayed(const Duration(seconds: 2), () {
            Get.offAllNamed(AppRoutName.mPINPage,
                arguments: {"id": _userDetailsModel.id});
          });
        } else {
          callFcmApi(_userDetailsModel.id);
          Future.delayed(const Duration(seconds: 2), () {
            Get.offAllNamed(AppRoutName.signInPage,
                arguments: {"id": _userDetailsModel.id});
          });
        }
      }
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        // Get.offAllNamed(AppRoutes.dashboardPage);
        Get.offAllNamed(AppRoutName.walcomeScreen);
      });
    }
  }

  Future<bool> getStoredUserData() async {
    String? authToken = await LocalStorage.read(ConstantsVariables.authToken);
    var userData = await LocalStorage.read(ConstantsVariables.userData);
    if (authToken != null && authToken.isNotEmpty) {
      if (userData != null) {
        _userDetailsModel = UserDetailsModel.fromJson(userData);
      }
      return true;
    } else {
      return false;
    }
  }
}
