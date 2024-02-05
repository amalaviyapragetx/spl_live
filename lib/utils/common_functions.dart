import 'package:flutter/material.dart';
import 'package:spllive/helper_files/ui_utils.dart';

class CommonFunction {
  List<String> getChoicePanaSPDPTP({
    required String leftAnkController,
    required String middleAnkController,
    required String rightAnkController,
    required List<String> selectedList,
    required Map<String, List<String>> choicePanaSPDPTP,
  }) {
    String? middle = middleAnkController;
    String? left = leftAnkController;
    String? last = rightAnkController;
    List<String> panaType = selectedList;
    List<String> panaArray = [];
    for (int i = 0; i < panaType.length; i++) {
      List<String>? data = choicePanaSPDPTP[panaType[i]];
      if (data != null) {
        panaArray.addAll(data);
      } else {
        debugPrint("Error");
      }
    }
    var a = panaArray.where((num1) {
      return matchesDigits(num1, left: left, middle: middle, last: last);
    }).toList();
    return a;
  }

  bool matchesDigits(String num, {String? left, String? middle, String? last}) {
    if ((left!.isNotEmpty && num[0] != left)) {
      return false;
    } else if (((middle!.isNotEmpty && num[num.length ~/ 2] != middle))) {
      return false;
    } else if ((last!.isNotEmpty && num[num.length - 1] != last)) {
      return false;
    }
    return true;
  }

  /// add Button DigitBasedJodi
  List<String> digitBasedJodiFilter({
    required String leftAnkController,
    required String rightAnkController,
    required List<String> digitBasedJodi,
  }) {
    String? left = leftAnkController;
    String? right = rightAnkController;
    List<String> result = [];
    List<String> jodiArray = digitBasedJodi;
    bool startsWithLeft(String num) => num.startsWith(left);
    bool endsWithRight(String num) => num.endsWith(right);
    if (right.isNotEmpty) {
      result = jodiArray.where((n) => startsWithLeft(n)).toList();
      result.sort((a, b) => b.compareTo(a)); // Sort in descending order for strings.
    } else if (left.isNotEmpty) {
      result = jodiArray.where((n) => endsWithRight(n)).toList();
      result.sort((a, b) => b.compareTo(a)); // Sort in descending order for strings.
    } else if (left.isNotEmpty && right.isNotEmpty) {
      List<String> leftList = jodiArray.where((n) => endsWithRight(n)).toList();
      leftList.sort((a, b) => b.compareTo(a)); // Sort in descending order for strings.
      List<String> rightList = jodiArray.where((n) => startsWithLeft(n)).toList();
      rightList.sort((a, b) => b.compareTo(a)); // Sort in descending order for strings.
      result = [...leftList, ...rightList];
    }
    return result;
  }

// groupJodi
  List<String> groupJodi({required String stringToFind, required List<String> groupList}) {
    print(groupList);
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

  List<String> getPanelGroupPana({
    required int pana,
    required Map<int, String> digitsPanel,
    required Map<String, List<List<String>>> panelGroupChart,
  }) {
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

  List<String> getSPMotorPana({
    required int inputNum,
    required List<String> spdpMotor,
    required String gameModeName,
  }) {
    if (inputNum.toString().length >= 4 && inputNum.toString().length <= 10) {
      List<String> panaArray = spdpMotor;

      List<String> inputDigits = inputNum.toString().split('');
      List<String> matchingElements = [];

      for (String element in panaArray) {
        List<String> elementDigits = element.toString().split('');

        bool tempBool = true;
        for (int i = 0; i < elementDigits.length; i++) {
          if (!inputDigits.contains(elementDigits[i])) {
            tempBool = false;
          }
        }
        if (tempBool) {
          matchingElements.add(element);
        }
      }
      return matchingElements;
    } else {
      AppUtils.showErrorSnackBar(
        bodyText: "Please enter valid ${gameModeName.toLowerCase()}",
      );
      return [];
    }
  }

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

  List<String> getSPDPTPPana({
    required int singleAnk,
    required Map<String, dynamic> spdptplistFromModel,
    required List<String> selectedValues,
  }) {
    List<String> pana = [];
    var result = spdptplistFromModel[digitsForSPDPTP[singleAnk]];
    for (int i = 0; i < selectedValues.length; i++) {
      List<String> data = result[selectedValues[i]];
      for (int j = 0; j < data.length; j++) {
        pana.add(data[j]);
      }
    }
    return pana;
  }

  List<String> getTwoDigitPanelPana({
    required int inputNumber,
    required String gameModeName,
    required List<String> spdpMotor,
  }) {
    List<int> inputDigits = inputNumber.toString().split('').map(int.parse).toList();
    if (inputNumber.toString().length != 2) {
      AppUtils.showErrorSnackBar(
        bodyText: "Please enter valid ${gameModeName.toLowerCase()}",
      );
      return [];
    } else {
      bool containsBothInputDigits(String num) {
        String numStr = num.toString();
        return inputDigits.every((digit) => numStr.contains(digit.toString()));
      }

      print(
          "${spdpMotor.where(containsBothInputDigits).toList()} ${spdpMotor.where(containsBothInputDigits).toList().length}");
      return spdpMotor.where(containsBothInputDigits).toList();
    }
  }
}
