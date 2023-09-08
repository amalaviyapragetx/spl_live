import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import '../../../api_services/api_service.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../models/commun_models/bid_request_model.dart';
import '../../../models/commun_models/digit_list_model.dart';
import '../../../models/commun_models/json_file_model.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/daily_market_api_response_model.dart';
import '../../../models/game_modes_api_response_model.dart';
import '../../Local Storage.dart';

class SangamPageController extends GetxController {
  bool isValue = false;
  String bidType = "Open";
  Rx<GameMode> gameMode = GameMode().obs;
  Rx<MarketData> marketData = MarketData().obs;
  RxString openText = "OPENDIGIT".tr.obs;
  RxString closeText = "CLOSEPANA".tr.obs;
  RxString openFieldHint = "ENTERDIGIT".tr.obs;
  RxString totalBiddingAmount = "0".obs;
  bool enteredOpenDigitsIsValidate = false;
  bool enteredCloseDigitsIsValidate = false;
  String openValue = "";
  String closeValue = "";
  RxList<String> suggestionOpenList = <String>["222", "124", "125", "145"].obs;
  RxList<String> suggestionCloseList = <String>["111", "123", "122", "145"].obs;

  var argument = Get.arguments;
  Rx<BidRequestModel> requestModel = BidRequestModel().obs;
  RxBool isHalfSangam = false.obs;
  RxBool isOpenBid = true.obs;
  JsonFileModel jsonModel = JsonFileModel();
  RxList<Bids> addedSangamList = <Bids>[].obs;
  var coinsController = TextEditingController();
  var openValueController = TextEditingController();
  var closeValueController = TextEditingController();
  // final FocusNode focusNode1 = FocusNode();
  // final FocusNode coinsFocusNode = FocusNode();
  // final FocusNode openFocusNode = FocusNode();
  // FocusNode closeFocusNode = FocusNode();
  var digitList = <DigitListModelOffline>[].obs;
  late FocusNode focusNode;
  @override
  void onInit() {
    super.onInit();
    getArguments();
    focusNode = FocusNode();
  }

  reverse(String originalString) {
    String reversedString = '';

    for (int i = originalString.length - 1; i >= 0; i--) {
      reversedString += originalString[i];
    }
    return reversedString;
  }

  String addedNormalBidValue = "";
  String checkBidValue = "";
  List<String> _validationListForNormalMode = [];
  var allThreePanaList = <DigitListModelOffline>[].obs;
  List<String> _tempValidationList = [];

  void getArguments() async {
    gameMode.value = argument['gameMode'];
    marketData.value = argument['marketData'];
    requestModel.value.dailyMarketId = marketData.value.id;
    requestModel.value.bidType = bidType;
    var data = await LocalStorage.read(ConstantsVariables.userData);
    UserDetailsModel userData = UserDetailsModel.fromJson(data);
    requestModel.value.userId = userData.id;
    await loadJsonFile();
    switch (gameMode.value.name) {
      case "Full Sangam":
        openText.value = "OPENPANA".tr;
        openFieldHint.value = "ENTERPANA".tr;
        bidType = "Open";
        isHalfSangam.value = false;
        _tempValidationList = jsonModel.allThreePana!;
        // jsonModel.allThreePana = digitList;
        for (var e in jsonModel.triplePana!) {
          allThreePanaList.add(DigitListModelOffline.fromJson(e));
        }
        digitList.value = allThreePanaList;
        break;
      case "Half Sangam A":
        isHalfSangam.value = true;
        _tempValidationList = jsonModel.allThreePana!;
        for (var e in jsonModel.triplePana!) {
          allThreePanaList.add(DigitListModelOffline.fromJson(e));
        }
        digitList.value = allThreePanaList;
        break;
      case "Half Sangam B":
        isHalfSangam.value = true;
        _tempValidationList = jsonModel.allThreePana!;
        for (var e in jsonModel.triplePana!) {
          allThreePanaList.add(DigitListModelOffline.fromJson(e));
        }
        digitList.value = allThreePanaList;
        break;
      default:
    }
    // if (gameMode.value.name == "Full Sangam") {
    // } else {
    //   isHalfSangam.value = true;
    // }
    _validationListForNormalMode.addAll(_tempValidationList);

    //await loadJsonFile();
  }

  Future<void> loadJsonFile() async {
    final String response =
        await rootBundle.loadString('assets/JSON File/digit_file.json');
    final data = await json.decode(response);
    jsonModel = JsonFileModel.fromJson(data);
  }

