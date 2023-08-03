import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../../../Custom Controllers/wallet_controller.dart';
import '../../../api_services/api_service.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../models/commun_models/bid_request_model.dart';
import '../../../models/commun_models/digit_list_model.dart';
import '../../../models/commun_models/json_file_model.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/daily_market_api_response_model.dart';
import '../../../models/game_modes_api_response_model.dart';
import '../../Local Storage.dart';

class NewGamemodePageController extends GetxController {
  var coinController = TextEditingController();
  final TextEditingController digitController = TextEditingController();
  // final TextEditingController pointController = TextEditingController();
  Rx<GameMode> gameMode = GameMode().obs;
  List<String> _validationListForNormalMode = [];
  // Rx<MarketData> marketData = MarketData().obs;
  TextEditingController autoCompleteFieldController = TextEditingController();
  String bidType = "Open";
  var argument = Get.arguments;
  JsonFileModel jsonModel = JsonFileModel();
  Rx<BidRequestModel> requestModel = BidRequestModel().obs;
  RxBool isBulkMode = false.obs;
  late FocusNode focusNode;
  RxInt panaControllerLength = 2.obs;
  bool enteredDigitsIsValidate = false;
  String addedNormalBidValue = "";

  @override
  void onInit() {
    super.onInit();
    getArguments();
    focusNode = FocusNode();
  }

  void validateEnteredDigit(bool validate, String value) {
    enteredDigitsIsValidate = validate;
    addedNormalBidValue = value;
    if (!isBulkMode.value && value.length == panaControllerLength.value) {
      focusNode.nextFocus();
    }
  }

  RxString totalAmount = "00".obs;
  void _calculateTotalAmount() {
    var tempTotal = 0;
    for (var element in selectedBidsList) {
      tempTotal += element.coins ?? 0;
    }
    totalAmount.value = tempTotal.toString();
  }

  void onDeleteBids(int index) {
    selectedBidsList.remove(selectedBidsList[index]);
    selectedBidsList.refresh();
    _calculateTotalAmount();
  }

