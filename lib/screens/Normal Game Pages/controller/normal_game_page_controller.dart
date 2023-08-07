import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../Custom Controllers/wallet_controller.dart';
import '../../../api_services/api_service.dart';
import '../../../api_services/api_urls.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/commun_models/bid_request_model.dart';
import '../../../models/commun_models/digit_list_model.dart';
import '../../../models/commun_models/json_file_model.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/game_modes_api_response_model.dart';
import '../../../routes/app_routes_name.dart';
import '../../Local Storage.dart';

class NormalGamePageController extends GetxController {
  var coinController = TextEditingController();
  var leftAnkController = TextEditingController();
  var rightAnkController = TextEditingController();
  var middleAnkController = TextEditingController();

  var spdptpList = [];
  String spValue = "SP";
  String dpValue = "DP";
  String tpValue = "TP";
  RxBool spValue1 = false.obs;
  RxBool dpValue2 = false.obs;
  String addedNormalBidValue = "";
  RxBool tpValue3 = false.obs;
  RxString totalAmount = "00".obs;
  RxInt panaControllerLength = 2.obs;
  late FocusNode focusNode;
  JsonFileModel jsonModel = JsonFileModel();
  Rx<BidRequestModel> requestModel = BidRequestModel().obs;
  List<String> selectedValues = [];
  var selectedBidsList = <Bids>[].obs;
  List<String> _validationListForNormalMode = [];
  Rx<GameMode> gameMode = GameMode().obs;
  RxBool oddbool = true.obs;
  RxBool evenbool = false.obs;

  Future<void> loadJsonFile() async {
    final String response =
        await rootBundle.loadString('assets/JSON File/digit_file.json');
    final data = await json.decode(response);
    jsonModel = JsonFileModel.fromJson(data);
  }

  var digitList = <DigitListModelOffline>[].obs;
  var singleAnkList = <DigitListModelOffline>[].obs;
  var jodiList = <DigitListModelOffline>[].obs;
  var biddingType = "".obs;
  var marketName = "".obs;
  var marketId = 0;
  String bidType = "Open";
  var argument = Get.arguments;
  bool enteredDigitsIsValidate = false;
  var apiUrl = "";

  @override
  void onInit() {
    super.onInit();
    getArguments();
    focusNode = FocusNode();
  }

