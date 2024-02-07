import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../../../api_services/api_service.dart';
import '../../../components/DeviceInfo/device_info.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../models/location_models/location_model.dart';
import '../../Local Storage.dart';

class MPINPageController extends GetxController {
  StreamController<ErrorAnimationType> mpinErrorController = StreamController<ErrorAnimationType>();
  RxString mpin = "".obs;
  RxString street = ''.obs;
  RxString postalCode = ''.obs;
  var arguments = Get.arguments;

  var userId = "";
  RxString city = ''.obs;
  RxString country = ''.obs;
  RxString state = ''.obs;
  RxString ip = ''.obs;
  @override
  void onInit() async {
    super.onInit();
    getPublicIpAddress();
    await LocalStorage.write(ConstantsVariables.starlineConnect, false);
    await LocalStorage.write(ConstantsVariables.timeOut, false);
    await LocalStorage.write(ConstantsVariables.mPinTimeOut, true);
    userId = arguments['id'].toString();
    getLocationsData();
  }

  void onCompleteMPIN() {
    if (mpin.isEmpty || mpin.value.length < 4) {
      mpinErrorController.add(ErrorAnimationType.shake);
    } else {
      if (city.isEmpty && country.isEmpty && state.isEmpty) {
        verifyMPIN();
      } else {
        verifyMPIN();
      }
    }
  }

  void verifyMPIN() async {
    ApiService().verifyMPIN({
      "id": userId,
      "mPin": mpin.value,
      "deviceId": DeviceInfo.deviceId,
      "city": city.value,
      "country": country.value,
      "state": state.value,
      "street": street.value,
      "postalCode": postalCode.value,
      "ipAddress": ip.value
    }).then((value) async {
      if (value != null && value['status']) {
        // AppUtils.showSuccessSnackBar(
        //   bodyText: "${value['message']}",
        //   headerText: "SUCCESSMESSAGE".tr,
        // );
        var userData = value['data'];
        if (userData != null) {
          String authToken = userData['Token'] ?? "Null From API";
          await LocalStorage.write(ConstantsVariables.authToken, authToken);
        } else {
          AppUtils.showErrorSnackBar(bodyText: "Something went wrong!!!");
        }
        Get.offAllNamed(AppRoutName.dashBoardPage);
      } else {
        mpinErrorController.add(ErrorAnimationType.shake);
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  Future<String?> getPublicIpAddress() async {
    try {
      final response = await GetConnect(timeout: const Duration(seconds: 15)).get('https://api.ipify.org?format=json');
      if (response.statusCode == 200) {
        final data = response.body['ip'];
        ip.value = data;
        return data;
      } else {
        throw Exception('Failed to load IP address');
      }
    } catch (e) {
      print('Error fetching IP address: $e');
      return null;
    }
  }

  void forgotMPINApi() async {
    ApiService().forgotMPIN().then((value) async {
      if (value['status']) {
        Get.toNamed(AppRoutName.verifyOTPPage);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  getLocationsData() async {
    final locationData = await GetStorage().read(ConstantsVariables.locationData) ?? [];
    // getMarketBidsByUserId(lazyLoad: false);
    if (locationData != null) {
      List list = [];
      list.add(locationData[0]['location']);
      List<LocationModel> data = LocationModel.fromJsonList(list);
      city.value = data[0].city ?? 'Unknown';
      country.value = data[0].country ?? 'Unknown';
      state.value = data[0].state ?? 'Unknown';
      street.value = data[0].street ?? 'Unknown';
      postalCode.value = data[0].postalCode ?? 'Unknown';
    }
  }
}
