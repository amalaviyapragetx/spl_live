import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/routes/app_routes_name.dart';
import '../../../Custom Controllers/wallet_controller.dart';
import '../../../api_services/api_service.dart';
import '../../../api_services/api_urls.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../models/commun_models/bid_request_model.dart';
import '../../../models/commun_models/digit_list_model.dart';
import '../../../models/commun_models/json_file_model.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/daily_market_api_response_model.dart';
import '../../../models/game_modes_api_response_model.dart';
import '../../../models/new_game_model.dart';
import '../../Local Storage.dart';
import '../../home_screen/controller/homepage_controller.dart';

class NewGamemodePageController extends GetxController {
  var coinController = TextEditingController();
  TextEditingController digitController = TextEditingController();

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

  Rx<GameMode> gameMode = GameMode().obs;
  final List<String> _validationListForNormalMode = [];
  TextEditingController autoCompleteFieldController = TextEditingController();
  Model2 newgameModel = Model2();
  String bidType = "Open";
  var argument = Get.arguments;
  JsonFileModel jsonModel = JsonFileModel();
  Rx<BidRequestModel> requestModel = BidRequestModel().obs;
  RxBool isBulkMode = false.obs;
  late FocusNode focusNode;
  RxInt panaControllerLength = 2.obs;
  bool enteredDigitsIsValidate = false;
  String addedNormalBidValue = "";
  String newGameModeBidValue = "";
  var spdptpList = [];
  String spValue = "SP";
  String dpValue = "DP";
  String tpValue = "TP";
  RxBool spValue1 = false.obs;
  RxBool dpValue2 = false.obs;
  RxBool tpValue3 = false.obs;
  List<String> selectedValues = [];
  var apiUrl = "";
  RxString totalAmount = "0".obs;
  Rx<GameModesApiResponseModel> gameModeList = GameModesApiResponseModel().obs;
  Timer? _debounce;
  var digitsForSPDPTP = {
    0: "zero",
    1: "one",
    2: "two",
    3: "three",
    4: "four",
    5: "five",
    6: "six",
    7: "seven",
    8: "eight",
    9: "nine",
  };
  var redBrackelist = [
    "11",
    "22",
    "33",
    "44",
    "55",
    "66",
    "77",
    "88",
    "99",
    "00"
  ];
  var digitsPanel = {
    0: "fiveZero",
    1: "oneSix",
    2: "twoSeven",
    3: "threeEight",
    4: "fourNine",
    5: "fiveZero",
    6: "oneSix",
    7: "twoSeven",
    8: "threeEight",
    9: "fourNine",
  };
  Map<String, List<List<String>>> panelGroupChart = {};
  var marketValue = MarketData().obs;
  List<String> spdpMotor = [];
  Map<String, dynamic>? spdptplistFromModel = {};
  List allPanaList = [];
  List<String> groupJodiData = [];
  @override
  void onInit() {
    super.onInit();
    getArguments();
    focusNode = FocusNode();
  }

