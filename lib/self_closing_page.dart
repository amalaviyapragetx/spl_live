import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';

import 'helper_files/constant_variables.dart';
import 'models/commun_models/user_details_model.dart';
import 'routes/app_routes_name.dart';

class InactivityController extends GetxController {
  Timer? _inactivityTimer;
  final Duration _inactivityDuration = const Duration(seconds: 180);

  @override
  void onInit() async {
    super.onInit();
    ifUserLogedIn();
    userLogIn;
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_inactivityDuration, () {
      _showExitDialog();
    });
  }

  void onUserInteraction(PointerEvent event) {
    _resetInactivityTimer();
  }

  ifUserLogedIn() async {
    bool alreadyLoggedIn = getStoredUserData();

    bool isActive = GetStorage().read(ConstantsVariables.isActive) ?? false;
    bool isVerified = GetStorage().read(ConstantsVariables.isVerified) ?? false;
    bool userLogin = GetStorage().read(ConstantsVariables.timeOut) ?? false;
    if (userLogin) {
      if (alreadyLoggedIn) {
        if (isActive && isVerified) {
          _resetInactivityTimer();
        }
      }
    }
  }

  userLogIn(PointerEvent event) async {
    bool alreadyLoggedIn = getStoredUserData();
    bool isActive = GetStorage().read(ConstantsVariables.isActive) ?? false;
    bool isVerified = GetStorage().read(ConstantsVariables.isVerified) ?? false;
    bool userLogin = GetStorage().read(ConstantsVariables.timeOut) ?? false;

    if (userLogin) {
      if (alreadyLoggedIn) {
        if (isActive && isVerified) {
          onUserInteraction(event);
        }
      }
    }
  }

  @override
  void onClose() {
    _inactivityTimer?.cancel();
    super.onClose();
  }

  UserDetailsModel _userDetailsModel = UserDetailsModel();

  bool getStoredUserData() {
    final authToken = GetStorage().read(ConstantsVariables.authToken);
    final userData = GetStorage().read(ConstantsVariables.userData);
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
    // Get.dialog(
    //   barrierDismissible: false,
    //   ConstrainedBox(
    //     constraints: BoxConstraints(maxHeight: Get.width, minWidth: Get.width - 30),
    //     child: AlertDialog(
    //       insetPadding: EdgeInsets.symmetric(vertical: 10),
    //       contentPadding: const EdgeInsets.symmetric(horizontal: 55, vertical: 20),
    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    //       content: SizedBox(
    //         width: double.infinity,
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             SvgPicture.asset(ConstantImage.close, height: Dimensions.h60, width: Dimensions.w60),
    //             const SizedBox(height: 20),
    //             Text(
    //               "Bank details",
    //               textAlign: TextAlign.center,
    //               style: CustomTextStyle.textRobotoSansMedium.copyWith(
    //                 color: AppColors.appbarColor,
    //                 fontWeight: FontWeight.w700,
    //                 fontSize: 20,
    //               ),
    //             ),
    //             const SizedBox(height: 10),
    //             InkWell(
    //               onTap: () {
    //                 bool alreadyLoggedIn = getStoredUserData();
    //                 bool isActive = GetStorage().read(ConstantsVariables.isActive) ?? false;
    //                 bool isVerified = GetStorage().read(ConstantsVariables.isVerified) ?? false;
    //                 GetStorage().write(ConstantsVariables.timeOut, false);
    //                 final timeOut = GetStorage().read(ConstantsVariables.timeOut);
    //                 if (timeOut != null) {
    //                   if (timeOut) {
    //                     if (alreadyLoggedIn) {
    //                       if (isActive && isVerified) {
    //                         Get.offAllNamed(
    //                           AppRoutName.mPINPage,
    //                           arguments: {"id": _userDetailsModel.id},
    //                         );
    //                         _inactivityTimer?.cancel();
    //                       }
    //                     } else {
    //                       _inactivityTimer?.cancel();
    //                     }
    //                   } else {
    //                     Get.offAllNamed(
    //                       AppRoutName.mPINPage,
    //                       arguments: {"id": _userDetailsModel.id},
    //                     );
    //                     _inactivityTimer?.cancel();
    //                   }
    //                 }
    //               },
    //               child: Container(
    //                 decoration: BoxDecoration(color: AppColors.appbarColor, borderRadius: BorderRadius.circular(8)),
    //                 height: Dimensions.h40,
    //                 width: Dimensions.w150,
    //                 child: Center(
    //                   child: Text(
    //                     'LOGIN AGAIN',
    //                     style: CustomTextStyle.textRobotoSansBold.copyWith(color: AppColors.white, fontSize: 18),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    Get.defaultDialog(
      // barrierDismissible: false,
      // onWillPop: () async => false,
      title: "",
      titlePadding: EdgeInsets.zero,
      content: Column(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: SvgPicture.asset(ConstantImage.clockStIcon),
          ),
          SizedBox(height: Dimensions.h10),
          Text(
            "Session time out !",
            style: CustomTextStyle.textRobotoSansMedium.copyWith(
              fontSize: Dimensions.h15,
              color: AppColors.appbarColor,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      actions: [
        InkWell(
          onTap: () {
            bool alreadyLoggedIn = getStoredUserData();
            bool isActive = GetStorage().read(ConstantsVariables.isActive) ?? false;
            bool isVerified = GetStorage().read(ConstantsVariables.isVerified) ?? false;
            GetStorage().write(ConstantsVariables.timeOut, false);
            final timeOut = GetStorage().read(ConstantsVariables.timeOut);
            if (timeOut != null) {
              if (timeOut) {
                if (alreadyLoggedIn) {
                  if (isActive && isVerified) {
                    Get.offAllNamed(
                      AppRoutName.mPINPage,
                      arguments: {"id": _userDetailsModel.id},
                    );
                    _inactivityTimer?.cancel();
                  }
                } else {
                  _inactivityTimer?.cancel();
                }
              } else {
                Get.offAllNamed(
                  AppRoutName.mPINPage,
                  arguments: {"id": _userDetailsModel.id},
                );
                _inactivityTimer?.cancel();
              }
            }
          },
          child: Container(
            height: Dimensions.h40,
            width: Get.width / 2.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.appbarColor,
            ),
            child: Center(
              child: Text(
                'LOGIN AGAIN',
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
}
