import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spllive/components/DeviceInfo/device_info.dart';
import 'package:spllive/models/starlinechar_model/new_starlinechart_model.dart';
import 'package:spllive/routes/app_routes_name.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api_services/api_service.dart';
import '../../../components/DeviceInfo/device_information_model.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/constant_image.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../Local Storage.dart';

class SplashController extends GetxController {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  UserDetailsModel _userDetailsModel = UserDetailsModel();
  DeviceInformationModel? deviceInfo;
  String appVersion = "";
  @override
  void onInit() {
    super.onInit();
    checkLogin();
    getDeviceInfo();
    // Timer(Duration(milliseconds: 700), () {});
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

  getDeviceInfo() async {
    DeviceInformationModel deviceInfo = await DeviceInfo().initPlatformState();
    appVersion = deviceInfo.appVersion.toString();
  }

  void appVesionCheck() async {
    ApiService().getAppVersion().then((value) async {
      debugPrint("get App Version:- $value");
      if (value['status']) {
        print(value['data']);
        if (value['data'] != appVersion) {
          _showExitDialog();
        }
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
          Timer(const Duration(milliseconds: 500), () {
            appVesionCheck();
          });
        });
      } else if (isVerified && !isActive) {
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(AppRoutName.userDetailsPage);
          Timer(const Duration(milliseconds: 500), () {
            appVesionCheck();
          });
        });
      } else {
        if (hasMPIN) {
          callFcmApi(_userDetailsModel.id);
          Future.delayed(const Duration(seconds: 2), () {
            Get.offAllNamed(AppRoutName.mPINPage,
                arguments: {"id": _userDetailsModel.id});
            Timer(const Duration(milliseconds: 500), () {
              appVesionCheck();
            });
          });
        } else {
          callFcmApi(_userDetailsModel.id);
          Future.delayed(const Duration(seconds: 2), () {
            Get.offAllNamed(AppRoutName.signInPage,
                arguments: {"id": _userDetailsModel.id});
            Timer(const Duration(milliseconds: 500), () {
              appVesionCheck();
            });
          });
        }
      }
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        // Get.offAllNamed(AppRoutes.dashboardPage);
        Get.offAllNamed(AppRoutName.walcomeScreen);
        Timer(const Duration(milliseconds: 500), () {
          appVesionCheck();
        });
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

  void _showExitDialog() {
    Get.defaultDialog(
      barrierDismissible: false,
      title: "Update App Version",
      onWillPop: () async => false,
      titleStyle: CustomTextStyle.textRobotoSansMedium,
      content: Column(
        children: [
          Text(
            "",
            // style: CustomTextStyle.textRobotoSansMedium.copyWith(
            //   fontSize: Dimensions.h16,
            // ),
          )
        ],
      ),
      actions: [
        InkWell(
          onTap: () async {
            launch(
              "https://spl.live",
            );
          },
          child: Container(
            color: AppColors.appbarColor,
            height: Dimensions.h40,
            width: Dimensions.w200,
            child: Center(
              child: Text(
                'OK',
                style: CustomTextStyle.textRobotoSansBold.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
