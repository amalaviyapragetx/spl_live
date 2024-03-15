import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/components/simple_button_with_corner.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/constant_variables.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/BankHistory.dart';
import 'package:spllive/models/FundTransactionModel.dart';
import 'package:spllive/models/commun_models/user_details_model.dart';
import 'package:spllive/models/filter_model.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../api_services/api_service.dart';

class WalletController extends GetxController {
  RxString walletBalance = "00".obs;
  final selectedIndex = Rxn<int>();
  RxBool isCallDialog = false.obs;

  final RxList<FilterModel> filterDateList = [
    FilterModel(
      image: ConstantImage.addFundIconInWallet,
      name: "Add Fund",
    ),
    FilterModel(
      image: ConstantImage.withDrawalFundIcon,
      name: "Withdrawal Fund",
    ),
    FilterModel(
      image: ConstantImage.withDrawalFundIcon,
      name: "Add bank details",
    ),
    FilterModel(
      image: ConstantImage.fundDepositIcon,
      name: "Fund deposit history",
    ),
    FilterModel(
      image: ConstantImage.fundDepositIcon,
      name: "Fund withdrawal history",
    ),
    FilterModel(
      image: ConstantImage.withDrawalFundIcon,
      name: "Bank Changes history",
    ),
  ].obs;

  @override
  void onInit() {
    getUserBalance();
    super.onInit();
  }

  void getUserBalance() {
    ApiService().getBalance().then((value) async {
      if (value['status']) {
        if (value['data'] != null) {
          var tempBalance = value['data']['Amount'] ?? 00;
          walletBalance.value = tempBalance.toString();
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  RxList<BankHistoryData> bankHistoryData = <BankHistoryData>[].obs;
  void getBankHistory() {
    UserDetailsModel userData = UserDetailsModel.fromJson(GetStorage().read(ConstantsVariables.userData));
    ApiService().getBankHistory(id: userData.id.toString()).then((value) async {
      if (value?.status ?? false) {
        bankHistoryData.value = value?.data ?? [];
      } else {
        AppUtils.showErrorSnackBar(bodyText: value?.message ?? "");
      }
    });
  }

  // transaction

  RxList<FundTransactionList> fundTransactionList = <FundTransactionList>[].obs;
  void getTransactionHistory(bool view) {
    ApiService().getTransactionHistory().then((value) async {
      if (value != null) {
        if (value.status ?? false) {
          fundTransactionList.value = value.data?.rows ?? [];
          if (view) {
            if (isCallDialog.value) {
              if (fundTransactionList[0].status == "Ok") {
                isCallDialog.value = false;
                Get.defaultDialog(
                  barrierDismissible: false,
                  onWillPop: () async => false,
                  title: "",
                  titleStyle: CustomTextStyle.textRobotoSansBold.copyWith(
                    color: AppColors.appbarColor,
                    fontSize: 0,
                  ),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check_rounded,
                            color: AppColors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Payment Successful",
                        style: CustomTextStyle.textRobotoSansBold.copyWith(
                          color: AppColors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "We have received the payment of",
                        style: CustomTextStyle.textRobotoSansMedium,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "\n₹ ${fundTransactionList[0].amount}",
                        style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RoundedCornerButton(
                          text: "OK".tr,
                          color: AppColors.appbarColor,
                          borderColor: AppColors.appbarColor,
                          fontSize: Dimensions.h15,
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.white,
                          letterSpacing: 0,
                          borderRadius: Dimensions.r5,
                          borderWidth: 0,
                          textStyle: CustomTextStyle.textGothamMedium,
                          onTap: () {
                            getUserBalance();
                            walletBalance.refresh();
                            Get.offAllNamed(AppRoutName.dashBoardPage);
                          },
                          height: 40,
                          width: Get.width / 2.8,
                        ),
                      )
                    ],
                  ),
                );
              }
              if (fundTransactionList[0].status == "F") {
                isCallDialog.value = false;
                Get.defaultDialog(
                  barrierDismissible: false,
                  onWillPop: () async => false,
                  title: "",
                  titleStyle: CustomTextStyle.textRobotoSansBold.copyWith(
                    color: AppColors.appbarColor,
                    fontSize: 0,
                  ),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: AppColors.redColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.close_rounded,
                            color: AppColors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Payment Failed",
                        style: CustomTextStyle.textRobotoSansBold.copyWith(
                          color: AppColors.redColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Your payment was not successfully processed",
                        style: CustomTextStyle.textRobotoSansMedium,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Please try again",
                        style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RoundedCornerButton(
                          text: "OK".tr,
                          color: AppColors.appbarColor,
                          borderColor: AppColors.appbarColor,
                          fontSize: Dimensions.h15,
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.white,
                          letterSpacing: 0,
                          borderRadius: Dimensions.r5,
                          borderWidth: 0,
                          textStyle: CustomTextStyle.textGothamMedium,
                          onTap: () {
                            Get.back();
                            Get.offAllNamed(AppRoutName.dashBoardPage);
                          },
                          height: 40,
                          width: Get.width / 2.8,
                        ),
                      )
                    ],
                  ),
                );
              }
            }
          }
        } else {
          AppUtils.showErrorSnackBar(bodyText: value.message ?? "");
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: "Something went wrong");
      }
    });
  }
}
