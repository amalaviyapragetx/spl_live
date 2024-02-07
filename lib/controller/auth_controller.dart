// ignore_for_file: unnecessary_null_comparison
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spllive/api/service_locator.dart';
import 'package:spllive/api/services/auth_service.dart';
import 'package:spllive/components/DeviceInfo/device_info.dart';
import 'package:spllive/components/DeviceInfo/device_information_model.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/location_models/location_model.dart';
import 'package:spllive/models/resend_otp_model.dart';
import 'package:spllive/models/sign_in_model.dart';
import 'package:spllive/models/sign_up_model.dart';
import 'package:spllive/models/user_details_model.dart';
import 'package:spllive/models/verify_otp_model.dart';
import 'package:spllive/screens/Verify%20OTP%20Page/verify_otp.dart';
import 'package:spllive/screens/authentication/set_mpin_page.dart';
import 'package:spllive/utils/constant.dart';

class AuthController extends GetxController {
  Map<String, String>? headers = {};
  Map<String, String>? headersWithToken = {};
  Map<String, String>? headersWithImageAndToken = {};
  String contentType = "";
  String authToken = '';
  final authService = getIt.get<AuthService>();
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool visiblePassword = false.obs;
  var countryCode = '+91'.obs;
  Rx<SignInModel> signInModel = SignInModel().obs;
  late FocusNode focusNodeSignIn;
  // Sign In
  signIn() async {
    try {
      final resp = await authService.signIn(
        phoneNumber: mobileNumberController.text,
        countryCode: countryCode.value,
        password: passwordController.text,
        deviceId: DeviceInfo.deviceId,
      );
      if (resp != null) {
        signInModel.value = resp;
        if (signInModel.value.status ?? false) {
          var userData = signInModel.value.data;
          mobileNumberController.clear();
          passwordController.clear();
          AppUtils.hideProgressDialog();
          AppUtils.showSuccessSnackBar(headerText: "Success", bodyText: signInModel.value.message ?? "");
          GetStorage().write(ConstantsVariables.authToken, signInModel.value.data?.Token ?? "");
          GetStorage().write(ConstantsVariables.id, signInModel.value.data?.Id ?? "");
          GetStorage().write(ConstantsVariables.isActive, signInModel.value.data?.IsActive ?? false);
          GetStorage().write(ConstantsVariables.isVerified, signInModel.value.data?.IsVerified ?? false);
          GetStorage().write(ConstantsVariables.userData, userData);
          GetStorage().write(ConstantsVariables.isUserDetailSet, signInModel.value.data?.IsUserDetailSet ?? false);
          if (signInModel.value.data?.IsUserDetailSet ?? false) {
            Get.toNamed(AppRouteNames.setMPINPage);
            Get.to(() => const SetMPINPage(fromLogin: true));
          } else {
            Get.toNamed(AppRouteNames.userDetailsPage);
          }
        } else {
          AppUtils.hideProgressDialog();
          AppUtils.showErrorSnackBar(bodyText: signInModel.value.message ?? "");
        }
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }

  var mobileNumberSignUp = TextEditingController();
  var countryCodeSignUp = '+91'.obs;
  Rx<SignUpModel> signUPModel = SignUpModel().obs;

  signUP() async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      final resp = await authService.signUp(
          countryCode: countryCodeSignUp.value, phoneNumber: mobileNumberSignUp.text, deviceId: DeviceInfo.deviceId);
      if (resp != null) {
        signUPModel.value = resp;
        if (signUPModel.value.status ?? false) {
          AppUtils.hideProgressDialog();

          Get.to(() => VerifyOTPPage(countryCode: countryCodeSignUp.value, phoneCon: mobileNumberSignUp.text));
          AppUtils.showSuccessSnackBar(headerText: "Success", bodyText: signUPModel.value.message ?? "");
        } else {
          AppUtils.hideProgressDialog();
          AppUtils.showErrorSnackBar(bodyText: signUPModel.value.message ?? "");
        }
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }

  RxString otp = "".obs;
  String phoneNumberOtp = "";
  String countryCodeOtp = "";
  Rx<VerifyOtpModel> verifyUserModel = VerifyOtpModel().obs;

  verifyUser() async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      final resp =
          await authService.verifyUser(countryCode: countryCodeOtp, phoneNumber: phoneNumberOtp, otp: otp.value);
      if (resp != null) {
        verifyUserModel.value = resp;
        if (verifyUserModel.value.status ?? false) {
          if (verifyUserModel.value.data != null) {
            AppUtils.hideProgressDialog();
            String authToken = verifyUserModel.value.data?.Token ?? "Null From API";
            GetStorage().write(ConstantsVariables.authToken, authToken);
            GetStorage().write(ConstantsVariables.id, verifyUserModel.value.data?.Id ?? "");
            GetStorage().write(ConstantsVariables.isActive, verifyUserModel.value.data?.IsActive ?? false);
            GetStorage().write(ConstantsVariables.isVerified, verifyUserModel.value.data?.IsVerified ?? false);
            GetStorage()
                .write(ConstantsVariables.isUserDetailSet, verifyUserModel.value.data?.IsUserDetailSet ?? false);
            Get.toNamed(AppRouteNames.userDetailsPage);
            AppUtils.showSuccessSnackBar(headerText: "Success", bodyText: verifyUserModel.value.message ?? "");
          } else {
            AppUtils.showErrorSnackBar(bodyText: "Something went wrong!!!");
          }
        } else {
          AppUtils.hideProgressDialog();
          AppUtils.showErrorSnackBar(bodyText: verifyUserModel.value.message ?? "");
        }
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }

  Rx<VerifyOtpModel> verifyOtpModel = VerifyOtpModel().obs;
  verifyOTP() async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      final resp = await authService.verifyOTP(otp: otp.value);
      if (resp != null) {
        verifyOtpModel.value = resp;
        if (verifyOtpModel.value.status ?? false) {
          AppUtils.hideProgressDialog();
          AppUtils.showSuccessSnackBar(headerText: "Success", bodyText: verifyOtpModel.value.message ?? "");
          secondsRemaining.value = 60;
          startTimer();
          if (verifyOtpModel.value.data != null) {
            Get.toNamed(AppRouteNames.setMPINPage);
          } else {
            AppUtils.hideProgressDialog();
            AppUtils.showErrorSnackBar(bodyText: "Something went wrong!!!");
          }
        } else {
          AppUtils.hideProgressDialog();
          AppUtils.showErrorSnackBar(bodyText: verifyOtpModel.value.message ?? "");
        }
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }

  Rx<ResendOtpModel> resendOtpModel = ResendOtpModel().obs;
  resendOtpApi() async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      final resp = await authService.resendOtpApi(
          phoneNumber: phoneNumberOtp == "" ? phoneNumberFP.text : phoneNumberOtp,
          countryCode: phoneNumberOtp == "" ? phoneCodeForgot.value : countryCodeOtp);
      if (resp != null) {
        resendOtpModel.value = resp;
        if (resendOtpModel.value.status ?? false) {
          AppUtils.hideProgressDialog();
          AppUtils.showSuccessSnackBar(headerText: "Success", bodyText: resendOtpModel.value.message ?? "");
          secondsRemaining.value = 60;
          startTimer();
        } else {
          AppUtils.hideProgressDialog();
          AppUtils.showErrorSnackBar(bodyText: resendOtpModel.value.message ?? "");
        }
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }

  RxInt secondsRemaining = 60.obs;
  late Timer timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel(); // Stop the timer when it reaches 0
      }
    });
  }

  String get formattedTime {
    int minutes = (secondsRemaining.value ~/ 60);
    int seconds = (secondsRemaining.value % 60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  TextEditingController fullNameRes = TextEditingController();
  TextEditingController userNameRes = TextEditingController();
  TextEditingController passwordRes = TextEditingController();
  TextEditingController confirmPasswordRes = TextEditingController();
  RxBool pVisibility = false.obs;
  RxBool cpVisibility = false.obs;

  void onTapOfRegister() {
    if (fullNameRes.text.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "ENTERFULLNAME".tr);
    } else if (userNameRes.text.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "ENTERUSERNAME".tr);
    } else if (passwordRes.text.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "ENTERPASSWORD".tr);
    } else if (passwordRes.text.toString().length < 6) {
      AppUtils.showErrorSnackBar(bodyText: "ENTERVALIDPASSWORD".tr);
    } else if (confirmPasswordRes.text.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "ENTERCONFIRMPASSWORD".tr);
    } else if (confirmPasswordRes.text.toString().length < 6) {
      AppUtils.showErrorSnackBar(bodyText: "ENTERVALIDCONFIRMPASSWORD".tr);
    } else if (passwordRes.text != confirmPasswordRes.text) {
      AppUtils.showErrorSnackBar(bodyText: "PASSWORDDOESNTMATCHED".tr);
    } else {
      Get.to(
        () => SetMPINPage(
          fromLogin: true,
          userDetails: UserDetails(userName: userNameRes.text, password: passwordRes.text, fullName: fullNameRes.text),
        ),
      );
    }
  }

  //// set M pin

  RxString mpin = "".obs;
  RxString confirmMpin = "".obs;
  FocusNode focusNodeMpin = FocusNode();
  FocusNode focusNodeSetMpin = FocusNode();
  RxString city = ''.obs;
  RxString country = ''.obs;
  RxString state = ''.obs;
  RxString street = ''.obs;
  RxString postalCode = ''.obs;
  bool fromLoginPage = false;

  getLocationsData({bool? isLogin, UserDetails? userDetail}) {
    final locationData = GetStorage().read(ConstantsVariables.locationData) ?? [];
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
    if (userDetail != null) {
      setUserDetailsModel = userDetail;
      fromLoginPage = false;
    } else {
      fromLoginPage = true;
    }
  }

  void onTapOfContinue() {
    if (mpin.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "ENTERMPIN".tr);
    } else if (mpin.value.length < 4) {
      AppUtils.showErrorSnackBar(bodyText: "ENTERVALIDMPIN".tr);
    } else if (confirmMpin.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "ENTERCONFIRMMPIN".tr);
    } else if (confirmMpin.value.length < 4) {
      AppUtils.showErrorSnackBar(bodyText: "ENTERVALIDCONFIRMMPIN".tr);
    } else if (mpin.value != confirmMpin.value) {
      AppUtils.showErrorSnackBar(bodyText: "MPINDOWSNTMATCHED".tr);
    } else {
      fromLoginPage ? setMPIN() : setUserDetails();
    }
  }

  Rx<SetUserDetailsModel> userDetailModel = SetUserDetailsModel().obs;

  setMPIN() async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      final resp = await authService.setMPIN(mpin: mpin.value);
      if (resp != null) {
        userDetailModel.value = resp;
        if (userDetailModel.value.status ?? false) {
          if (userDetailModel.value.data != null) {
            GetStorage().write(ConstantsVariables.authToken, userDetailModel.value.data?.Token ?? "Null From API");
            GetStorage().write(ConstantsVariables.isActive, userDetailModel.value.data?.IsActive ?? false);
            GetStorage().write(ConstantsVariables.isVerified, userDetailModel.value.data?.IsVerified ?? false);
            GetStorage().write(ConstantsVariables.isMpinSet, userDetailModel.value.data?.IsMPinSet ?? false);
            GetStorage().write(ConstantsVariables.userPhN, userDetailModel.value.data?.PhoneNumber);
            AppUtils.hideProgressDialog();
            setUserDetails();
          } else {
            AppUtils.hideProgressDialog();
            AppUtils.showErrorSnackBar(bodyText: "Something went wrong!!!");
          }
          Get.offAllNamed(AppRouteNames.dashboardPage);
        } else {
          AppUtils.hideProgressDialog();
          AppUtils.showErrorSnackBar(bodyText: userDetailModel.value.message ?? "");
        }
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }

  Rx<SetUserDetailsModel> userDetailModel2 = SetUserDetailsModel().obs;
  UserDetails setUserDetailsModel = UserDetails();

  setUserDetails() async {
    DeviceInformationModel deviceInfo = await DeviceInfo().initPlatformState();
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      final resp = await authService.setUserDetails(
        userName: setUserDetailsModel.userName,
        fullName: setUserDetailsModel.fullName,
        password: setUserDetailsModel.password,
        mpin: mpin.value,
        osVersion: deviceInfo.osVersion,
        appVersion: deviceInfo.appVersion,
        brandName: deviceInfo.brandName,
        model: deviceInfo.model,
        deviceOs: deviceInfo.deviceOs,
        manufacturer: deviceInfo.manufacturer,
        city: city.value,
        country: country.value,
        state: state.value,
        street: street.value,
        postalCode: postalCode.value,
      );
      if (resp != null) {
        userDetailModel2.value = resp;
        if (userDetailModel2.value.status ?? false) {
          var userData = userDetailModel2.value.data;
          if (userDetailModel2.value.data != null) {
            String authToken = userDetailModel2.value.data?.Token ?? "Null From API";
            GetStorage().write(ConstantsVariables.authToken, authToken);
            GetStorage().write(ConstantsVariables.isActive, userDetailModel2.value.data?.IsActive ?? false);
            GetStorage().write(ConstantsVariables.isVerified, userDetailModel2.value.data?.IsVerified ?? false);
            GetStorage().write(ConstantsVariables.isMpinSet, userDetailModel2.value.data?.IsMPinSet ?? false);
            GetStorage().write(ConstantsVariables.userData, userData);
            GetStorage().write(ConstantsVariables.userName, userDetailModel2.value.data?.UserName);
            GetStorage().write(ConstantsVariables.userPhN, userDetailModel2.value.data?.PhoneNumber);
            GetStorage().write(ConstantsVariables.isUserDetailSet, userDetailModel2.value.data?.IsUserDetailSet);
            fsmApiCall(userDetailModel2.value.data?.Id ?? "", GetStorage().read(ConstantsVariables.fcmToken));
            AppUtils.hideProgressDialog();
          }
          setUserDetailsModel.userName == null ? null : Get.offAllNamed(AppRouteNames.dashboardPage);
        } else {
          AppUtils.hideProgressDialog();
          AppUtils.showErrorSnackBar(bodyText: userDetailModel2.value.message ?? "");
        }
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }

  // fcmToken
  void fsmApiCall(userId, fcmToken) async {
    final resp = await authService.fcmToken(id: userId, fcmToken1: fcmToken);
    try {
      if (resp['status']) {
      } else {
        AppUtils.showErrorSnackBar(bodyText: resp['message'] ?? "");
      }
    } catch (e) {
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }

  var phoneNumberFP = TextEditingController();
  var phoneCodeForgot = '+91'.obs;
  Rx<SignInModel> forgotPassModel = SignInModel().obs;

  // forgotPassword
  forgotPassword() async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      final resp =
          await authService.forgotPassword(countryCodeFP: phoneCodeForgot.value, phoneNumberFP: phoneNumberFP.text);
      if (resp != null) {
        forgotPassModel.value = resp;
        if (forgotPassModel.value.status ?? false) {
          AppUtils.hideProgressDialog();
          AppUtils.showSuccessSnackBar(bodyText: forgotPassModel.value.message ?? "", headerText: "SUCCESSMESSAGE".tr);
          phoneNumberFP.clear();
          Get.toNamed(AppRouteNames.resetPasswordPage);
        } else {
          AppUtils.hideProgressDialog();
          AppUtils.showErrorSnackBar(bodyText: forgotPassModel.value.message ?? "");
        }
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }

  TextEditingController passwordReset = TextEditingController();
  TextEditingController passwordConReset = TextEditingController();
  RxBool pVisibilityReset = false.obs;
  RxBool cpVisibilityReset = false.obs;
  RxBool confirmPasswordVisibility = false.obs;
  RxString otpReset = "".obs;

  // reset the password
  resetPass() async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      final resp = await authService.resetPass(
        password: passwordReset.text,
        countryCode: phoneCodeForgot.value,
        phoneNumber: phoneNumberFP.text,
        otp: otpReset.value,
        confirmPassword: passwordConReset.text,
      );
      if (resp != null) {
        if (resp['status'] ?? false) {
          AppUtils.hideProgressDialog();
          otp.value = "";

          passwordReset.clear();
          passwordConReset.clear();
          Get.offAndToNamed(AppRouteNames.signInPage);
          AppUtils.showSuccessSnackBar(bodyText: resp['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
        } else {
          AppUtils.showErrorSnackBar(bodyText: resp['message'] ?? "");
          AppUtils.hideProgressDialog();
        }
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }

  void forgotMPI() async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      final resp = await authService.forgotMPI();
      if (resp['status']) {
        AppUtils.hideProgressDialog();
        Get.toNamed(AppRouteNames.verifyOTPPage);
      } else {
        AppUtils.hideProgressDialog();
        AppUtils.showErrorSnackBar(bodyText: resp['message'] ?? "");
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }

  StreamController<ErrorAnimationType> mpinErrorController = StreamController<ErrorAnimationType>();
  RxString userId = "".obs;
  RxString verifyMpin = "".obs;

  void verifyMPIN() async {
    try {
      DeviceInformationModel deviceInfo = await DeviceInfo().initPlatformState();
      AppUtils.showProgressDialog(isCancellable: false);
      final resp = await authService.verifyMPIN(
        id: userId.value,
        deviceId: deviceInfo.deviceId,
        city: city.value,
        country: country.value,
        state: state.value,
        street: street.value,
        postalCode: postalCode.value,
        mpin: verifyMpin.value,
        ipAddress: ip.value,
      );
      if (resp['status']) {
        if (resp['data'] != null) {
          GetStorage().write(ConstantsVariables.authToken, resp['data']['Token'] ?? "Null From API");
        }
        Get.offAllNamed(AppRouteNames.dashboardPage);
      } else {
        mpinErrorController.add(ErrorAnimationType.shake);
        AppUtils.showErrorSnackBar(bodyText: resp['message'] ?? "");
      }
      AppUtils.hideProgressDialog();
    } catch (e) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }

  getLocationsDataMpin() async {
    final locationData = await GetStorage().read(ConstantsVariables.locationData) ?? [];
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

  Rx<String?> ip = "".obs;

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

  // change password

  RxString oldMPINChange = "".obs;
  RxString newMPINChange = "".obs;
  RxString reEnterMPINChange = "".obs;

  void onTapOfChangeMpin() {
    if (oldMPINChange.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "Please Enter Old MPIN");
    } else if (oldMPINChange.value.length < 4) {
      AppUtils.showErrorSnackBar(bodyText: "Please Enter Valid Old MPIN");
    } else if (newMPINChange.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "Please Enter New MPIN");
    } else if (newMPINChange.value.length < 4) {
      AppUtils.showErrorSnackBar(bodyText: "Please Enter Valid New MPIN");
    } else if (reEnterMPINChange.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "Please Re-Enter New MPIN");
    } else if (reEnterMPINChange.value.length < 4) {
      AppUtils.showErrorSnackBar(bodyText: "Please Re-Enter Valid New MPIN");
    } else {
      oldMPINChange.value = "";
      newMPINChange.value = "";
      reEnterMPINChange.value = "";
      changeMPIN();
    }
  }

  onChange() {
    // if (oldMPIN.value.length == 4) {
    //   oldMPINFocusNode.unfocus();
    //   newMPINFocusNode.requestFocus();
    // }
    // if (newMPIN.value.length == 4) {
    //   newMPINFocusNode.unfocus();
    //   reEnterMPINFocusNode.requestFocus();
    // }
    if (reEnterMPINChange.value.length == 4) {
      onTapOfChangeMpin();
    }
  }

  void changeMPIN() async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      final resp = await authService.changeMPIN(
        oldMPIN: oldMPINChange.value,
        newMPIN: newMPINChange.value,
        reEnterMPIN: reEnterMPINChange.value,
      );
      if (resp['status']) {
        AppUtils.hideProgressDialog();
        AppUtils.showSuccessSnackBar(bodyText: resp['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
        Get.offAndToNamed(AppRouteNames.profilePage);
      } else {
        mpinErrorController.add(ErrorAnimationType.shake);
        AppUtils.hideProgressDialog();
        AppUtils.showErrorSnackBar(bodyText: resp['message'] ?? "");
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }
  ////  changePassword

  TextEditingController oldPasswordChange = TextEditingController();
  TextEditingController newPasswordChange = TextEditingController();
  TextEditingController confirmPasswordChange = TextEditingController();
  RxBool visibleOldPassword = false.obs;
  RxBool visibleNewPassword = false.obs;
  RxBool visibleConPassword = false.obs;

  void onTapChangePassword() {
    FocusManager.instance.primaryFocus?.unfocus();
    Get.closeCurrentSnackbar();
    if (oldPasswordChange.text.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "Enter Old Password");
    } else if (newPasswordChange.text.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "Enter New Password");
    } else if (confirmPasswordChange.text.isEmpty) {
      AppUtils.showErrorSnackBar(bodyText: "Enter Confirm Password");
    } else if (newPasswordChange.text != confirmPasswordChange.text) {
      AppUtils.showErrorSnackBar(bodyText: "Enter Valid ConfirmPassword");
    } else {
      changePassword();
    }
  }

  void changePassword() async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      final resp = await authService.changePassword(
        oldPassword: oldPasswordChange.text,
        newPassword: newPasswordChange.text,
        confirmPassword: confirmPasswordChange.text,
      );
      if (resp['status']) {
        AppUtils.hideProgressDialog();
        AppUtils.showSuccessSnackBar(bodyText: resp['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
        Get.offAndToNamed(AppRouteNames.profilePage);
        oldPasswordChange.clear();
        newPasswordChange.clear();
        confirmPasswordChange.clear();
      } else {
        newPasswordChange.clear();
        confirmPasswordChange.clear();
        AppUtils.hideProgressDialog();
        AppUtils.showErrorSnackBar(bodyText: resp['message'] ?? "");
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: e.toString());
    }
  }
}