  void getArguments() async {
    gameModeList = argument['gameModeList'];
    marketValue.value = argument['marketValue'];
    // marketValue.value = argument['marketValue'];
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
    List<String> tempValidationList = [];
    Map<String, List<List<String>>> panaGroupList;

    switch (gameMode.value.name) {
      case "Single Ank":
        showNumbersLine.value = false;
        panaControllerLength.value = 1;
        tempValidationList = jsonModel.singleAnk!;
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
        tempValidationList = jsonModel.jodi!;
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
        tempValidationList = jsonModel.allSinglePana!;
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
        tempValidationList = jsonModel.allDoublePana!;
        suggestionList.value = jsonModel.doublePana!.single.l0!;
        for (var e in jsonModel.doublePana!.single.l0!) {
          doublePanaList.add(DigitListModelOffline.fromJson(e));
        }
        digitList.value = doublePanaList;
        break;
      case "Tripple Pana":
        showNumbersLine.value = false;
        tempValidationList = jsonModel.triplePana!;
        suggestionList.value = jsonModel.triplePana!;
        panaControllerLength.value = 3;
        for (var e in jsonModel.triplePana!) {
          triplePanaList.add(DigitListModelOffline.fromJson(e));
        }
        digitList.value = triplePanaList;
        break;
      case "SPDPTP":
        apiUrl = ApiUtils.spdptp;
        showNumbersLine.value = false;
        // _tempValidationList = jsonModel.triplePana!;
        // suggestionList.value = jsonModel.triplePana!;
        spdptplistFromModel = jsonModel.spdptpChart!;
        for (var e in spdptpList) {
          tempValidationList = e;
        }
        panaControllerLength.value = 1;
    
        // digitList.value = triplePanaList;
        break;
      case "Panel Group":
        showNumbersLine.value = false;
        apiUrl = ApiUtils.panelGroup;
        panaControllerLength.value = 3;
        panaGroupList = jsonModel.panelGroupChart!;
        panelGroupChart = panaGroupList;
        
        break;
      case "SP Motor":
        showNumbersLine.value = false;
        apiUrl = ApiUtils.spMotor;
        panaControllerLength.value = 10;
        spdpMotor = jsonModel.spdptp!['SP'] as List<String>;
        break;
      case "DP Motor":
        showNumbersLine.value = false;
        apiUrl = ApiUtils.dpMotor;
        panaControllerLength.value = 10;
        spdpMotor = jsonModel.spdptp!['DP'] as List<String>;
    
        break;
      case "Two Digits Panel":
        showNumbersLine.value = false;
        apiUrl = ApiUtils.towDigitJodi;
        panaControllerLength.value = 2;
        spdpMotor = jsonModel.allThreePana!;
     
        break;
      case "Red Brackets":
        showNumbersLine.value = false;
        tempValidationList = redBrackelist;
        suggestionList.value = redBrackelist;
        panaControllerLength.value = 2;
        break;
      case "Group Jodi":
        showNumbersLine.value = false;
        apiUrl = ApiUtils.groupJody;
        panaControllerLength.value = 2;
        groupJodiData = jsonModel.groupJodi!;
       
        break;
    }
    _validationListForNormalMode.addAll(tempValidationList);
  }

  List<String> getTwoDigitPanelPana(int inputNumber) {
    List<int> inputDigits =
        inputNumber.toString().split('').map(int.parse).toList();

    bool containsBothInputDigits(String num) {
      String numStr = num.toString();
      return inputDigits.every((digit) => numStr.contains(digit.toString()));
    }
    return spdpMotor.where(containsBothInputDigits).toList();
  }

  List<String> groupJodi(String stringToFind) {
    List<String> groupList = groupJodiData;
   
    List<String>? result;
    bool toStop = false;
    for (var element in groupList) {
      List<String> stringList = element
          .replaceAll('[', '') // Remove the opening square bracket
          .replaceAll(']', '') // Remove the closing square bracket
          .split(', ');
      for (var tetst in stringList) {
        if (tetst == stringToFind) {
          result = stringList;
          toStop = true;
          break;
        }
      }
      if (toStop) {
        break;
      }
    }

    if (result != null) {
   
      return result;
    } else {
      return [];
    }
  }

  List<String> getSPDPTPPana(int singleAnk) {
    List<String> pana = [];
    var result = spdptplistFromModel![digitsForSPDPTP[singleAnk]];
    for (int i = 0; i < selectedValues.length; i++) {
      List<String> data = result[selectedValues[i]];
      for (int j = 0; j < data.length; j++) {
        pana.add(data[j]);
      }
    }
    // print("--------------------------$pana");
    return pana;
  }

  List<String> getSPMotorPana(int inputNum) {
    List<String> panaArray = spdpMotor;
    // Convert the input number to a string to extract individual digits
    List<String> inputDigits = inputNum.toString().split('');
    // Initialize an empty list to store matching elements
    List<String> matchingElements = [];

    // Loop through the elements in the array
    for (String element in panaArray) {
      // Convert each element to a string to extract individual digits
      List<String> elementDigits = element.toString().split('');
      // Check if all the input digits are present in the element digits
      bool tempBool = true;
      for (int i = 0; i < elementDigits.length; i++) {
        if (!inputDigits.contains(elementDigits[i])) {
          // print("=========== not match");
          tempBool = false;
        }
      }
      if (tempBool) {
        matchingElements.add(element);
      }
    }
  
    return matchingElements;
  }

  String getSingleDigit(int pana) {
    String digit = pana.toString();
    int sum = 0;
    String singleAnk = '0';

    for (int i = 0; i < digit.length; i++) {
      sum += int.parse(digit[i]);
    }
    String newResult = sum.toString();

    if (newResult.length > 1) {
      singleAnk = newResult[1];
    } else {
      singleAnk = newResult;
    }

    return singleAnk;
  }

