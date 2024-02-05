import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/utils/constant.dart';

import '../../../api_services/api_service.dart';
import '../../Local Storage.dart';

class ForgotPasswordController extends GetxController {
  var mobileNumberController = TextEditingController();
  var countryCode = '+91'.obs;

  @override
  void dispose() {
    mobileNumberController.dispose();
    super.dispose();
  }

  void onChangeCountryCode(String code) {
    countryCode.value = code;
  }

  void callForgotPasswordApi() async {
    ApiService().forgotPassword(await forgotPasswordBody()).then((value) async {
      if (value['status']) {
        String authToken = value['data']['Token'] ?? "Null From API";
        await LocalStorage.write(ConstantsVariables.authToken, authToken);
        if (value['data']['IsUserDetailSet'] == true) {
          AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
          Get.toNamed(AppRouteNames.resetPasswordPage, arguments: {
            ConstantsVariables.phoneNumber: mobileNumberController.text,
            ConstantsVariables.countryCode: countryCode.value
          });
        } else {
          Get.toNamed(AppRouteNames.userDetailsPage);
        }
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  Future<Map> forgotPasswordBody() async {
    final forgotPasswordBody = {
      "phoneNumber": mobileNumberController.text,
      "countryCode": "+91",
    };
    return forgotPasswordBody;
  }

  void onTapOfContinue() {
    if (mobileNumberController.text.isEmpty) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERMOBILENUMBER".tr,
      );
    } else if (mobileNumberController.text.length < 10) {
      AppUtils.showErrorSnackBar(
        bodyText: "ENTERVALIDNUMBER".tr,
      );
    } else {
      callForgotPasswordApi();
    }
  }
}
