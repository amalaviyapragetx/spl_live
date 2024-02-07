import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spllive/components/DeviceInfo/device_info.dart';
import 'package:spllive/routes/app_routes_name.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api_services/api_service.dart';
import '../../../components/DeviceInfo/device_information_model.dart';
import '../../../components/simple_button_with_corner.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/location_models/location_model.dart';
import '../../../models/location_models/placemark.dart';
import '../../Local Storage.dart';

class SplashController extends GetxController {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  UserDetailsModel _userDetailsModel = UserDetailsModel();
  DeviceInformationModel? deviceInfo;
  String appVersion = "";
  RxString city = ''.obs;
  RxString country = ''.obs;
  RxString state = ''.obs;
  RxString street = ''.obs;
  RxString postalCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getLocation();
    checkLogin();
    getDeviceInfo();
    // Timer(Duration(milliseconds: 700), () {});
  }

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        city.value = placemark.locality ?? 'Unknown';
        country.value = placemark.country ?? 'Unknown';
        state.value = placemark.administrativeArea ?? 'Unknown';
        street.value = "${placemark.street ?? 'Unknown'} ${placemark.subLocality ?? 'Unknown'}";
        postalCode.value = placemark.postalCode ?? 'Unknown';
        List<PlaceMark> letestLocation = [
          PlaceMark(
            name: 'Place 1',
            location: LocationModel(
                city: city.value,
                country: country.value,
                state: state.value,
                street: street.value,
                postalCode: postalCode.value),
          ),
        ];
        List<Map<String, dynamic>> placeMarkJsonList = letestLocation
            .map((placeMark) => {
                  'name': placeMark.name,
                  'location': placeMark.location?.toJson(),
                })
            .toList();
        await LocalStorage.write(ConstantsVariables.locationData, placeMarkJsonList);
        var storedPlaceMarkJsonList = await LocalStorage.read(ConstantsVariables.locationData) ?? [];
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  callFcmApi(userId) {
    var token = GetStorage().read(ConstantsVariables.fcmToken);
    Timer(const Duration(milliseconds: 500), () {
      fsmApiCall(userId, token);
    });
  }

  fcmBody(userId, fcmToken) {
    var a = {
      "id": userId,
      "fcmToken": fcmToken,
    };
    return a;
  }

  void fsmApiCall(userId, fcmToken) async {
    ApiService().fcmToken(await fcmBody(userId, fcmToken)).then((value) async {
      if (value['status']) {
        // AppUtils.showSuccessSnackBar(
        //     bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  getDeviceInfo() async {
    DeviceInformationModel deviceInfo = await DeviceInfo().initPlatformState();
    appVersion = deviceInfo.appVersion.toString();
  }

  void appVersionCheck() async {
    ApiService().getAppVersion().then((value) async {
      if (value['status']) {
        if (value['data'] != appVersion) {
          _showExitDialog();
        }
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  Future<void> checkLogin() async {
    bool alreadyLoggedIn = await getStoredUserData();
    bool isActive = await LocalStorage.read(ConstantsVariables.isActive) ?? false;

    bool isVerified = await LocalStorage.read(ConstantsVariables.isVerified) ?? false;
    bool hasMPIN = await LocalStorage.read(ConstantsVariables.isMpinSet) ?? false;
    bool isUserDetailSet = await LocalStorage.read(ConstantsVariables.isUserDetailSet) ?? false;

    //print(LocalStorage.read(ConstantsVariables.authToken.));
    if (alreadyLoggedIn) {
      if (!isActive && !isVerified) {
        //   callFcmApi(_userDetailsModel.id);
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(AppRoutName.verifyOTPPage);
          Timer(const Duration(milliseconds: 500), () {
            appVersionCheck();
            requestLocationPermission();
          });
        });
      } else if (!hasMPIN && !isUserDetailSet) {
        //   callFcmApi(_userDetailsModel.id);
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(AppRoutName.userDetailsPage);
          Timer(const Duration(milliseconds: 500), () {
            appVersionCheck();
            requestLocationPermission();
          });
        });
      } else {
        if (hasMPIN) {
          callFcmApi(_userDetailsModel.id);
          Future.delayed(const Duration(seconds: 2), () {
            Get.offAllNamed(AppRoutName.mPINPage, arguments: {"id": _userDetailsModel.id});
            Timer(const Duration(milliseconds: 500), () {
              appVersionCheck();
              requestLocationPermission();
            });
          });
        } else {
          Future.delayed(const Duration(seconds: 2), () {
            Get.offAllNamed(AppRoutName.signInPage, arguments: {"id": _userDetailsModel.id});
            Timer(const Duration(milliseconds: 500), () {
              appVersionCheck();
              requestLocationPermission();
            });
          });
        }
      }
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        // Get.offAllNamed(AppRoutes.dashboardPage);
        Get.offAllNamed(AppRoutName.walcomeScreen);
        Timer(const Duration(milliseconds: 500), () {
          appVersionCheck();
          requestLocationPermission();
        });
      });
    }
  }

  Future<bool> getStoredUserData() async {
    String? authToken = await LocalStorage.read(ConstantsVariables.authToken);
    var userData = await LocalStorage.read(ConstantsVariables.userData);
    if (authToken != null && authToken.isNotEmpty) {
      if (userData != null) {
        _userDetailsModel = UserDetailsModel.fromJson(userData);
      }
      return true;
    } else {
      return false;
    }
  }

  void _showExitDialog() {
    Get.defaultDialog(
      barrierDismissible: false,
      title: "Update App",
      onWillPop: () async => false,
      titleStyle: CustomTextStyle.textRobotoSansMedium,
      content: Column(
        children: [
          Text(
            "An update is available! Click here to upgrade.",
            textAlign: TextAlign.center,
            style: CustomTextStyle.textRobotoSansMedium.copyWith(
              fontSize: Dimensions.h14,
            ),
          )
        ],
      ),
      actions: [
        InkWell(
          onTap: () async {
            launch(
              "https://spl.live",
            );
          },
          child: Container(
            color: AppColors.appbarColor,
            height: Dimensions.h40,
            width: Dimensions.w200,
            child: Center(
              child: Text(
                'OK',
                style: CustomTextStyle.textRobotoSansBold.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    print("ooooooooooooooooo$status");
    if (status.isGranted) {
      // Permission granted, proceed with your flow.
      print('Location permission granted');
    } else if (status.isDenied) {
      // Permission denied.
      Get.defaultDialog(
        titlePadding: EdgeInsets.only(top: Dimensions.h10),
        title: 'Permission Denied',
        middleText: 'Please grant location permission to use this feature.',
        confirm: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.w50, vertical: Dimensions.h5),
          child: RoundedCornerButton(
            text: 'Open Settings',
            color: AppColors.appbarColor,
            borderColor: AppColors.appbarColor,
            fontSize: Dimensions.h12,
            fontWeight: FontWeight.w500,
            fontColor: AppColors.white,
            letterSpacing: 0,
            borderRadius: Dimensions.r5,
            borderWidth: 1,
            textStyle: CustomTextStyle.textRobotoSansLight,
            onTap: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              openAppSettings(); // Open app settings if permission is permanently denied.
            },
            height: Dimensions.h30,
            width: double.infinity,
          ),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied.

      Get.defaultDialog(
        titlePadding: EdgeInsets.only(top: Dimensions.h10),
        radius: Dimensions.r10,
        title: 'Permission Denied',
        onWillPop: () async => false,
        middleText: 'Please enable location permission in your app settings.',
        confirm: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.w50, vertical: Dimensions.h5),
          child: RoundedCornerButton(
            text: 'Open Settings',
            color: AppColors.appbarColor,
            borderColor: AppColors.appbarColor,
            fontSize: Dimensions.h12,
            fontWeight: FontWeight.w500,
            fontColor: AppColors.white,
            letterSpacing: 0,
            borderRadius: Dimensions.r5,
            borderWidth: 1,
            textStyle: CustomTextStyle.textRobotoSansLight,
            onTap: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              openAppSettings(); // Open app settings if permission is permanently denied.
            },
            height: Dimensions.h30,
            width: double.infinity,
          ),
        ),
      );
    }
  }

  // Future<String> getIpAddress() async {
  //   getIpAddress2();
  //   try {
  //     List<NetworkInterface> interfaces =
  //         await NetworkInterface.list(includeLoopback: false, type: InternetAddressType.IPv4);
  //     for (NetworkInterface interface in interfaces) {
  //       print("===========${interface.name.toLowerCase()}================================");
  //       if (interface.name.toLowerCase().contains("wlan") || interface.name.toLowerCase().contains("eth")) {
  //         for (InternetAddress address in interface.addresses) {
  //           if (!address.isLoopback && !address.isLinkLocal) {
  //             return address.address;
  //           }
  //         }
  //       }
  //     }
  //   } on SocketException catch (e) {
  //     print("Error getting IP address: $e");
  //   }
  //   return "Could not determine IP address";
  // }
  //
  // void getIpAddress2() async {
  //   ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
  //
  //   if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
  //     try {
  //       for (var interface in await NetworkInterface.list()) {
  //         for (var addr in interface.addresses) {
  //           if (addr.type.name.toLowerCase() == 'ipv4') {
  //             print('IP Address: ${addr.address}');
  //             return;
  //           }
  //         }
  //       }
  //     } catch (e) {
  //       print('Error getting IP address: $e');
  //     }
  //   } else {
  //     print('No internet connection available');
  //   }
  // }
}
