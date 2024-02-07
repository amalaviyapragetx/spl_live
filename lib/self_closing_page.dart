import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/models/commun_models/user_details_model.dart';
import 'package:spllive/screens/Local%20Storage.dart';
import 'package:spllive/screens/authentication/mpin_page_view.dart';
import 'package:spllive/utils/constant.dart';

import 'helper_files/app_colors.dart';
import 'helper_files/custom_text_style.dart';

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
    bool alreadyLoggedIn = await getStoredUserData();

    bool isActive = await LocalStorage.read(ConstantsVariables.isActive) ?? false;
    bool isVerified = await LocalStorage.read(ConstantsVariables.isVerified) ?? false;
    bool userLogin = await LocalStorage.read(ConstantsVariables.timeOut) ?? false;
    // print("-------------------------------==========$userLogin");
    if (userLogin) {
      if (alreadyLoggedIn) {
        if (isActive && isVerified) {
          _resetInactivityTimer();
        }
      }
    }
  }

  userLogIn(PointerEvent event) async {
    bool alreadyLoggedIn = await getStoredUserData();
    bool isActive = await LocalStorage.read(ConstantsVariables.isActive) ?? false;
    bool isVerified = await LocalStorage.read(ConstantsVariables.isVerified) ?? false;
    bool userLogin = await LocalStorage.read(ConstantsVariables.timeOut) ?? false;

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

  Future<bool> getStoredUserData() async {
    String? authToken = GetStorage().read(ConstantsVariables.authToken) ?? "";
    var userData = GetStorage().read(ConstantsVariables.userData);
    if (authToken.isNotEmpty && authToken.isNotEmpty) {
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
      onWillPop: () async => false,
      title: "",
      content: Column(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: SvgPicture.asset(
              AppImage.clockIcon,
              color: AppColors.appbarColor,
            ),
          ),
          SizedBox(
            height: Dimensions.h10,
          ),
          Text(
            "Session Timeout",
            style: CustomTextStyle.textRobotoSansMedium.copyWith(
              fontSize: Dimensions.h15,
            ),
          )
        ],
      ),
      actions: [
        InkWell(
          onTap: () async {
            bool alreadyLoggedIn = await getStoredUserData();
            bool isActive = GetStorage().read(ConstantsVariables.isActive) ?? false;
            bool isVerified = GetStorage().read(ConstantsVariables.isVerified) ?? false;
            GetStorage().write(ConstantsVariables.timeOut, false);
            var timeOut = GetStorage().read(ConstantsVariables.timeOut);
            if (timeOut) {
              if (alreadyLoggedIn) {
                if (isActive && isVerified) {
                  // Get.offAllNamed(
                  //   AppRouteNames.mPINPage,
                  //   arguments: {"id": _userDetailsModel.id},
                  // );
                  Get.offAll(MPINPageView(id: _userDetailsModel.id));
                  _inactivityTimer?.cancel();
                }
              } else {
                _inactivityTimer?.cancel();
              }
            } else {
              Get.offAll(MPINPageView(id: _userDetailsModel.id));
              // Get.offAllNamed(
              //   AppRouteNames.mPINPage,
              //   arguments: {"id": _userDetailsModel.id},
              // );
              _inactivityTimer?.cancel();
            }
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
}
