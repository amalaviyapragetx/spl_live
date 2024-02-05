import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/utils/constant.dart';

class UserDetailsPageController extends GetxController {
  var fullNameController = TextEditingController();
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  final pattern = RegExp(r'^[a-zA-Z\s]+$');
  RxBool pVisibility = false.obs;
  RxBool cpVisibility = false.obs;

  void onTapOfVisibilityIcon(RxBool visibility) {
    visibility.value = !visibility.value;
  }

  void onTapOfRegister() {
    if (fullNameController.text.isEmpty) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERFULLNAME".tr,
      );
    } else if (fullNameController.text.length < 6 && pattern.hasMatch(fullNameController.text.toString())) {
      AppUtils.showErrorSnackBar(
        bodyText: "Full name must be at least 6 characters long and \nshould not contain any numbers",
      );
    } else if (userNameController.text.isEmpty) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERUSERNAME".tr,
      );
    }
    //else if (isPasswordValid(passwordController.text) == false) {
    //   AppUtils.showErrorSnackBar(
    //     bodyText: "REGEXPASSWORDCHECK".tr,
    //   );
    // } else if (isPasswordValid(confirmPasswordController.text) == false) {
    //   AppUtils.showErrorSnackBar(
    //     bodyText: "REGEXPASSWORDCHECK".tr,
    //   );
    // }
    else if (passwordController.text.isEmpty) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERPASSWORD".tr,
      );
    } else if (passwordController.text.toString().length < 6) {
      AppUtils.showErrorSnackBar(
        bodyText: "MINSIXCHAR".tr,
      );
    } else if (confirmPasswordController.text.isEmpty) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERCONFIRMPASSWORD".tr,
      );
    } else if (confirmPasswordController.text.toString().length < 6) {
      AppUtils.showErrorSnackBar(
        bodyText: "MINSIXCHAR".tr,
      );
    } else if (passwordController.text != confirmPasswordController.text) {
      AppUtils.showErrorSnackBar(
        bodyText: "PASSWORDDOESNTMATCHED".tr,
      );
    } else {
      var userDetails = UserDetails(
        fullName: fullNameController.text,
        userName: userNameController.text,
        password: passwordController.text,
      );
      Get.toNamed(AppRouteNames.setMPINPage, arguments: userDetails);
    }
  }
}