  List<String> getPanelGroupPana(int pana) {
    List<String> bids = [];
    String? digit = digitsPanel[int.parse(getSingleDigit(pana))];
    List<List<String>>? values = panelGroupChart[digit];
    if (values != null) {
      for (int i = 0; i < values.length; i++) {
        List<String> temp = values[i];
        for (int j = 0; j < temp.length; j++) {
          if (temp.contains(pana.toString())) {
            bids = temp;
            break;
          }
        }
      }
    }
    return bids;
  }

  ondebounce(bool validate, String value) {
    if (_debounce != null && _debounce!.isActive) {
      _debounce!.cancel();
    }
    Timer(const Duration(milliseconds: 100), () {
      enteredDigitsIsValidate = validate;
      addedNormalBidValue = value;
      newGamemodeValidation(validate, value);
    });
  }

  checkType(index) {
    if (selectedBidsList.elementAt(index).gameModeName!.contains("Ank")) {
      return "Ank";
    } else if (selectedBidsList
            .elementAt(index)
            .gameModeName!
            .contains("Jodi") ||
        selectedBidsList.elementAt(index).gameModeName! == "Red Brackets") {
      return "Jodi";
    } else {
      return "Pana";
    }
  }

  void validateEnteredDigit(bool validate, String value) {
    enteredDigitsIsValidate = validate;
    addedNormalBidValue = value;
    if (!isBulkMode.value && value.length == panaControllerLength.value) {
      focusNode.nextFocus();
    }
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

  void onTapOfAddButton() {
    // FocusManager.instance.primaryFocus?.unfocus();
    isBulkMode.value = false;
 
    if (!isBulkMode.value) {
      if (_validationListForNormalMode.contains(addedNormalBidValue) == false) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
        );
        autoCompleteFieldController.clear();
        coinController.clear();
        digitList.clear();
        focusNode.previousFocus();
      } else if (coinController.text.trim().isEmpty ||
          int.parse(coinController.text.trim()) < 1) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid points",
        );
        autoCompleteFieldController.clear();
        coinController.clear();
        digitList.clear();
        focusNode.previousFocus();
      } else if (int.parse(coinController.text) > 10000) {
        AppUtils.showErrorSnackBar(
          bodyText: "You can not add more than 10000 points",
        );
      } else {
        if (spdptpList.isEmpty) {
          var existingIndex = selectedBidsList
              .indexWhere((element) => element.bidNo == addedNormalBidValue);
          if (existingIndex != -1) {
            // If the bidNo already exists in selectedBidsList, update coins value.
            selectedBidsList[existingIndex].coins =
                (selectedBidsList[existingIndex].coins! +
                    int.parse(coinController.text));
          } else {
            selectedBidsList.insert(
              0,
              Bids(
                bidNo: addedNormalBidValue,
                coins: int.parse(coinController.text),
                gameId: gameMode.value.id,
                subGameId: gameMode.value.id,
                gameModeName: gameMode.value.name,
                remarks:
                    "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
              ),
            );
          }
        }
      
        _calculateTotalAmount();
        autoCompleteFieldController.clear();
        coinController.clear();
        digitList.clear();
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
          int.parse(coinController.text.trim()) < 1) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid points",
        );
        return;
      } else if (int.parse(coinController.text) > 10000) {
        AppUtils.showErrorSnackBar(
          bodyText: "You can not add more than 10000 points",
        );
      } else {
        var existingIndex = selectedBidsList
            .indexWhere((element) => element.bidNo == addedNormalBidValue);
        if (existingIndex != -1) {
          // If the bidNo already exists in selectedBidsList, update coins value.
          selectedBidsList[existingIndex].coins =
              (selectedBidsList[existingIndex].coins! +
                  int.parse(coinController.text));
        } else {
          selectedBidsList.add(
            Bids(
              bidNo: addedNormalBidValue,
              coins: int.parse(coinController.text),
              gameId: gameMode.value.id,
              subGameId: gameMode.value.id,
              gameModeName: gameMode.value.name,
              remarks:
                  "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
            ),
          );
        }
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
      }
    }
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
              onPressed: () {
                // Handle cancel button press
                Get.back();
              },
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
                selectedBidsList.clear();
                coinController.clear();
                _calculateTotalAmount();
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

  Future<void> onTapOfSaveButton(context) async {
    if (selectedBidsList.isNotEmpty) {
      requestModel.value.bids = selectedBidsList;
      showConfirmationDialog(context);
    } else {
      AppUtils.showErrorSnackBar(
        bodyText: "Please add some bids!",
      );
    }
  }

  void createMarketBidApi() async {
    ApiService().createMarketBid(requestModel.toJson()).then(
      (value) async {
        
        if (value['status']) {
          if (value['data'] == false) {
            selectedBidsList.clear();
            Get.offAllNamed(AppRoutName.gameModePage,
                arguments: marketValue.value);
            // Get.offAndToNamed(
            //   AppRoutName.gameModePage,
            //   arguments: marketValue.value,
            // );
            AppUtils.showErrorSnackBar(
              bodyText: value['message'] ?? "",
            );
            HomePageController().marketBidsByUserId(lazyLoad: false);
          } else {
            Get.offAllNamed(
              AppRoutName.gameModePage,
              arguments: marketValue.value,
            );
            // Get.offAndToNamed(
            //   AppRoutName.gameModePage,
            //   arguments: marketValue.value,
            // );
            AppUtils.showSuccessSnackBar(
                bodyText: value['message'] ?? "",
                headerText: "SUCCESSMESSAGE".tr);
            final walletController = Get.find<WalletController>();
            walletController.getUserBalance();
            walletController.walletBalance.refresh();
          }
          LocalStorage.remove(ConstantsVariables.bidsList);
          LocalStorage.remove(ConstantsVariables.marketName);
          LocalStorage.remove(ConstantsVariables.biddingType);
        } else {
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        }
        requestModel.value.bids!.clear();
        _calculateTotalAmount();
        final walletController = Get.find<WalletController>();
        walletController.getUserBalance();
        walletController.walletBalance.refresh();
      },
    );
  }

  Future<void> loadJsonFile() async {
    final String response =
        await rootBundle.loadString('assets/JSON File/digit_file.json');
    final data = await json.decode(response);
    jsonModel = JsonFileModel.fromJson(data);
  }

  Future<Map> spdptpbody() async {
    String panaType = selectedValues.join(',');
    
    final a = {"digit": autoCompleteFieldController.text, "panaType": panaType};
    final b = {"pana": autoCompleteFieldController.text};
    if (gameMode.value.name == "Panel Group") {
      return b;
    } else {
      return a;
    }
  }

  newGamemodeValidation(bool validate, String value) {
    if (value.length == panaControllerLength.value) {
      focusNode.nextFocus();
    } else if (gameMode.value.name == "SPDPTP") {
      if (spValue1.value == false &&
          dpValue2.value == false &&
          tpValue3.value == false) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please select SP,DP or TP",
        );
      }
    }
    enteredDigitsIsValidate = validate;
  }

  gmaemodeNames() {
    switch (gameMode.value.name!) {
      case "SP Motor":
        return getSPMotorPana(int.parse(autoCompleteFieldController.text));
      case "DP Motor":
        return getSPMotorPana(int.parse(autoCompleteFieldController.text));
      case "Panel Group":
        return getPanelGroupPana(int.parse(autoCompleteFieldController.text));
      case "SPDPTP":
        return getSPDPTPPana(
            int.parse(autoCompleteFieldController.text.removeAllWhitespace));
      case "Group Jodi":
        return groupJodi(autoCompleteFieldController.text.removeAllWhitespace);
      case "Two Digits Panel":
        return getTwoDigitPanelPana(
            int.parse(autoCompleteFieldController.text.removeAllWhitespace));
      default:
    }
  }

  void pennleDataOnTapSave() async {
    if (gameMode.value.name == "SPDPTP") {
      if (spValue1.value == false &&
          dpValue2.value == false &&
          tpValue3.value == false) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please select SP,DP or TP",
          duration: const Duration(seconds: 1),
        );
      } else {
        if (coinController.text.trim().isEmpty ||
            int.parse(coinController.text.trim()) < 1) {
          AppUtils.showErrorSnackBar(
            bodyText: "Please enter valid points",
            duration: const Duration(seconds: 1),
          );
        } else if (int.parse(coinController.text) > 10000) {
          AppUtils.showErrorSnackBar(
            bodyText: "You can not add more than 10000 points",
            duration: const Duration(seconds: 1),
          );
        } else {
          spdptpList = gmaemodeNames();
     
          if (spdptpList.isNotEmpty) {
         
            for (var i = 0; i < spdptpList.length; i++) {
              addedNormalBidValue = spdptpList[i].toString();
              var existingIndex = selectedBidsList.indexWhere(
                  (element) => element.bidNo == addedNormalBidValue);
              if (existingIndex != -1) {
                selectedBidsList[existingIndex].coins =
                    (selectedBidsList[existingIndex].coins! +
                        int.parse(coinController.text));
                digitList.clear();
                coinController.clear();
              } else {
                selectedBidsList.insert(
                  0,
                  Bids(
                    bidNo: addedNormalBidValue,
                    coins: int.parse(coinController.text),
                    gameId: gameMode.value.id,
                    subGameId: gameMode.value.id,
                    gameModeName: gameMode.value.name,
                    remarks:
                        "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
                  ),
                );
              }
            }
            _calculateTotalAmount();
          } else {
            AppUtils.showErrorSnackBar(
              bodyText: "Please enter ${gameMode.value.name!.toLowerCase()}",
              duration: const Duration(seconds: 1),
            );
          }
        }
      }
    } else {
      if (coinController.text.trim().isEmpty ||
          int.parse(coinController.text.trim()) < 1) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid points",
        );
        autoCompleteFieldController.clear();
        coinController.clear();
      } else if (int.parse(coinController.text) > 10000) {
        AppUtils.showErrorSnackBar(
          bodyText: "You can not add more than 10000 points",
        );
        autoCompleteFieldController.clear();
        coinController.clear();
        focusNode.previousFocus();
      } else {
        spdptpList = gmaemodeNames();
        if (spdptpList.isEmpty) {
          AppUtils.showErrorSnackBar(
            bodyText:
                "Please enter valid ${gameMode.value.name!.toLowerCase()}",
          );
          focusNode.previousFocus();
        } else {
          for (var i = 0; i < spdptpList.length; i++) {
            addedNormalBidValue = spdptpList[i].toString();
            var existingIndex = selectedBidsList
                .indexWhere((element) => element.bidNo == addedNormalBidValue);
            if (existingIndex != -1) {
              // If the bidNo already exists in selectedBidsList, update coins value.
              selectedBidsList[existingIndex].coins =
                  (selectedBidsList[existingIndex].coins! +
                      int.parse(coinController.text));
            } else {
              selectedBidsList.insert(
                0,
                Bids(
                  bidNo: addedNormalBidValue,
                  coins: int.parse(coinController.text),
                  gameId: gameMode.value.id,
                  subGameId: gameMode.value.id,
                  gameModeName: gameMode.value.name,
                  remarks:
                      "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
                ),
              );
            }
          }
          autoCompleteFieldController.clear();
          coinController.clear();
          selectedBidsList.refresh();
        }
        _calculateTotalAmount();
      }
    }
    autoCompleteFieldController.clear();
    coinController.clear();
    selectedBidsList.refresh();
    focusNode.previousFocus();
  }

  void getspdptp() async {
    // if (gameMode.value.name == "SPDPTP") {
    // if (spValue1.value == false &&
    //     dpValue2.value == false &&
    //     tpValue3.value == false) {
    //   AppUtils.showErrorSnackBar(
    //     bodyText: "Please select SP,DP or TP",
    //   );
    // } else {
    //   ApiService().newGameModeApi(await spdptpbody(), apiUrl).then(
    //     (value) async {
    //       debugPrint("New Game-Mode Api Response :- $value");
    //       if (value['status']) {
    //         //         spdptpList = value['data'];
    //         //_validationListForNormalMode = newarrr;
    //         if (coinController.text.trim().isEmpty ||
    //             int.parse(coinController.text.trim()) < 1) {
    //           AppUtils.showErrorSnackBar(
    //             bodyText: "Please enter valid points",
    //             duration: const Duration(milliseconds: 300),
    //           );
    //         } else if (int.parse(coinController.text) > 10000) {
    //           AppUtils.showErrorSnackBar(
    //             bodyText: "You can not add more than 10000 points",
    //             duration: const Duration(milliseconds: 300),
    //           );
    //         } else {
    //           if (spdptpList.isEmpty) {
    //             AppUtils.showErrorSnackBar(
    //               bodyText:
    //                   "Please enter ${gameMode.value.name!.toLowerCase()}",
    //               duration: const Duration(milliseconds: 300),
    //             );
    //           } else {
    //             for (var i = 0; i < spdptpList.length; i++) {
    //               addedNormalBidValue = spdptpList[i].toString();
    //               var existingIndex = selectedBidsList.indexWhere(
    //                   (element) => element.bidNo == addedNormalBidValue);
    //               if (existingIndex != -1) {
    //                 selectedBidsList[existingIndex].coins =
    //                     (selectedBidsList[existingIndex].coins! +
    //                         int.parse(coinController.text));
    //                 digitList.clear();
    //                 coinController.clear();
    //               } else {
    //                 selectedBidsList.add(
    //                   Bids(
    //                     bidNo: addedNormalBidValue,
    //                     coins: int.parse(coinController.text),
    //                     gameId: gameMode.value.id,
    //                     subGameId: gameMode.value.id,
    //                     gameModeName: gameMode.value.name,
    //                     remarks:
    //                         "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
    //                   ),
    //                 );
    //               }
    //             }
    //             print("===== selectedBidsList =======");
    //             // print(selectedBidsList.toJson());
    //           }
    //           _calculateTotalAmount();
    //           selectedBidsList.refresh();
    //         }
    //         // print(spdptpList);
    //       } else {
    //         AppUtils.showErrorSnackBar(
    //           bodyText: value['message'] ?? "",
    //         );
    //       }
    //       autoCompleteFieldController.clear();
    //       coinController.clear();
    //       selectedBidsList.refresh();
    //       focusNode.previousFocus();
    // }
    //     },
    //   );
    // }
    // } else {
    ApiService().newGameModeApi(await spdptpbody(), apiUrl).then(
      (value) async {
   
        if (value['status']) {
          spdptpList = value['data'];
          //_validationListForNormalMode = newarrr;
          if (coinController.text.trim().isEmpty ||
              int.parse(coinController.text.trim()) < 1) {
            AppUtils.showErrorSnackBar(
              bodyText: "Please enter valid points",
            );
            autoCompleteFieldController.clear();
            coinController.clear();
            focusNode.previousFocus();
          } else if (int.parse(coinController.text) > 10000) {
            AppUtils.showErrorSnackBar(
              bodyText: "You can not add more than 10000 points",
            );
            autoCompleteFieldController.clear();
            coinController.clear();
            focusNode.previousFocus();
          } else {
            if (spdptpList.isEmpty) {
              AppUtils.showErrorSnackBar(
                bodyText:
                    "Please enter valid ${gameMode.value.name!.toLowerCase()}",
              );
            } else {
              for (var i = 0; i < spdptpList.length; i++) {
                addedNormalBidValue = spdptpList[i].toString();
                var existingIndex = selectedBidsList.indexWhere(
                    (element) => element.bidNo == addedNormalBidValue);
                if (existingIndex != -1) {
                  // If the bidNo already exists in selectedBidsList, update coins value.
                  selectedBidsList[existingIndex].coins =
                      (selectedBidsList[existingIndex].coins! +
                          int.parse(coinController.text));
                } else {
                  selectedBidsList.insert(
                    0,
                    Bids(
                      bidNo: addedNormalBidValue,
                      coins: int.parse(coinController.text),
                      gameId: gameMode.value.id,
                      subGameId: gameMode.value.id,
                      gameModeName: gameMode.value.name,
                      remarks:
                          "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
                    ),
                  );
                }
              }
              autoCompleteFieldController.clear();
              coinController.clear();
              selectedBidsList.refresh();
            }
            _calculateTotalAmount();
          }
        } else {
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        }
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
        focusNode.previousFocus();
      },
    );
    // }
  }

