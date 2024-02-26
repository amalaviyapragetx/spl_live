import 'package:get/get.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/FundTransactionModel.dart';
import 'package:spllive/models/filter_model.dart';

import '../api_services/api_service.dart';

class WalletController extends GetxController {
  RxString walletBalance = "00".obs;
  final selectedIndex = Rxn<int>();

  final RxList<FilterModel> filterDateList = [
    FilterModel(
      image: ConstantImage.addFundIconInWallet,
      name: "Add Fund",
    ),
    FilterModel(
      image: ConstantImage.withDrawalFundIcon,
      name: "Withdrawal Fund",
    ),
    // FilterModel(
    //   image: ConstantImage.withDrawalFundIcon,
    //   name: "Add bank details",
    // ),
    FilterModel(
      image: ConstantImage.fundDepositIcon,
      name: "Fund deposit history",
    ),
    // FilterModel(
    //   image: ConstantImage.fundDepositIcon,
    //   name: "Fund withdrawal history",
    // ),
    // FilterModel(
    //   image: ConstantImage.withDrawalFundIcon,
    //   name: "Bank Changes history",
    // ),
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

  // transaction

  RxList<FundTransactionList> fundTransactionList = <FundTransactionList>[].obs;
  void getTransactionHistory(bool view) {
    ApiService().getTransactionHistory().then((value) async {
      if (value != null) {
        if (value.status ?? false) {
          fundTransactionList.value = value.data?.rows ?? [];
          if (view) {
            if (fundTransactionList[0].status == "Ok") {
              Get.defaultDialog(
                title: "Success",
                titleStyle: CustomTextStyle.textRobotoSansBold.copyWith(
                  color: AppColors.appbarColor,
                ),
                middleText: "Thank you for your Payment",
                middleTextStyle: CustomTextStyle.textRobotoSansMedium,
              );
            }
          }
          //    AppUtils.showSuccessSnackBar(bodyText: value.message ?? "");
        } else {
          AppUtils.showErrorSnackBar(bodyText: value.message ?? "");
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: "Something went wrong");
      }
    });
  }
}
