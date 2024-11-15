import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../api_services/api_service.dart';
import '../../../../helper_files/constant_variables.dart';
import '../../../../helper_files/ui_utils.dart';
import '../../../../models/commun_models/user_details_model.dart';

class ChangepasswordPageController extends GetxController {
  // final password = TextEditingController().obs;
  // final confirmpassword = TextEditingController().obs;
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  UserDetailsModel userDetailsModel = UserDetailsModel();
  RxBool value = true.obs;

  RxBool loading = false.obs;
  RxBool isObscureOldPassword = true.obs;
  RxBool isObscureNewPassword = true.obs;
  RxBool isObscureConfirmPassword = true.obs;
  RxBool isValidate = false.obs;
  RxString oldPasswordMessage = "".obs;
  RxString newPasswordMessage = "".obs;
  RxString confirmPasswordMessage = "".obs;

  @override
  void onInit() {
    fetchSavedData();
    super.onInit();
  }

  onChanged(String value) {
    if (value.isEmpty) {
      isValidate.value = false;
      oldPasswordMessage.value = "";
    } /* else if (value.length < 6) {
      // oldPasswordMessage.value = "Password cannot be less than 6 characters";
    }*/
    else {
      oldPasswordMessage.value = "";
    }
  }

  onChanged2(String value) {
    if (value.isEmpty) {
      isValidate.value = false;
      newPasswordMessage.value = "";
    } else if (value.length < 6) {
      newPasswordMessage.value = "Password cannot be less than 6 characters";
    } else {
      newPasswordMessage.value = "";
    }
  }

  onChanged3(String value) {
    if (value.isEmpty) {
      isValidate.value = false;
      confirmPasswordMessage.value = "";
    } else if (value.length < 6) {
      confirmPasswordMessage.value = "Password cannot be less than 6 characters";
    } else if (value == newPassword.text) {
      isValidate.value = true;
      confirmPasswordMessage.value = "";
    } else if (value != newPassword.text) {
      isValidate.value = false;
      confirmPasswordMessage.value = "Password does Not Matched";
    } else {
      confirmPasswordMessage.value = "";
    }
  }

  @override
  void dispose() {
    // oldPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> changebody({required String password, required String confirmpassword}) async {
    var veriftybody = {
      "oldPassword": "123456",
      "password": password,
      "confirmPassword": confirmpassword,
    };
    return veriftybody;
  }

  changePassBody() async {
    final verifyUserBody = {
      "oldPassword": oldPassword.text,
      "password": newPassword.text,
      "confirmPassword": confirmPassword.text,
    };

    return verifyUserBody;
  }

  void changePasswordApi() async {
    ApiService().changePassword(await changePassBody()).then((value) async {
      // print(value);
      if (value['status']) {
        Get.back();
        AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
        // if(value['status']==2){
        //   oldPasswordMessage.value =value['message']??"";
        // }
        // AppUtils.showErrorSnackBar(
        //   bodyText: value['message'] ?? "",
        // );
      }
    });
  }

  void onTapConfirmPass() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.closeCurrentSnackbar();
    if (oldPassword.text.isEmpty) {
      // AppUtils.showErrorSnackBar(
      //   bodyText: "Enter Old Password",
      // );
      oldPasswordMessage.value = "Enter Old Password";
    }
    if (newPassword.text.isEmpty) {
      // AppUtils.showErrorSnackBar(
      //   bodyText: "Enter New Password",
      // );
      newPasswordMessage.value = "Enter New Password";
    } else if (confirmPassword.text.isEmpty) {
      // AppUtils.showErrorSnackBar(
      //   bodyText: "Enter Confirm Password",
      // );
      confirmPasswordMessage.value = "Enter Confirm Password";
    } else {
      changePasswordApi();
    }
  }

  Future<dynamic> fetchSavedData() async {
    final userData = GetStorage().read(ConstantsVariables.userData);
    userDetailsModel = UserDetailsModel.fromJson(userData);
  }
}