//   Future<Map> panelGroupBody() async {
//     final a = {
//       "pana": autoCompleteFieldController.text,
//     };
//     return a;
//   }

//   void getpanelData() async {
//     ApiService().newGameModeApi(await panelGroupBody(), apiUrl).then(
//       (value) async {
//         debugPrint("Forgot MPIN Api Response :- $value");
//         if (value['status']) {
//           spdptpList = value['data'];
//           if (coinController.text.trim().isEmpty ||
//               int.parse(coinController.text.trim()) < 1) {
//             AppUtils.showErrorSnackBar(
//               bodyText: "Please enter valid points",
//             );
//             return;
//           } else if (int.parse(coinController.text) > 10000) {
//             AppUtils.showErrorSnackBar(
//               bodyText: "You can not add more than 10000 points",
//             );
//             return;
//           } else if (autoCompleteFieldController.text.trim().isEmpty) {
//             AppUtils.showErrorSnackBar(
//               bodyText: "Please enter ${gameMode.value.name!.toLowerCase()}",
//             );
//             return;
//           } else {
//             if (spdptpList.isEmpty) {
//               for (var i = 0; i < spdptpList.length; i++) {
//                 selectedBidsList.add(
//                   Bids(
//                     bidNo: spdptpList[i].toString(),
//                     coins: int.parse(coinController.text),
//                     gameId: gameMode.value.id,
//                     subGameId: gameMode.value.id,
//                     gameModeName: gameMode.value.name,
//                     remarks:
//                         "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
//                   ),
//                 );
//               }
//               focusNode.previousFocus();
//               autoCompleteFieldController.clear();
//               coinController.clear();
//               selectedBidsList.refresh();
//             } else {
//               for (var i = 0; i < spdptpList.length; i++) {
//                 selectedBidsList.add(
//                   Bids(
//                     bidNo: spdptpList[i].toString(),
//                     coins: int.parse(coinController.text),
//                     gameId: gameMode.value.id,
//                     subGameId: gameMode.value.id,
//                     gameModeName: gameMode.value.name,
//                     remarks:
//                         "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
//                   ),
//                 );
//               }
//             }
//           }
//           _calculateTotalAmount();
//           selectedBidsList.refresh();
//         } else {
//           AppUtils.showErrorSnackBar(
//             bodyText: value['message'] ?? "",
//           );
//         }
//         autoCompleteFieldController.clear();
//         coinController.clear();
//         selectedBidsList.refresh();
//         focusNode.previousFocus();
//       },
//     );
//   }