  void onTapOfAddButton() {
    // FocusManager.instance.primaryFocus?.unfocus();
    isBulkMode.value = false;
    if (!isBulkMode.value) {
      print(isBulkMode.value);
      if (_validationListForNormalMode.contains(addedNormalBidValue) == false) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
        );
        focusNode.previousFocus();
      } else if (coinController.text.trim().isEmpty ||
          int.parse(coinController.text.trim()) < 1) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid points",
        );
      } else if (int.parse(coinController.text) > 10000) {
        AppUtils.showErrorSnackBar(
          bodyText: "You can not add more than 10000 points",
        );
      } else {
        selectedBidsList.add(
          Bids(
            bidNo: addedNormalBidValue,
            coins: int.parse(coinController.text),
            gameId: gameMode.value.id,
            gameModeName: gameMode.value.name,
            remarks:
                "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
          ),
        );
        _calculateTotalAmount();
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
        focusNode.previousFocus();
      }
    } else {
      if (!enteredDigitsIsValidate) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
        );
        return;
      } else if (addedNormalBidValue.isEmpty) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter ${gameMode.value.name!.toLowerCase()}",
        );
        return;
      } else if (coinController.text.isEmpty ||
          coinController.text.length < 2) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid points",
        );
        return;
      } else if (int.parse(coinController.text) > 10000) {
        AppUtils.showErrorSnackBar(
          bodyText: "You can not add more than 10000 points",
        );
      } else {
        selectedBidsList.add(
          Bids(
            bidNo: addedNormalBidValue,
            coins: int.parse(coinController.text),
            gameId: gameMode.value.id,
            gameModeName: gameMode.value.name,
            remarks:
                "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
          ),
        );
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
      }
    }
  }

  Future<void> onTapOfSaveButton() async {
    if (selectedBidsList.isNotEmpty) {
      requestModel.value.bids = selectedBidsList;
      createMarketBidApi();
    } else {
      AppUtils.showErrorSnackBar(
        bodyText: "Please add some bids!",
      );
    }
  }

  void createMarketBidApi() async {
    ApiService().createMarketBid(requestModel.toJson()).then((value) async {
      debugPrint("create bid api response :- $value");
      if (value['status']) {
        // Get.back();
        // Get.back();
        if (value['data'] == false) {
          Get.offAndToNamed(AppRoutName.dashBoardPage);
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        } else {
          Get.offAndToNamed(AppRoutName.dashBoardPage);
          AppUtils.showSuccessSnackBar(
              bodyText: value['message'] ?? "",
              headerText: "SUCCESSMESSAGE".tr);
          final walletController = Get.find<WalletController>();
          walletController.getUserBalance();
        }
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  var biddingType = "".obs;
  var marketName = "".obs;
  var marketId = 0;
  var selectedBidsList = <Bids>[].obs;
  var digitList = <DigitListModelOffline>[].obs;
  var singleAnkList = <DigitListModelOffline>[].obs;
  var jodiList = <DigitListModelOffline>[].obs;
  var triplePanaList = <DigitListModelOffline>[].obs;
  var singlePanaList = <DigitListModelOffline>[].obs;
  var doublePanaList = <DigitListModelOffline>[].obs;

  var digitRow = [
    DigitListModelOffline(value: "0", isSelected: false),
    DigitListModelOffline(value: "1", isSelected: false),
    DigitListModelOffline(value: "2", isSelected: false),
    DigitListModelOffline(value: "3", isSelected: false),
    DigitListModelOffline(value: "4", isSelected: false),
    DigitListModelOffline(value: "5", isSelected: false),
    DigitListModelOffline(value: "6", isSelected: false),
    DigitListModelOffline(value: "7", isSelected: false),
    DigitListModelOffline(value: "8", isSelected: false),
    DigitListModelOffline(value: "9", isSelected: false),
  ].obs;
  void getArguments() async {
    gameMode.value = argument['gameMode'];
    biddingType.value = argument['biddingType'];
    marketName.value = argument['marketName'];
    marketId = argument['marketId'];
    isBulkMode.value = argument['isBulkMode'];
    // marketData.value = argument['marketData'];
    // requestModel.value.dailyMarketId = marketData.value.id;
    requestModel.value.bidType = bidType;
    var data = await LocalStorage.read(ConstantsVariables.userData);
    UserDetailsModel userData = UserDetailsModel.fromJson(data);
    requestModel.value.userId = userData.id;
    requestModel.value.bidType = biddingType.value;
    requestModel.value.dailyMarketId = marketId;

    await loadJsonFile();
    RxBool showNumbersLine = false.obs;
    RxList<String> suggestionList = <String>[].obs;
    List<String> _tempValidationList = [];

    switch (gameMode.value.name) {
      case "Single Ank":
        showNumbersLine.value = false;
        panaControllerLength.value = 1;
        _tempValidationList = jsonModel.singleAnk!;
        suggestionList.value = jsonModel.singleAnk!;
        enteredDigitsIsValidate = true;
        panaControllerLength.value = 1;
        for (var e in jsonModel.singleAnk!) {
          singleAnkList.add(DigitListModelOffline.fromJson(e));
        }
        digitList.value = singleAnkList;
        break;
      case "Jodi":
        showNumbersLine.value = false;
        _tempValidationList = jsonModel.jodi!;
        suggestionList.value = jsonModel.jodi!;
        panaControllerLength.value = 2;
        for (var e in jsonModel.jodi!) {
          jodiList.add(DigitListModelOffline.fromJson(e));
        }
        digitList.value = jodiList;
        break;
      case "Single Pana":
        digitRow.first.isSelected = true;
        showNumbersLine.value = true;
        panaControllerLength.value = 3;
        _tempValidationList = jsonModel.allSinglePana!;
        suggestionList.value = jsonModel.singlePana!.single.l0!;
        for (var e in jsonModel.singlePana!.single.l0!) {
          singlePanaList.add(DigitListModelOffline.fromJson(e));
        }
        digitList.value = singlePanaList;
        break;
      case "Double Pana":
        digitRow.first.isSelected = true;
        showNumbersLine.value = true;
        panaControllerLength.value = 3;
        _tempValidationList = jsonModel.allDoublePana!;
        suggestionList.value = jsonModel.doublePana!.single.l0!;
        for (var e in jsonModel.doublePana!.single.l0!) {
          doublePanaList.add(DigitListModelOffline.fromJson(e));
        }
        digitList.value = doublePanaList;
        break;
      case "Tripple Pana":
        showNumbersLine.value = false;
        _tempValidationList = jsonModel.triplePana!;
        suggestionList.value = jsonModel.triplePana!;
        panaControllerLength.value = 3;
        for (var e in jsonModel.triplePana!) {
          triplePanaList.add(DigitListModelOffline.fromJson(e));
        }
        digitList.value = triplePanaList;
        break;
    }
    _validationListForNormalMode.addAll(_tempValidationList);
  }

  Future<void> loadJsonFile() async {
    final String response =
        await rootBundle.loadString('assets/JSON File/digit_file.json');
    final data = await json.decode(response);
    jsonModel = JsonFileModel.fromJson(data);
  }
}
