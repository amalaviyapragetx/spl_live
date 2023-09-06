import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/routes/app_routes_name.dart';
import '../../../api_services/api_service.dart';
import '../../../components/DeviceInfo/device_info.dart';
import '../../../components/DeviceInfo/device_information_model.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../Local Storage.dart';
import '../model/user_details_model.dart';

class SetMPINPageController extends GetxController {
  var arguments = Get.arguments;
  RxString mpin = "".obs;
  RxString confirmMpin = "".obs;
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  UserDetails userDetails = UserDetails();
  UserDetailsModel userData = UserDetailsModel();
  Timer? cursorTimer;
  bool _fromLoginPage = false;

  @override
  void onInit() {
    getArguments();
    //getUserData();
    super.onInit();
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  // Future<void> getUserData() async {
  //   var data = await LocalStorage.read(ConstantsVariables.userData);
  //   userData = UserDetailsModel.fromJson(data);
  //   // getMarketBidsByUserId(lazyLoad: false);
  //   print("userDetails :---$data");
  // }

  void getArguments() async {
    await LocalStorage.write(ConstantsVariables.starlineConnect, false);
    print("000000000000000000000$arguments");
    if (arguments != null) {
      userDetails = arguments;
      print("userDetails when condition false : $userDetails");
      _fromLoginPage = false;
    } else {
      callSetUserDetailsApi();
      _fromLoginPage = true;
      print("userDetails when condition true : $userDetails");
    }
  }

  void onTapOfContinue() {
    if (mpin.isEmpty) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERMPIN".tr,
      );
    } else if (mpin.value.length < 4) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERVALIDMPIN".tr,
      );
    } else if (confirmMpin.isEmpty) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERCONFIRMMPIN".tr,
      );
    } else if (confirmMpin.value.length < 4) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERVALIDCONFIRMMPIN".tr,
      );
    } else if (mpin.value != confirmMpin.value) {
      AppUtils.showErrorSnackBar(
        bodyText: "MPINDOWSNTMATCHED".tr,
      );
    } else {
      print("fromloginpage $_fromLoginPage");
      _fromLoginPage ? callSetMpinApi() : callSetUserDetailsApi();
    }
  }

  void callSetUserDetailsApi() async {
    print(userDetailsBody());
    ApiService()
        .setUserDetails(userDetails.userName == null
            ? await userDetailsBody2()
            : await userDetailsBody())
        .then((value) async {
      debugPrint("Set User Details Api Response :- $value");
      if (value != null && value['status']) {
        var userData = value['data'];
        if (userData != null) {
          String authToken = userData['Token'] ?? "Null From API";
          bool isActive = userData['IsActive'] ?? false;
          bool isVerified = userData['IsVerified'] ?? false;
          bool isMpinSet = userData['IsMPinSet'] ?? false;
          await LocalStorage.write(ConstantsVariables.authToken, authToken);
          await LocalStorage.write(ConstantsVariables.isActive, isActive);
          await LocalStorage.write(ConstantsVariables.isVerified, isVerified);
          await LocalStorage.write(ConstantsVariables.isMpinSet, isMpinSet);
          await LocalStorage.write(ConstantsVariables.userData, userData);
        } else {
          AppUtils.showErrorSnackBar(bodyText: "Something went wrong!!!");
        }
        userDetails.userName == null
            ? null
            : Get.offAllNamed(AppRoutName.dashBoardPage);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
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

  Future<Map> userDetailsBody() async {
    DeviceInformationModel deviceInfo = await DeviceInfo().initPlatformState();
    final userDetailsBody = {
      "userName": userDetails.userName,
      "fullName": userDetails.fullName,
      "mPin": mpin.value,
      "password": userDetails.password,
      "oSVersion": deviceInfo.osVersion,
      "appVersion": deviceInfo.appVersion,
      "brandName": deviceInfo.brandName,
      "model": deviceInfo.model,
      "os": deviceInfo.deviceOs,
      "manufacturer": deviceInfo.manufacturer,
    };
    return userDetailsBody;
  }

  userDetailsBody2() async {
    DeviceInformationModel deviceInfo = await DeviceInfo().initPlatformState();
    final userDetailsBody = {
      "oSVersion": deviceInfo.osVersion,
      "appVersion": deviceInfo.appVersion,
      "brandName": deviceInfo.brandName,
      "model": deviceInfo.model,
      "os": deviceInfo.deviceOs,
      "manufacturer": deviceInfo.manufacturer,
    };
    return userDetailsBody;
  }

  Future<void> callSetMpinApi() async {
    ApiService().setMPIN(await setMpinBody()).then((value) async {
      debugPrint("Set MPIN Api Response :- $value");
      if (value != null && value['status']) {
        // AppUtils.showSuccessSnackBar(
        //   bodyText: "${value['message']}",
        //   headerText: "SUCCESSMESSAGE".tr,
        // );
        var userData = value['data'];
        print("userData&&&&&&&&&&&&&&&&&&&&&&&& : $userData");
        if (userData != null) {
          String authToken = userData['Token'] ?? "Null From API";
          bool isActive = userData['IsActive'] ?? false;
          bool isVerified = userData['IsVerified'] ?? false;
          bool isMpinSet = userData['IsMPinSet'] ?? false;
          await LocalStorage.write(ConstantsVariables.authToken, authToken);
          await LocalStorage.write(ConstantsVariables.isActive, isActive);
          await LocalStorage.write(ConstantsVariables.isVerified, isVerified);
          await LocalStorage.write(ConstantsVariables.isMpinSet, isMpinSet);
          await LocalStorage.write(ConstantsVariables.userData, userData);
        } else {
          AppUtils.showErrorSnackBar(bodyText: "Something went wrong!!!");
        }
        Get.offAllNamed(AppRoutName.dashBoardPage);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  Future<Map> setMpinBody() async {
    final userDetailsBody = {
      "mPin": mpin.value,
    };
    return userDetailsBody;
  }
}
