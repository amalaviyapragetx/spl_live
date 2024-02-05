import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/api/service_locator.dart';
import 'package:spllive/api/services/auth_service.dart';
import 'package:spllive/components/DeviceInfo/device_information_model.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/location_models/location_model.dart';
import 'package:spllive/models/location_models/placemark.dart';
import 'package:spllive/screens/authentication/mpin_page_view.dart';
import 'package:spllive/utils/constant.dart';
import 'package:spllive/utils/device_info.dart';

class SplashScreenController extends GetxController {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  // UserDetailsDataModel _userDetailsModel = UserDetailsDataModel();
  RxString city = ''.obs;
  RxString country = ''.obs;
  RxString state = ''.obs;
  RxString street = ''.obs;
  RxString postalCode = ''.obs;
  String appVersion = "";
  final authService = getIt.get<AuthService>();

  RxBool versionCheck = false.obs;
  // fetchRemoteConfig() async {
  //   try {
  //     FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  //     // await remoteConfig.ensureInitialized();
  //     // await remoteConfig.fetch();
  //     // await remoteConfig.fetchAndActivate();
  //     final updatedVersion = remoteConfig.getString('app_version');
  //     PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //     Logger().i("dsaddasdsdasas === > $updatedVersion ");
  //     if (updatedVersion != packageInfo.version.toString()) {
  //       versionCheck.value = true;
  //     }
  //     if (versionCheck.value) {
  //       Get.defaultDialog(
  //         barrierDismissible: false,
  //         title: "",
  //         onWillPop: () async => false,
  //         titlePadding: EdgeInsets.zero,
  //         content: Column(
  //           children: [
  //             Row(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   "Shri",
  //                   style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25, letterSpacing: 1),
  //                 ),
  //                 SizedBox(width: 3),
  //                 Container(
  //                   padding: EdgeInsets.symmetric(horizontal: 4),
  //                   color: AppColor.bgYellow,
  //                   child: Text(
  //                     "BETS",
  //                     style: TextStyle(
  //                       color: AppColor.gradientColor1,
  //                       fontWeight: FontWeight.w900,
  //                       fontSize: 16,
  //                       letterSpacing: 1,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(width: 3),
  //                 Text(
  //                   "Update",
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.w900,
  //                       fontSize: 20,
  //                       decoration: TextDecoration.underline,
  //                       decorationColor: AppColor.textColorMain,
  //                       letterSpacing: 1),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 10),
  //             Text(
  //               "An update is available! Click here to upgrade.",
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontSize: 14,
  //               ),
  //             )
  //           ],
  //         ),
  //         actions: [
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 30.0),
  //             child: RoundedCornerButton(
  //               text: 'OKAY',
  //               height: 40,
  //               width: double.infinity,
  //               letterSpacing: 0,
  //               color: AppColor.textColorMain,
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //               borderRadius: 10,
  //               borderColor: AppColor.white,
  //               borderWidth: 2,
  //               textStyle: TextStyle(color: AppColor.white),
  //               fontColor: AppColor.white,
  //               onTap: () => launchUrl(Uri.parse("https://spl.live")),
  //             ),
  //           ),
  //         ],
  //       );
  //     }
  //   } catch (e) {
  //     print('Error fetching remote config: $e');
  //   }
  // }

  fcmApiCall(userId, fcmToken) async {
    try {
      final resp = await authService.fcmToken(id: userId, fcmToken1: fcmToken);
      if (resp['status']) {
      } else {
        AppUtils.showErrorSnackBar(bodyText: resp['message'] ?? "");
      }
    } catch (e) {
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placeMarks.isNotEmpty) {
        Placemark placeMark = placeMarks[0];
        city.value = placeMark.locality ?? 'Unknown';
        country.value = placeMark.country ?? 'Unknown';
        state.value = placeMark.administrativeArea ?? 'Unknown';
        street.value = "${placeMark.street ?? 'Unknown'} ${placeMark.subLocality ?? 'Unknown'}";
        postalCode.value = placeMark.postalCode ?? 'Unknown';
        List<PlaceMark> latestLocation = [
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
        List<Map<String, dynamic>> placeMarkJsonList = latestLocation
            .map((placeMark) => {
                  'name': placeMark.name,
                  'location': placeMark.location?.toJson(),
                })
            .toList();
        await GetStorage().write(ConstantsVariables.locationData, placeMarkJsonList);
      }
    } catch (e) {
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }

  getDeviceInfo() async {
    DeviceInformationModel deviceInfo = await DeviceInfo().initPlatformState();
    appVersion = deviceInfo.appVersion.toString();
  }

  appVersionCheck() async {
    try {
      final resp = await authService.appVersionCheck();
      if (resp['status']) {
        if (resp['data'] != appVersion) {
          // Get.defaultDialog(
          //   barrierDismissible: false,
          //   title: "",
          //   onWillPop: () async => false,
          //   titlePadding: EdgeInsets.zero,
          //   content: Column(
          //     children: [
          //       Row(
          //         mainAxisSize: MainAxisSize.min,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           const Text("Shri", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25, letterSpacing: 1)),
          //           const SizedBox(width: 3),
          //           Container(
          //             padding: const EdgeInsets.symmetric(horizontal: 4),
          //             color: AppColor.bgYellow,
          //             child: Text(
          //               "BETS",
          //               style: TextStyle(
          //                 color: AppColor.gradientColor1,
          //                 fontWeight: FontWeight.w900,
          //                 fontSize: 16,
          //                 letterSpacing: 1,
          //               ),
          //             ),
          //           ),
          //           const SizedBox(width: 3),
          //           Text(
          //             "Update",
          //             style: TextStyle(
          //                 fontWeight: FontWeight.w900,
          //                 fontSize: 20,
          //                 decoration: TextDecoration.underline,
          //                 decorationColor: AppColor.textColorMain,
          //                 letterSpacing: 1),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 10),
          //       const Text(
          //         "An update is available! Click here to upgrade.",
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           fontSize: 14,
          //         ),
          //       )
          //     ],
          //   ),
          //   actions: [
          //     // Padding(
          //     //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
          //     //   child: CommonButton(
          //     //     width: Get.width,
          //     //     buttonColor: AppColor.white,
          //     //     labelColor: AppColor.textColorMain,
          //     //     label: 'OKAY',
          //     //     onPressed: () => launchUrl(Uri.parse("https://spl.live")),
          //     //   ),
          //     // ),
          //   ],
          // );
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: resp['message'] ?? "");
      }
    } catch (e) {
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }

  Future<void> checkLogin() async {
    bool isActive = GetStorage().read(ConstantsVariables.isActive) ?? false;
    bool isVerified = GetStorage().read(ConstantsVariables.isVerified) ?? false;
    bool hasMPin = GetStorage().read(ConstantsVariables.isMpinSet) ?? false;
    bool isUserDetailSet = GetStorage().read(ConstantsVariables.isUserDetailSet) ?? false;
    //  if (!versionCheck.value) {
    if (GetStorage().read(ConstantsVariables.id) != null) {
      if (!isActive && !isVerified) {
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(AppRouteNames.verifyOTPPage);
          appVersionCheck();
        });
      } else if (!hasMPin && !isUserDetailSet) {
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(AppRouteNames.userDetailsPage);
          appVersionCheck();
        });
      } else {
        if (hasMPin && isVerified && isActive) {
          Future.delayed(const Duration(seconds: 2), () {
            Get.off(() => MPINPageView(id: GetStorage().read(ConstantsVariables.id)));
            appVersionCheck();
          });
          await fcmApiCall(GetStorage().read(ConstantsVariables.id), GetStorage().read(ConstantsVariables.fcmToken));
        } else {
          Future.delayed(const Duration(seconds: 2), () {
            Get.off(() => MPINPageView(id: GetStorage().read(ConstantsVariables.id)));
            appVersionCheck();
          });
        }
      }
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAllNamed(AppRouteNames.welcomeScreen);
        appVersionCheck();
      });
    }
    // }
  }
}