//   Future<Map> spMotorBody() async {
//     final a = {
//       "digit": autoCompleteFieldController.text,
//     };
//     return a;
//   }

//   void spMotorData() async {
//     ApiService().newGameModeApi(await spMotorBody(), apiUrl).then(
//       (value) async {
//         debugPrint("Forgot MPIN Api Response :- $value");
//         if (value['status']) {
//           spdptpList = value['data'];
//           if (spdptpList.isEmpty) {
//           } else {
//             for (var i = 0; i < spdptpList.length; i++) {
//               print(spdptpList[i].toString());
//               selectedBidsList.add(
//                 Bids(
//                   bidNo: spdptpList[i].toString(),
//                   coins: int.parse(coinController.text),
//                   gameId: gameMode.value.id,
//                   subGameId: gameMode.value.id,
//                   gameModeName: gameMode.value.name,
//                   remarks:
//                       "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
//                 ),
//               );
//             }
//             print("===== selectedBidsList =======");
//             print(selectedBidsList.toJson());
//           }
//           // print(spdptpList);
//         } else {
//           AppUtils.showErrorSnackBar(
//             bodyText: value['message'] ?? "",
//           );
//         }
//       },
//     );
//   }

//   Future<Map> dpMotorBody() async {
//     final a = {
//       "digit": autoCompleteFieldController.text,
//     };
//     return a;
//   }

