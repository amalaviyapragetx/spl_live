import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../Custom Controllers/wallet_controller.dart';
import '../../../api_services/api_service.dart';
import '../../../api_services/api_urls.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/commun_models/json_file_model.dart';
import '../../../models/commun_models/starline_bid_request_model.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/starline_daily_market_api_response.dart';
import '../../../models/starline_game_modes_api_response_model.dart';
import '../../../routes/app_routes_name.dart';
import '../../Local Storage.dart';

class StarlineNewGamePageController extends GetxController {
  Rx<StarLineGameMod> gameMode = StarLineGameMod().obs;
  Rx<StarlineMarketData> marketData = StarlineMarketData().obs;
  RxString totalAmount = "00".obs;
  var getBIdType = "";
  bool getBidData = false;
  var argument = Get.arguments;
  JsonFileModel jsonModel = JsonFileModel();
  String spValue = "SP";
  String dpValue = "DP";
  String tpValue = "TP";
  RxBool spValue1 = false.obs;
  RxBool dpValue2 = false.obs;
  RxBool tpValue3 = false.obs;
  List<String> selectedValues = [];
  var coinController = TextEditingController();
  TextEditingController autoCompleteFieldController = TextEditingController();
  late FocusNode focusNode;
  Timer? _debounce;
  bool enteredDigitsIsValidate = false;
  String addedNormalBidValue = "";
  RxInt panaControllerLength = 2.obs;
  Rx<StarlineBidRequestModel> requestModel = StarlineBidRequestModel().obs;
//  Rx<StarlineMarketData> marketData = StarlineMarketData().obs;
  RxBool isBulkMode = false.obs;
  var spdptpList = [];
  var selectedBidsList = <StarLineBids>[].obs;
  var marketName = "".obs;
  List<String> _validationListForNormalMode = [];
  var apiUrl = "";
  RxBool oddbool = true.obs;
  RxBool evenbool = false.obs;
  var leftAnkController = TextEditingController();
  var rightAnkController = TextEditingController();
  var middleAnkController = TextEditingController();
  var gameModeName = "";
  final FocusNode leftFocusNode = FocusNode();
  final FocusNode middleFocusNode = FocusNode();
  final FocusNode rightFocusNode = FocusNode();
  final FocusNode coinFocusNode = FocusNode();
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

  @override
  void onInit() {
    getArguments();
    super.onInit();
    focusNode = FocusNode();
  }

  @override
  void onClose() {
    requestModel.value.bids?.clear();
    selectedBidsList.clear();
  }

  @override
  void dispose() {
    leftAnkController.dispose();
    rightAnkController.dispose();
    middleAnkController.dispose();
    coinController.dispose();
    super.dispose();
  }

  checkType(index) {
    if (gameModeName.contains("Ank") || gameModeName.contains("Odd")) {
      return "Ank";
    } else {
      return "Pana";
    }
  }

  void validateEnteredDigit(bool validate, String value) {
    enteredDigitsIsValidate = validate;
    addedNormalBidValue = value;
    if (value.length == panaControllerLength.value) {
      if (gameMode.value.name!.toUpperCase() == "CHOICE PANA SPDP") {
        coinFocusNode.nextFocus();
        leftFocusNode.requestFocus();
      } else {
        focusNode.nextFocus();
      }
    }
  }

  ondebounce(bool validate, String value) {
    if (_debounce != null && _debounce!.isActive) {
      _debounce!.cancel();
    }
    Timer(const Duration(milliseconds: 10), () {
      enteredDigitsIsValidate = validate;
      addedNormalBidValue = value;
      newGamemodeValidation(validate, value);
    });
  }

