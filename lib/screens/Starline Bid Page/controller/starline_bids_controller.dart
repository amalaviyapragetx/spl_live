import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../Custom Controllers/wallet_controller.dart';
import '../../../api_services/api_service.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/commun_models/starline_bid_request_model.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/starline_daily_market_api_response.dart';
import '../../../models/starline_game_modes_api_response_model.dart';
import '../../../routes/app_routes_name.dart';

class StarlineBidsController extends GetxController {
  Rx<StarlineBidRequestModel> requestModel = StarlineBidRequestModel().obs;
  Rx<StarlineMarketData> marketData = StarlineMarketData().obs;
  var arguments = Get.arguments;
  RxString totalAmount = "0".obs;
  Rx<StarLineGameMod> gameMode = StarLineGameMod().obs;
  RxList<StarLineBids> bidList = <StarLineBids>[].obs;

  @override
  void onInit() async {
    getArguments();
    GetStorage().write(ConstantsVariables.starlineConnect, true);
    super.onInit();
  }

  checkType(index) {
    if (requestModel.value.bids![index].bidNo!.length == 1) {
      return "Ank";
    } else {
      return "Pana";
    }
  }

  showData() {
    bidList.value = GetStorage().read(ConstantsVariables.starlineBidsList);
  }

  void playMore() {
    GetStorage().write(ConstantsVariables.starlineBidsList, requestModel.value.bids);
    Get.back();
    // Get.offAndToNamed(AppRoutName.starLineGameModesPage);
  }

  Future<void> getArguments() async {
    showData();
    gameMode.value = arguments['gameMode'];
    marketData.value = arguments['marketData'];
    requestModel.value.bids = arguments['bidsList'];
    requestModel.refresh();
    _calculateTotalAmount();
    requestModel.value.dailyStarlineMarketId = marketData.value.id;
    var data = GetStorage().read(ConstantsVariables.userData);
    UserDetailsModel userData = UserDetailsModel.fromJson(data);
    // requestModel.value.userId = userData.id;

    // GetStorage().write(ConstantsVariables.playMore, false);
    // var hh = GetStorage().read(ConstantsVariables.playMore);
    // print("playMore $hh");
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm!'),
          content: Text(
            'Do you really wish to submit?',
            style: CustomTextStyle.textRobotoSansLight.copyWith(
              color: AppColors.grey,
              fontSize: Dimensions.h14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'CANCLE',
                style: CustomTextStyle.textPTsansBold.copyWith(
                  color: AppColors.appbarColor,
                  fontSize: Dimensions.h13,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                createMarketBidApi();
                requestModel.value.bids!.clear();
                requestModel.refresh();
              },
              child: Text(
                'OKAY',
                style: CustomTextStyle.textPTsansBold.copyWith(
                  color: AppColors.appbarColor,
                  fontSize: Dimensions.h13,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _calculateTotalAmount() {
    int tempTotal = 0;
    for (var element in requestModel.value.bids ?? []) {
      tempTotal += int.parse(element.coins.toString());
    }
    totalAmount.value = tempTotal.toString();
  }

  void onDeleteBids(int index) {
    requestModel.value.bids!.remove(requestModel.value.bids![index]);
    requestModel.refresh();
    _calculateTotalAmount();
    if (requestModel.value.bids!.isEmpty) {
      Get.offAndToNamed(AppRoutName.dashBoardPage);
      // Get.back();
    }
  }

  void createMarketBidApi() async {
    ApiService().createStarLineMarketBid(requestModel.value.toJson()).then((value) async {
      if (value['status']) {
        Get.back();
        Get.back();
        // Get.offAllNamed(
        //   AppRoutName.starLineGameModesPage,
        //   arguments: marketData.value,
        // );
        //  Get.offAndToNamed(AppRoutName.dashBoardPage);
        if (value['data'] == false) {
          Get.back();
          Get.back();
          // Get.offAllNamed(
          //   AppRoutName.starLineGameModesPage,
          //   arguments: marketData.value,
          // );
          // Get.offAndToNamed(AppRoutName.dashBoardPage);
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        } else {
          AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
        }
        GetStorage().remove(ConstantsVariables.bidsList);
        GetStorage().remove(ConstantsVariables.marketName);
        GetStorage().remove(ConstantsVariables.biddingType);
        requestModel.value.bids?.clear();
        final walletController = Get.find<WalletController>();
        walletController.getUserBalance();
        walletController.walletBalance.refresh();
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }
}