//   void dpMotorData() async {
//     ApiService().newGameModeApi(await dpMotorBody(), apiUrl).then(
//       (value) async {
//         debugPrint("Forgot MPIN Api Response :- $value");
//         if (value['status']) {
//           spdptpList = value['data'];

//           if (spdptpList.isEmpty) {
//             print("===== spdptpList empty =================");
//             print(spdptpList);
//           } else {
//             print("======= List not empty =====");
//             // print(spdptpList);
//             for (var i = 0; i < spdptpList.length; i++) {
// // spdptpList[i].toString() pass this value in one fiunction which returm the type of the pana

// // gameId
// // Main game modes
// // Single Ank, Jodi, Single Pana, Double Pana, Triple Pana
// // Single Ank, Jodi,  Single Pana, Double Pana, ==> Bulk
// // make once fucntion which takes  child game modes name and will return parent game modes with Id == GameId
// // Panel Group, SDDPTP, Red Brackets, Choice Pana SPDP, SP Moter, DP Moter, Group Jodi, Digit Based Jodi,
// // Odd Even
// // make One function which will take pana as a parameter and will return pana type with parent game
// // mode name ==? Sub game mode Id
//               print(spdptpList[i].toString());
//               selectedBidsList.add(
//                 Bids(
//                   bidNo: spdptpList[i].toString(),
//                   coins: int.parse(coinController.text),
//                   gameId: gameMode.value.id,
//                   subGameId: gameMode.value.id,
//                   gameModeName: gameMode.value.name,
//                   remarks:
//                       "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
//                 ),
//               );
//             }
//             print("===== selectedBidsList =======");
//             print(selectedBidsList.toJson());
//           }
//           // print(spdptpList);
//         } else {
//           AppUtils.showErrorSnackBar(
//             bodyText: value['message'] ?? "",
//           );
//         }
//       },
//     );
//   }