  newGamemodeValidation(bool validate, String value) {
    if (value.length == panaControllerLength.value) {
      focusNode.nextFocus();
    } else if (gameMode.value.name == "Red Brackets") {
      if (autoCompleteFieldController.text.length < 2) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter ${gameMode.value.name!.toLowerCase()}",
        );
      }
    } else if (gameMode.value.name == "SPDPTP") {
      if (spValue1.value == false &&
          dpValue2.value == false &&
          tpValue3.value == false) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please select SP,DP or TP",
        );
      } else if (autoCompleteFieldController.text.isEmpty) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter ${gameMode.value.name!.toLowerCase()}",
        );
      }
    }
    enteredDigitsIsValidate = validate;
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

  onTapAddOddEven() {
    for (var i = 0; i < 10; i++) {
      var bidNo = i.toString();
      var existingIndex =
          selectedBidsList.indexWhere((element) => element.bidNo == bidNo);
      var coins = int.parse(coinController.text);
      if (oddbool.value) {
        if (i % 2 != 0) {
          if (existingIndex != -1) {
            // If the bidNo already exists in selectedBidsList, update coins value.
            selectedBidsList[existingIndex].coins =
                (selectedBidsList[existingIndex].coins! + coins);
          } else {
            // If bidNo doesn't exist in selectedBidsList, add a new entry.
            selectedBidsList.add(
              StarLineBids(
                bidNo: bidNo,
                coins: coins,
                starlineGameId: gameMode.value.id,
                remarks:
                    "You invested At ${marketData.value.time} on $bidNo (${gameMode.value.name})",
              ),
            );
          }
          // selectedBidsList.add(
          //   StarLineBids(
          //     bidNo: i.toString(),
          //     coins: int.parse(coinController.text),
          //     starlineGameId: gameMode.value.id,
          //     //  gameModeName: gameMode.value.name,
          //     // subGameId: checkPanaType(),
          //     remarks:
          //         "You invested At ${marketName.value} on $i (${gameMode.value.name})",
          //   ),
          // );
        }
      } else {
        if (i % 2 == 0) {
          if (existingIndex != -1) {
            // If the bidNo already exists in selectedBidsList, update coins value.
            selectedBidsList[existingIndex].coins =
                (selectedBidsList[existingIndex].coins! + coins);
          } else {
            // If bidNo doesn't exist in selectedBidsList, add a new entry.
            selectedBidsList.add(
              StarLineBids(
                bidNo: bidNo,
                coins: coins,
                starlineGameId: gameMode.value.id,
                remarks:
                    "You invested At ${marketData.value.time} on $bidNo (${gameMode.value.name})",
              ),
            );
          }
          // selectedBidsList.add(
          //   StarLineBids(
          //     bidNo: i.toString(),
          //     coins: int.parse(coinController.text),
          //     starlineGameId: gameMode.value.id,
          //     // gameModeName: gameMode.value.name,
          //     // subGameId: checkPanaType(),
          //     remarks:
          //         "You invested At ${marketName.value} on $i (${gameMode.value.name})",
          //   ),
          // );
        }
      }
    }
    //autoCompleteFieldController.clear();
    coinController.clear();
    selectedBidsList.refresh();
    _calculateTotalAmount();
    //  focusNode.previousFcus();
  }

  RxList<StarLineGameMod> gameModesList = <StarLineGameMod>[].obs;
  void createMarketBidApi() async {
    print(marketData.value);
    ApiService()
        .createStarLineMarketBid(requestModel.value.toJson())
        .then((value) async {
      debugPrint("create starline bid api response :- $value");
      if (value['status']) {
        selectedBidsList.clear();
        print(
            "== From Starline ===================================$gameModeName");
        print(marketData.value.toJson());
        print(gameMode.value.toJson());
        Get.offAllNamed(
          AppRoutName.starLineGameModesPage, arguments: marketData.value,
          // "gameMode": gameMode.value,
          // "getBidData": getBidData,
          // "getBIdType": getBIdType,
          // "gameModeName": gameModeName
        );
        if (value['data'] == false) {
          selectedBidsList.clear();
          Get.offAllNamed(
            AppRoutName.starLineGameModesPage, arguments: marketData.value,
            // "gameMode": gameMode.value,
            // "getBidData": getBidData,
            // "getBIdType": getBIdType,
            // "gameModeName": gameModeName
          );
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        } else {
          AppUtils.showSuccessSnackBar(
              bodyText: value['message'] ?? "",
              headerText: "SUCCESSMESSAGE".tr);
        }
        LocalStorage.remove(ConstantsVariables.bidsList);
        LocalStorage.remove(ConstantsVariables.marketName);
        LocalStorage.remove(ConstantsVariables.biddingType);
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

  Future<void> loadJsonFile() async {
    final String response =
        await rootBundle.loadString('assets/JSON File/digit_file.json');
    final data = await json.decode(response);
    jsonModel = JsonFileModel.fromJson(data);
  }

  Future<void> getArguments() async {
    print("****************************************************************");
    gameModeName = argument['gameModeName'];
    gameMode.value = argument['gameMode'];
    marketData.value = argument['marketData'];
    requestModel.value.bids = argument['bidsList'];
    print("req model : ${requestModel.value.toJson()}");
    requestModel.refresh();
    print(
        "****************************************************************${marketData.value}");
    _calculateTotalAmount();
    requestModel.value.dailyStarlineMarketId = marketData.value.id;
    var data = await LocalStorage.read(ConstantsVariables.userData);
    UserDetailsModel userData = UserDetailsModel.fromJson(data);
    requestModel.value.userId = userData.id;
    print(requestModel.value.toJson());
    print(getBIdType);
    await loadJsonFile();
    List<String> _tempValidationList = [];
    switch (gameMode.value.name) {
      case "Single Ank":
        enteredDigitsIsValidate = true;
        panaControllerLength.value = 1;
        _tempValidationList = jsonModel.singleAnk!;
        break;
      case "Single Pana":
        print(
            "################################################################${panaControllerLength.value}");
        panaControllerLength.value = 3;
        print(
            "################################################################${panaControllerLength.value}");
        _tempValidationList = jsonModel.allSinglePana!;
        break;
      case "Double Pana":
        panaControllerLength.value = 3;
        print(
            "################################################################${panaControllerLength.value}");
        _tempValidationList = jsonModel.allDoublePana!;
        break;
      case "Tripple Pana":
        panaControllerLength.value = 3;
        print(
            "################################################################${panaControllerLength.value}");
        _tempValidationList = jsonModel.triplePana!;
        break;
      case "Panel Group":
        panaControllerLength.value = 3;
        panelGroupChart = jsonModel.panelGroupChart!;
        // _tempValidationList = jsonModel.allThreePana!;
        apiUrl = ApiUtils.panelGroup;
        break;
      case "SPDPTP":
        panaControllerLength.value = 1;
        _tempValidationList = jsonModel.singleAnk!;
        apiUrl = ApiUtils.spdptp;
        break;
      case "Choice Pana SPDP":
        panaControllerLength.value = 1;
        apiUrl = ApiUtils.choicePanaSPDP;
        _tempValidationList = jsonModel.singleAnk!;
        break;
      case "SP Motor":
        panaControllerLength.value = 10;
        print("==============================spdptp");
        apiUrl = ApiUtils.spMotor;
        break;
      case "DP Motor":
        panaControllerLength.value = 10;
        apiUrl = ApiUtils.dpMotor;
        break;
      case "Odd Even":
        panaControllerLength.value = 1;
        _tempValidationList = jsonModel.singleAnk!;
        break;
      case "Two Digits Panel":
        apiUrl = ApiUtils.towDigitJodi;

        panaControllerLength.value = 2;
        break;
    }
    _validationListForNormalMode.addAll(_tempValidationList);
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

  void _calculateTotalAmount() {
    var tempTotal = 0;
    for (var element in selectedBidsList) {
      tempTotal += element.coins ?? 0;
    }
    totalAmount.value = tempTotal.toString();
  }

  void onDeleteBids(int index) {
    selectedBidsList.remove(selectedBidsList[index]);
    // LocalStorage.write(ConstantsVariables.bidsList,
    //     requestModel.value.bids!.map((v) => v.toJson()).toList());
    selectedBidsList.refresh();
    _calculateTotalAmount();
  }

  void onTapOfAddButton() {
    // FocusManager.instance.primaryFocus?.unfocus();
    isBulkMode.value = false;
    print(requestModel.value.dailyStarlineMarketId);
    if (!isBulkMode.value) {
      if (_validationListForNormalMode.contains(addedNormalBidValue) == false) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
        );
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
        focusNode.previousFocus();
      } else if (coinController.text.trim().isEmpty ||
          int.parse(coinController.text.trim()) < 1) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid points",
        );
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
        focusNode.previousFocus();
      } else if (int.parse(coinController.text) > 10000) {
        AppUtils.showErrorSnackBar(
          bodyText: "You can not add more than 10000 points",
        );
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
        focusNode.previousFocus();
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
            // If bidNo doesn't exist in selectedBidsList, add a new entry.
            selectedBidsList.add(
              StarLineBids(
                bidNo: addedNormalBidValue,
                coins: int.parse(coinController.text),
                starlineGameId: gameMode.value.id,
                remarks:
                    "You invested At ${marketData.value.time} on $addedNormalBidValue (${gameMode.value.name})",
              ),
            );
          }
        } else {
          var existingIndex = selectedBidsList
              .indexWhere((element) => element.bidNo == addedNormalBidValue);
          if (existingIndex != -1) {
            // If the bidNo already exists in selectedBidsList, update coins value.
            selectedBidsList[existingIndex].coins =
                (selectedBidsList[existingIndex].coins! +
                    int.parse(coinController.text));
          } else {
            // If bidNo doesn't exist in selectedBidsList, add a new entry.
            selectedBidsList.add(
              StarLineBids(
                bidNo: addedNormalBidValue,
                coins: int.parse(coinController.text),
                starlineGameId: gameMode.value.id,
                remarks:
                    "You invested At ${marketData.value.time} on $addedNormalBidValue (${gameMode.value.name})",
              ),
            );
          }
        }
        print("===== selectedBidsList =======");
        // print(selectedBidsList.toList());
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
        autoCompleteFieldController.clear();
        coinController.clear();
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
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
        focusNode.previousFocus();
      } else {
        var existingIndex = selectedBidsList
            .indexWhere((element) => element.bidNo == addedNormalBidValue);
        if (existingIndex != -1) {
          // If the bidNo already exists in selectedBidsList, update coins value.
          selectedBidsList[existingIndex].coins =
              (selectedBidsList[existingIndex].coins! +
                  int.parse(coinController.text));
        } else {
          // If bidNo doesn't exist in selectedBidsList, add a new entry.
          selectedBidsList.add(
            StarLineBids(
              bidNo: addedNormalBidValue,
              coins: int.parse(coinController.text),
              starlineGameId: gameMode.value.id,
              remarks:
                  "You invested At ${marketData.value.time} on $addedNormalBidValue (${gameMode.value.name})",
            ),
          );
        }
        print("selectebidlist : $selectedBidsList");
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
      }
    }
  }

  Future<Map> spdptpbody() async {
    String panaType = selectedValues.join(',');
    print(panaType);
    final a = {"digit": autoCompleteFieldController.text, "panaType": panaType};
    final b = {"pana": autoCompleteFieldController.text};
    final c = {
      "left": leftAnkController.text,
      "middle": middleAnkController.text,
      "right": rightAnkController.text,
      "panaType": panaType,
    };
    if (gameMode.value.name == "Panel Group") {
      return b;
    } else if (gameMode.value.name!.toUpperCase() == "CHOICE PANA SPDP") {
      return c;
    } else {
      return a;
    }
  }

  void panelGroup() {
    if (coinController.text.trim().isEmpty ||
        int.parse(coinController.text.trim()) < 1) {
      AppUtils.showErrorSnackBar(
        bodyText: "Please enter valid points",
      );
      autoCompleteFieldController.clear();
      coinController.clear();
      selectedBidsList.refresh();
      focusNode.previousFocus();
    } else if (int.parse(coinController.text) > 10000) {
      AppUtils.showErrorSnackBar(
        bodyText: "You can not add more than 10000 points",
      );
      autoCompleteFieldController.clear();
      coinController.clear();
      selectedBidsList.refresh();
      focusNode.previousFocus();
    } else {
      spdptpList =
          getPanelGroupPana(int.parse(autoCompleteFieldController.text));
      if (spdptpList.isEmpty) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please enter valid ${gameMode.value.name!.toLowerCase()}",
        );
        autoCompleteFieldController.clear();
        coinController.clear();
        selectedBidsList.refresh();
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
            // If bidNo doesn't exist in selectedBidsList, add a new entry.
            selectedBidsList.add(
              StarLineBids(
                bidNo: addedNormalBidValue,
                coins: int.parse(coinController.text),
                starlineGameId: gameMode.value.id,
                remarks:
                    "You invested At ${marketData.value.time} on ${spdptpList[i]} (${gameMode.value.name})",
              ),
            );
          }
        }
      }
      _calculateTotalAmount();
    }
  }

  void getspdptp() async {
    if (gameMode.value.name == "Choice Pana SPDP") {
      if (spValue1.value == false &&
          dpValue2.value == false &&
          tpValue3.value == false) {
        AppUtils.showErrorSnackBar(
          bodyText: "Please select SP,DP or TP",
        );
      } else {
        ApiService().newGameModeApi(await spdptpbody(), apiUrl).then(
          (value) async {
            debugPrint("New Game-Mode Api Response :- $value");
            if (value['status']) {
              spdptpList = value['data'];
              if (coinController.text.trim().isEmpty ||
                  int.parse(coinController.text.trim()) < 1) {
                AppUtils.showErrorSnackBar(
                  bodyText: "Please enter valid points",
                );
                autoCompleteFieldController.clear();
                coinController.clear();
                selectedBidsList.refresh();
                coinFocusNode.nextFocus();
                leftFocusNode.requestFocus();
              } else if (int.parse(coinController.text) > 10000) {
                AppUtils.showErrorSnackBar(
                  bodyText: "You can not add more than 10000 points",
                );
                autoCompleteFieldController.clear();
                coinController.clear();
                selectedBidsList.refresh();
                coinFocusNode.nextFocus();
                leftFocusNode.requestFocus();
              } else {
                if (spdptpList.isEmpty) {
                  AppUtils.showErrorSnackBar(
                    bodyText:
                        "Please enter valid ${gameMode.value.name!.toLowerCase()}",
                  );
                  autoCompleteFieldController.clear();
                  coinController.clear();
                  selectedBidsList.refresh();
                  coinFocusNode.nextFocus();
                  leftFocusNode.requestFocus();
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
                      // If bidNo doesn't exist in selectedBidsList, add a new entry.
                      selectedBidsList.add(
                        StarLineBids(
                          bidNo: addedNormalBidValue,
                          coins: int.parse(coinController.text),
                          starlineGameId: gameMode.value.id,
                          remarks:
                              "You invested At ${marketData.value.time} on ${spdptpList[i]} (${gameMode.value.name})",
                        ),
                      );
                    }
                  }
                }
                _calculateTotalAmount();
              }
            } else {
              AppUtils.showErrorSnackBar(
                bodyText: value['message'] ?? "",
              );
            }
            autoCompleteFieldController.clear();
            leftAnkController.clear();
            rightAnkController.clear();
            middleAnkController.clear();
            coinController.clear();
            selectedBidsList.refresh();
            coinFocusNode.nextFocus();
            leftFocusNode.requestFocus();
          },
        );
      }
    } else {
      ApiService().newGameModeApi(await spdptpbody(), apiUrl).then(
        (value) async {
          debugPrint("New Game-Mode Api Response :- $value");
          if (value['status']) {
            spdptpList = value['data'];
            if (coinController.text.trim().isEmpty ||
                int.parse(coinController.text.trim()) < 1) {
              AppUtils.showErrorSnackBar(
                bodyText: "Please enter valid points",
              );
              autoCompleteFieldController.clear();
              coinController.clear();
              selectedBidsList.refresh();
              focusNode.previousFocus();
            } else if (int.parse(coinController.text) > 10000) {
              AppUtils.showErrorSnackBar(
                bodyText: "You can not add more than 10000 points",
              );
              autoCompleteFieldController.clear();
              coinController.clear();
              selectedBidsList.refresh();
              focusNode.previousFocus();
            } else {
              if (spdptpList.isEmpty) {
                AppUtils.showErrorSnackBar(
                  bodyText:
                      "Please enter valid ${gameMode.value.name!.toLowerCase()}",
                );
                autoCompleteFieldController.clear();
                coinController.clear();
                selectedBidsList.refresh();
                focusNode.previousFocus();
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
                    // If bidNo doesn't exist in selectedBidsList, add a new entry.
                    selectedBidsList.add(
                      StarLineBids(
                        bidNo: addedNormalBidValue,
                        coins: int.parse(coinController.text),
                        starlineGameId: gameMode.value.id,
                        remarks:
                            "You invested At ${marketData.value.time} on ${spdptpList[i]} (${gameMode.value.name})",
                      ),
                    );
                  }
                }
              }
              _calculateTotalAmount();
            }
          } else {
            AppUtils.showErrorSnackBar(
              bodyText: value['message'] ?? "",
            );
          }
          autoCompleteFieldController.clear();
          leftAnkController.clear();
          rightAnkController.clear();
          middleAnkController.clear();
          coinController.clear();
          selectedBidsList.refresh();
          focusNode.previousFocus();
        },
      );
    }
  }
}