  void getArguments() async {
    gameMode.value = argument['gameMode'];
    biddingType.value = argument['biddingType'];
    marketName.value = argument['marketName'];
    marketId = argument['marketId'];
    // isBulkMode.value = argument['isBulkMode'];
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
      case "Choice Pana SPDP":
        showNumbersLine.value = false;
        panaControllerLength.value = 1;
        apiUrl = ApiUtils.choicePanaSPDP;
        // _tempValidationList = jsonModel.singleAnk!;
        // suggestionList.value = jsonModel.singleAnk!;
        // enteredDigitsIsValidate = true;
        // panaControllerLength.value = 1;
        // for (var e in jsonModel.singleAnk!) {
        //   singleAnkList.add(DigitListModelOffline.fromJson(e));
        // }
        // digitList.value = singleAnkList;
        break;
      case "Digits Based Jodi":
        showNumbersLine.value = false;
        panaControllerLength.value = 1;
        apiUrl = ApiUtils.digitsBasedJodi;
        // _tempValidationList = jsonModel.singleAnk!;
        // suggestionList.value = jsonModel.singleAnk!;
        // enteredDigitsIsValidate = true;
        // panaControllerLength.value = 1;
        // for (var e in jsonModel.singleAnk!) {
        //   singleAnkList.add(DigitListModelOffline.fromJson(e));
        // }
        // digitList.value = singleAnkList;
        break;
      case "Odd Even":
        showNumbersLine.value = false;
        panaControllerLength.value = 1;
        _tempValidationList = jsonModel.singleAnk!;
        // suggestionList.value = jsonModel.singleAnk!;
        // enteredDigitsIsValidate = true;
        // panaControllerLength.value = 1;

        // digitList.value = singleAnkList;
        break;
    }
    _validationListForNormalMode.addAll(_tempValidationList);
  }

  // void onTapOfAddButton() {
  //   // FocusManager.instance.primaryFocus?.unfocus();

  //   print(requestModel.value.dailyMarketId);
  //   if (!isBulkMode.value) {
  //     if (_validationListForNormalMode.contains(addedNormalBidValue) == false) {
  //       AppUtils.showErrorSnackBar(
  //         bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
  //       );
  //       focusNode.previousFocus();
  //     } else if (coinController.text.trim().isEmpty ||
  //         int.parse(coinController.text.trim()) < 1) {
  //       AppUtils.showErrorSnackBar(
  //         bodyText: "Please enter valid points",
  //       );
  //     } else if (int.parse(coinController.text) > 10000) {
  //       AppUtils.showErrorSnackBar(
  //         bodyText: "You can not add more than 10000 points",
  //       );
  //     } else {
  //       if (spdptpList.isEmpty) {
  //         selectedBidsList.add(
  //           Bids(
  //             bidNo: addedNormalBidValue,
  //             coins: int.parse(coinController.text),
  //             gameId: gameMode.value.id,
  //             subGameId: checkPanaType(),
  //             gameModeName: gameMode.value.name,
  //             remarks:
  //                 "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
  //           ),
  //         );
  //       } else {
  //         print("======= List not empty =====");
  //         for (var i = 0; i < spdptpList.length; i++) {
  //           selectedBidsList.add(
  //             Bids(
  //               bidNo: spdptpList[i],
  //               coins: int.parse(coinController.text),
  //               gameId: gameMode.value.id,
  //               // subGameId: checkPanaType(),
  //               gameModeName: gameMode.value.name,
  //               remarks:
  //                   "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
  //             ),
  //           );
  //         }
  //       }
  //       print("===== selectedBidsList =======");
  //       print(selectedBidsList.toList());
  //       _calculateTotalAmount();
  //       autoCompleteFieldController.clear();
  //       coinController.clear();
  //       selectedBidsList.refresh();
  //       focusNode.previousFocus();
  //     }
  //   } else {
  //     if (!enteredDigitsIsValidate) {
  //       AppUtils.showErrorSnackBar(
  //         bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
  //       );
  //       return;
  //     } else if (addedNormalBidValue.isEmpty) {
  //       AppUtils.showErrorSnackBar(
  //         bodyText: "Please enter ${gameMode.value.name!.toLowerCase()}",
  //       );
  //       return;
  //     } else if (coinController.text.isEmpty ||
  //         coinController.text.length < 2) {
  //       AppUtils.showErrorSnackBar(
  //         bodyText: "Please enter valid points",
  //       );
  //       return;
  //     } else if (int.parse(coinController.text) > 10000) {
  //       AppUtils.showErrorSnackBar(
  //         bodyText: "You can not add more than 10000 points",
  //       );
  //     } else {
  //       selectedBidsList.add(
  //         Bids(
  //           bidNo: addedNormalBidValue,
  //           coins: int.parse(coinController.text),
  //           gameId: gameMode.value.id,
  //           gameModeName: gameMode.value.name,
  //           subGameId: checkPanaType(),
  //           remarks:
  //               "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
  //         ),
  //       );
  //       print("selectebidlist : $selectedBidsList");
  //       autoCompleteFieldController.clear();
  //       coinController.clear();
  //       selectedBidsList.refresh();
  //     }
  //   }

  ///  print(requestModel.toJson());
  //   for (var index in selectedBidsList) {
  //     print(
  //         "${index.bidNo} ${index.gameId} ${index.gameModeName} ${index.subGameId} ");
  //     // print("checkPanaType() ${checkPanaType()}");
  //   }
  // }

  onTapAddOddEven() {
    for (var i = 0; i < 10; i++) {
      if (oddbool.value) {
        if (i % 2 != 0) {
          selectedBidsList.add(
            Bids(
              bidNo: i.toString(),
              coins: int.parse(coinController.text),
              gameId: gameMode.value.id,
              gameModeName: gameMode.value.name,
              // subGameId: checkPanaType(),
              remarks:
                  "You invested At ${marketName.value} on $i (${gameMode.value.name})",
            ),
          );
        }
      } else {
        if (i % 2 == 0) {
          selectedBidsList.add(
            Bids(
              bidNo: i.toString(),
              coins: int.parse(coinController.text),
              gameId: gameMode.value.id,
              gameModeName: gameMode.value.name,
              // subGameId: checkPanaType(),
              remarks:
                  "You invested At ${marketName.value} on $i (${gameMode.value.name})",
            ),
          );
        }
      }
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

  Future<Map> groupJodiBody() async {
    String panaType = selectedValues.join(',');
    final a = {
      "left": leftAnkController.text,
      "middle": middleAnkController.text,
      "right": rightAnkController.text,
      "panaType": panaType,
    };
    return a;
  }

  void groupJodiData() async {
    ApiService().newGameModeApi(await groupJodiBody(), apiUrl).then(
      (value) async {
        debugPrint("Forgot MPIN Api Response :- $value");
        if (value['status']) {
          spdptpList = value['data'];
          if (spdptpList.isEmpty) {
            print("===== spdptpList empty =================");
            print(spdptpList);
            // selectedBidsList.add(
            //   Bids(
            //     bidNo: addedNormalBidValue,
            //     coins: int.parse(coinController.text),
            //     gameId: gameMode.value.id,s
            //     subGameId: checkPanaType(),
            //     gameModeName: gameMode.value.name,
            //     remarks:
            //         "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
            //   ),
            // );
          } else {
            print("======= List not empty =====");
            // print(spdptpList);
            for (var i = 0; i < spdptpList.length; i++) {
// spdptpList[i].toString() pass this value in one fiunction which returm the type of the pana

// gameId
// Main game modes
// Single Ank, Jodi, Single Pana, Double Pana, Triple Pana
// Single Ank, Jodi,  Single Pana, Double Pana, ==> Bulk
// make once fucntion which takes  child game modes name and will return parent game modes with Id == GameId
// Panel Group, SDDPTP, Red Brackets, Choice Pana SPDP, SP Moter, DP Moter, Group Jodi, Digit Based Jodi,
// Odd Even
// make One function which will take pana as a parameter and will return pana type with parent game
// mode name ==? Sub game mode Id
              print(spdptpList[i].toString());
              selectedBidsList.add(
                Bids(
                  bidNo: spdptpList[i].toString(),
                  coins: int.parse(coinController.text),
                  gameId: gameMode.value.id,
                  // subGameId: ,
                  gameModeName: gameMode.value.name,
                  remarks:
                      "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
                ),
              );
            }
            print("===== selectedBidsList =======");
            print(selectedBidsList.toJson());
          }
          // print(spdptpList);
        } else {
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        }
      },
    );
  }

  Future<Map> digitBasedJodiJodiBody() async {
    final a = {
      "leftDigit": leftAnkController.text,
      "rightDigit": rightAnkController.text,
    };
    return a;
  }

  void digitsBasedJodiData() async {
    ApiService().newGameModeApi(await digitBasedJodiJodiBody(), apiUrl).then(
      (value) async {
        debugPrint("Forgot MPIN Api Response :- $value");
        if (value['status']) {
          spdptpList = value['data'];

          if (spdptpList.isEmpty) {
            print("===== spdptpList empty =================");
            print(spdptpList);
            // selectedBidsList.add(
            //   Bids(
            //     bidNo: addedNormalBidValue,
            //     coins: int.parse(coinController.text),
            //     gameId: gameMode.value.id,s
            //     subGameId: checkPanaType(),
            //     gameModeName: gameMode.value.name,
            //     remarks:
            //         "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
            //   ),
            // );
          } else {
            print("======= List not empty =====");
            // print(spdptpList);
            for (var i = 0; i < spdptpList.length; i++) {
// spdptpList[i].toString() pass this value in one fiunction which returm the type of the pana

// gameId
// Main game modes
// Single Ank, Jodi, Single Pana, Double Pana, Triple Pana
// Single Ank, Jodi,  Single Pana, Double Pana, ==> Bulk
// make once fucntion which takes  child game modes name and will return parent game modes with Id == GameId
// Panel Group, SDDPTP, Red Brackets, Choice Pana SPDP, SP Moter, DP Moter, Group Jodi, Digit Based Jodi,
// Odd Even
// make One function which will take pana as a parameter and will return pana type with parent game
// mode name ==? Sub game mode Id
              print(spdptpList[i].toString());
              selectedBidsList.add(
                Bids(
                  bidNo: spdptpList[i].toString(),
                  coins: int.parse(coinController.text),
                  gameId: gameMode.value.id,
                  // subGameId: ,
                  gameModeName: gameMode.value.name,
                  remarks:
                      "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
                ),
              );
            }
            print("===== selectedBidsList =======");
            print(selectedBidsList.toJson());
          }
          // print(spdptpList);
        } else {
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        }
      },
    );
  }
}