//   Future<Map> toDigitBody() async {
//     final a = {
//       "digit": autoCompleteFieldController.text,
//     };
//     return a;
//   }

//   void twoDigitData() async {
//     ApiService().newGameModeApi(await toDigitBody(), apiUrl).then(
//       (value) async {
//         debugPrint("Forgot MPIN Api Response :- $value");
//         if (value['status']) {
//           spdptpList = value['data'];

//           if (spdptpList.isEmpty) {
//             selectedBidsList.add(
//               Bids(
//                 bidNo: addedNormalBidValue,
//                 coins: int.parse(coinController.text),
//                 gameId: gameMode.value.id,
//                 subGameId: gameMode.value.id,
//                 gameModeName: gameMode.value.name,
//                 remarks:
//                     "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
//               ),
//             );
//           } else {
//             print("======= List not empty =====");
//             // print(spdptpList);
//             for (var i = 0; i < spdptpList.length; i++) {
// // spdptpList[i].toString() pass this value in one fiunction which returm the type of the pana

// // gameId
// // Main game modes
// // Single Ank, Jodi, Single Pana, Double Pana, Triple Pana
// // Single Ank, Jodi,  Single Pana, Double Pana, ==> Bulk
// // make once fucntion which takes  child game modes name and will return parent game modes with Id == GameId
// // Panel Group, SDDPTP, Red Brackets, Choice Pana SPDP, SP Moter, DP Moter, Group Jodi, Digit Based Jodi,
// // Odd Even
// // make One function which will take pana as a parameter and will return pana type with parent game
// // mode name ==? Sub game mode Id
//               //   print(gameModeList[0].data?.gameMode?[0].id);
//               selectedBidsList.add(
//                 Bids(
//                   bidNo: spdptpList[i].toString(),
//                   coins: int.parse(coinController.text),
//                   gameId: gameMode.value.id,
//                   subGameId: gameMode.value.id,
//                   gameModeName: gameMode.value.name,
//                   remarks:
//                       "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
//                 ),
//               );
//             }
//             print("===== selectedBidsList =======");
//             //  print(selectedBidsList.toJson());
//           }
//           // print(spdptpList);
//         } else {
//           AppUtils.showErrorSnackBar(
//             bodyText: value['message'] ?? "",
//           );
//         }
//       },
//     );
//   }

