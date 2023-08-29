import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../../../api_services/api_service.dart';
import '../../../helper_files/constant_variables.dart';

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();

  RxBool pVisibility = false.obs;
  RxBool cpVisibility = false.obs;
  RxBool confirmPasswordVisibility = false.obs;
  String phoneNumber = "";
  String countryCode = "";
  var arguments = Get.arguments;
  RxString otp = "".obs;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
    getArguments();
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    super.dispose();
  }
  // @override
  // void onClose() {}

  // @override
  // void onReady() {}

  void getArguments() {
    if (arguments != null) {
      phoneNumber = arguments[ConstantsVariables.phoneNumber];
      countryCode = arguments[ConstantsVariables.countryCode];
    }
  }

  void onTapOfVisibilityIcon(RxBool visibility) {
    visibility.value = !visibility.value;
  }

  void callResetPasswordApi() async {
    ApiService().resetPassword(await resetPasswordBody()).then((value) async {
      debugPrint("Reset password Api Response :- $value");
      if (value['status']) {
        AppUtils.showSuccessSnackBar(
            bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
        Get.offAllNamed(AppRoutName.signInPage);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  Future<Map> resetPasswordBody() async {
    final resetPasswordBody = {
      "countryCode": countryCode,
      "phoneNumber": phoneNumber,
      "otp": otp.value,
      "password": passwordController.text,
      "confirmPassword": confirmPasswordController.text,
    };
    debugPrint(resetPasswordBody.toString());
    return resetPasswordBody;
  }

  void onTapOfResetPassword() {
    Get.closeAllSnackbars();
    if (otp.isEmpty) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTEROTP".tr,
      );
    } else if (otp.value.length < 6) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERVALIDOTP".tr,
      );
    } else if (passwordController.text.isEmpty) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERPASSWORD".tr,
      );
    } else if (confirmPasswordController.text.isEmpty) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERCONFIRMPASSWORD".tr,
      );
    } else if (passwordController.text != confirmPasswordController.text) {
      AppUtils.showErrorSnackBar(
        bodyText: "PASSWORDDOESNTMATCHED".tr,
      );
    } else {
      callResetPasswordApi();
    }
  }

  var secondsRemaining = 60.obs;
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        _timer.cancel(); // Stop the timer when it reaches 0
      }
    });
  }

  String get formattedTime {
    int minutes = (secondsRemaining.value ~/ 60);
    int seconds = (secondsRemaining.value % 60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void callResendOtpApi() async {
    ApiService().resendOTP(await resendOtpBody()).then((value) async {
      debugPrint("Resend otp Api Response :- $value");
      if (value['status']) {
        AppUtils.showSuccessSnackBar(
            bodyText: "${value['message']}", headerText: "SUCCESSMESSAGE".tr);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  Future<Map> resendOtpBody() async {
    final resendOtpBody = {
      "phoneNumber": phoneNumber,
      "countryCode": "+91",
    };
    return resendOtpBody;
  }
}
