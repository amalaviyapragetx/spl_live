import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/screens/Local%20Storage.dart';

import 'helper_files/app_colors.dart';
import 'helper_files/constant_variables.dart';
import 'helper_files/custom_text_style.dart';
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
      // Navigate to the home screen or do other actions
      _showExitDialog();
    });
  }

  void onUserInteraction(PointerEvent event) {
    print("state change");
    _resetInactivityTimer();
  }

  ifUserLogedIn() async {
    bool alreadyLoggedIn = await getStoredUserData();

    bool isActive =
        await LocalStorage.read(ConstantsVariables.isActive) ?? false;
    bool isVerified =
        await LocalStorage.read(ConstantsVariables.isVerified) ?? false;
    // bool userLogin = false;
    // print("-------------------------------==========$userLogin");
    // if (userLogin == false) {
    //   await LocalStorage.write(ConstantsVariables.timeOut, false);
    // } else {
    //   await LocalStorage.read(ConstantsVariables.timeOut);
    // }
    if (alreadyLoggedIn) {
      print("alreadyLogged:  $alreadyLoggedIn");
      if (isActive && isVerified) {
        _resetInactivityTimer();
      }
    }
  }

  userLogIn(PointerEvent event) async {
    bool alreadyLoggedIn = await getStoredUserData();
    bool isActive =
        await LocalStorage.read(ConstantsVariables.isActive) ?? false;
    bool isVerified =
        await LocalStorage.read(ConstantsVariables.isVerified) ?? false;
    //  bool userLogin = await LocalStorage.read(ConstantsVariables.timeOut);
    //  if (userLogin == null) {
    //    await LocalStorage.write(ConstantsVariables.timeOut, false);
    //  }
    // print("-------------------------------==========$userLogin");
    // print("$isActive $isVerified $userLogin");
    if (alreadyLoggedIn) {
      if (isActive && isVerified) {
        onUserInteraction(event);
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
      title: "",
      content: Column(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: SvgPicture.asset(
              ConstantImage.clockIcon,
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
            bool isActive =
                await LocalStorage.read(ConstantsVariables.isActive) ?? false;
            bool isVerified =
                await LocalStorage.read(ConstantsVariables.isVerified) ?? false;
            await LocalStorage.write(ConstantsVariables.timeOut, false);
            var timeOut = await LocalStorage.read(ConstantsVariables.timeOut);
            print("=============+++++$timeOut");
            if (timeOut == false) {
              if (alreadyLoggedIn) {
                if (isActive && isVerified) {
                  Get.offAllNamed(
                    AppRoutName.mPINPage,
                    arguments: {"id": _userDetailsModel.id},
                  );
                  _inactivityTimer?.cancel();
                }
              } else {
                print("alreadyLoggedInWelcomePage:  $alreadyLoggedIn");
                _inactivityTimer?.cancel();
              }
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