  void createMarketBidApi() async {
    ApiService()
        .createMarketBid(requestModel.value.toJson())
        .then((value) async {
      debugPrint("create bid api response :- $value");
      if (value['status']) {
        if (value['data'] == null) {
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        } else {
          Get.back();
          AppUtils.showSuccessSnackBar(
              bodyText: value['message'] ?? "",
              headerText: "SUCCESSMESSAGE".tr);
        }
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  void onDeleteBids(int index) {
    // addedSangamList.remove(addedSangamList[index]);
    requestModel.value.bids = addedSangamList;
    requestModel.value.bids!.remove(addedSangamList[index]);
    requestModel.refresh();
    addedSangamList.refresh();
    _calculateTotalAmount();
  }

  void validateEnteredOpenDigit(String value) {
    addedNormalBidValue = value;
    openValue = value;
    // checkBidValue = "$openValue-$closeValue";
  }

  void validateEnteredCloseDigit(bool validate, String value) {
    if (gameMode.value.name!.toUpperCase() != "FULL SANGAM") {
      closeValue = value;
    } else {
      addedNormalBidValue = value;
      closeValue = value;
      // checkBidValue = "$openValue-$closeValue";
      print("***********closeValue***************$value");
    }
  }

  void onTapOfSaveButton() {
    if (requestModel.value.bids != null &&
        requestModel.value.bids!.isNotEmpty) {
      createMarketBidApi();
    } else {
      AppUtils.showErrorSnackBar(
        bodyText: "Please Add Some Bids!",
      );
    }
  }

  halfSangamPanaSwitchCase(ThreePana panaList, int digit) {
    switch (digit) {
      case 0:
        suggestionCloseList.value = panaList.l0!;
        break;
      case 1:
        suggestionCloseList.value = panaList.l1!;
        break;
      case 2:
        suggestionCloseList.value = panaList.l2!;
        break;
      case 3:
        suggestionCloseList.value = panaList.l3!;
        break;
      case 4:
        suggestionCloseList.value = panaList.l4!;
        break;
      case 5:
        suggestionCloseList.value = panaList.l5!;
        break;
      case 6:
        suggestionCloseList.value = panaList.l6!;
        break;
      case 7:
        suggestionCloseList.value = panaList.l7!;
        break;
      case 8:
        suggestionCloseList.value = panaList.l8!;
        break;
      case 9:
        suggestionCloseList.value = panaList.l9!;
        break;
      default:
        suggestionCloseList.value = panaList.l0!;
        break;
    }
  }

  void _calculateTotalAmount() {
    var tempTotal = 0;
    for (var element in addedSangamList) {
      tempTotal += element.coins ?? 0;
    }
    totalBiddingAmount.value = tempTotal.toString();
  }

  void onTapOfAddBidButton() {
    if (int.parse(coinsController.text) > 0 ||
        coinsController.text.isNotEmpty) {
      if (_validationListForNormalMode.contains(addedNormalBidValue) == false) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
        );
        digitList.clear();
        openValueController.clear();
        closeValueController.clear();
        coinsController.clear();
        focusNode.previousFocus();
        focusNode.previousFocus();
      } else if (int.parse(coinsController.text) > 10000) {
        AppUtils.showErrorSnackBar(
          bodyText: "You can not add more than 10000 points",
        );
        openValueController.clear();
        closeValueController.clear();
        coinsController.clear();
        focusNode.previousFocus();
        focusNode.previousFocus();
      } else {
        // print("==============${addedSangamList}");
        var existingIndex = addedSangamList.indexWhere((element) {
          print("${element.bidNo}  =  $openValue-$closeValue");
          return element.bidNo ==
              manipulateString("$openValue-$closeValue", "Half Sangam A");
        });
        print("---------5165544-------------__$existingIndex");
        if (existingIndex != -1) {
          // If the bidNo already exists in selectedBidsList, update coins value.
          addedSangamList[existingIndex].coins =
              (addedSangamList[existingIndex].coins! +
                  int.parse(coinsController.text));
          addedSangamList.refresh();
          requestModel.refresh();
        } else {
          addedSangamList.add(
            Bids(
                bidNo:
                    manipulateString("$openValue-$closeValue", "Half Sangam A"),
                coins: int.parse(coinsController.text),
                gameId: gameMode.value.id,
                gameModeName: gameMode.value.name,
                remarks:
                    "You invested At ${marketData.value.market} on $openValue-$closeValue (${gameMode.value.name})"),
          );
        }
        openValueController.clear();
        closeValueController.clear();
        coinsController.clear();
        focusNode.previousFocus();
        focusNode.previousFocus();
        _calculateTotalAmount();
        requestModel.value.bids = addedSangamList;
        requestModel.refresh();
      }
    } else {
      Get.closeCurrentSnackbar();
      AppUtils.showErrorSnackBar(
        bodyText: "Please Enter Valid Points!",
      );
    }
  }

  /////// String manupiLATION for haldsangam a
  String manipulateString(String input, String gameMode) {
    List<String> parts = input.split('-');
    if (parts.length != 2) {
      return "Invalid input format.";
    }
    Rx<String> manipulatedString = "".obs;
    manipulatedString.value = "${parts[1]}-${parts[0]}";
    print("========input===========++$input");
    if (gameMode == "Half Sangam A") {
      print("===================++$manipulatedString");
      return manipulatedString.value;
    } else {
      return input;
    }
  }
}
