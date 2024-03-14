import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/helper_files/ui_utils.dart';

import '../../../../api_services/api_service.dart';
import '../../../../helper_files/constant_variables.dart';
import '../../../../models/bank_details_model.dart';
import '../../../../models/commun_models/user_details_model.dart';

class MyAccountPageController extends GetxController {
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accHolderNameController = TextEditingController();
  TextEditingController accNoController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  UserDetailsModel userDetailsModel = UserDetailsModel();
  RxBool isEditDetails = false.obs;
  RxString accountName = "".obs;
  RxString bankName = "".obs;
  RxString accountNumber = "".obs;
  RxString ifcsCode = "".obs;
  var userId = "";
  int bankId = 0;
  var walletbalance = Get.put(WalletController());

  Future<void> fetchStoredUserDetailsAndGetBankDetailsByUserId() async {
    final data = GetStorage().read(ConstantsVariables.userData);
    UserDetailsModel userData = UserDetailsModel.fromJson(data);
    userId = userData.id == null ? "" : userData.id.toString();
    if (userId.isNotEmpty) {
      callGetBankDetails(userId);
      walletbalance.walletBalance.refresh();
    } else {
      AppUtils.showErrorSnackBar(bodyText: "SOMETHINGWENTWRONG".tr);
    }
  }

  void validationFied() {
    if (bankNameController.text.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "Enter name of the bank");
    } else if (accHolderNameController.text.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "Enter Account Holder Name");
    } else if (accNoController.text.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "Enter Account Number");
    } else if (ifscCodeController.text.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "Enter Ifsc Code");
    } else {
      onTapOfEditDetails();
      Get.back();
    }
  }

  void onTapOfEditDetails() async {
    if (isEditDetails.value) {
      callEditBankDetailsApi();
      walletbalance.walletBalance.refresh();
    } else {
      AppUtils.showErrorSnackBar(bodyText: "CONTACTADMINTOEDITDETAILS".tr);
    }
  }

  void callGetBankDetails(String userId) async {
    ApiService().getBankDetails({"id": userId, "userId": userId}).then((value) async {
      if (value['status']) {
        BankDetailsResponseModel model = BankDetailsResponseModel.fromJson(value);
        if (model.message!.isNotEmpty) {
          AppUtils.showSuccessSnackBar(bodyText: model.message, headerText: "SUCCESSMESSAGE".tr);
        }
        isEditDetails.value = model.data!.isEditPermission ?? false;
        bankNameController.text = model.data!.bankName ?? "Null From API";
        accHolderNameController.text = model.data!.accountHolderName ?? "Null From API";
        accNoController.text = model.data!.accountNumber ?? "Null From API";
        ifscCodeController.text = model.data!.iFSCCode ?? "Null From API";
        bankId = model.data!.id ?? 0;
      } else {
        isEditDetails.value = true;
      }
    });
  }

  void callEditBankDetailsApi() async {
    ApiService().editBankDetails(await ediBankDetailsBody()).then((value) async {
      if (value['status']) {
        BankDetailsResponseModel model = BankDetailsResponseModel.fromJson(value);
        isEditDetails.value = false;
        bankNameController.text = model.data!.bankName ?? "Null From API";
        accHolderNameController.text = model.data!.accountHolderName ?? "Null From API";
        accNoController.text = model.data!.accountNumber ?? "Null From API";
        ifscCodeController.text = model.data!.iFSCCode ?? "Null From API";
        bankId = model.data!.id ?? 0;
        AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
      } else {
        isEditDetails.value = true;
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  Future<Map> ediBankDetailsBody() async {
    var ediBankDetailsBody = {
      //  "id": bankId,
      "userId": int.parse(userId),
      "bankName": bankNameController.text,
      "accountHolderName": accHolderNameController.text,
      "accountNumber": accNoController.text,
      "ifscCode": ifscCodeController.text,
      // "gpayNumber": gPayNumberController.text,
      // "paytmNumber": paytmNumberController.text,
      // "bhimUPI": bhimUpiController.text,
    };
    if (bankId != 0) {
      ediBankDetailsBody["id"] = bankId;
    }
    // ediBankDetailsBody.addIf(bankId != 0, "id", bankId);
    //  debugPrint(ediBankDetailsBody.toString());

    return ediBankDetailsBody;
  }
}