//   Future<Map> groupJodiBody() async {
//     final a = {
//       "digit": autoCompleteFieldController.text,
//     };
//     return a;
//   }

//   void groupJodiData() async {
//     ApiService().newGameModeApi(await groupJodiBody(), apiUrl).then(
//       (value) async {
//         debugPrint("Forgot MPIN Api Response :- $value");
//         if (value['status']) {
//           spdptpList = value['data'];
//           if (spdptpList.isEmpty) {
//             print("===== spdptpList empty =================");
//             print(spdptpList);
//           } else {
//             print("======= List not empty =====");
//             // print(spdptpList);
//             for (var i = 0; i < spdptpList.length; i++) {
//               print(spdptpList[i].toString());
//               selectedBidsList.add(
//                 Bids(
//                   bidNo: spdptpList[i].toString(),
//                   coins: int.parse(coinController.text),
//                   gameId: gameMode.value.id,
//                   subGameId: gameMode.value.id,
//                   gameModeName: gameMode.value.name,
//                   remarks:
//                       "You invested At ${marketName.value} on $addedNormalBidValue (${gameMode.value.name})",
//                 ),
//               );
//             }
//             print("===== selectedBidsList =======");
//           }
//           // print(spdptpList);
//         } else {
//           AppUtils.showErrorSnackBar(
//             bodyText: value['message'] ?? "",
//           );
//         }
//       },
//     );
  // }
}
