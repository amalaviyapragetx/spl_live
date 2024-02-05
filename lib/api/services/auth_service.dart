import 'package:dio/dio.dart';
import 'package:spllive/api/dio_exceptions.dart';
import 'package:spllive/api/request/auth_api.dart';
import 'package:spllive/models/resend_otp_model.dart';
import 'package:spllive/models/sign_in_model.dart';
import 'package:spllive/models/sign_up_model.dart';
import 'package:spllive/models/user_details_model.dart';
import 'package:spllive/models/verify_otp_model.dart';

class AuthService {
  final AuthApi authApi;

  AuthService(this.authApi);

  //
  Future<SignInModel?> signIn({String? countryCode, String? phoneNumber, String? password, String? deviceId}) async {
    try {
      final response = await authApi.signIn(
          countryCode: countryCode, phoneNumber: phoneNumber, password: password, deviceId: deviceId);
      if (response != null) {
        return SignInModel.fromJson(response.data);
      }
    } catch (e) {
      final errorMessage = DioExceptions.fromDioError(e as DioException);
      throw errorMessage;
    }
    return null;
  }

  Future<SignUpModel?> signUp({
    String? countryCode,
    String? phoneNumber,
    String? deviceId,
  }) async {
    try {
      final response = await authApi.signUP(countryCode: countryCode, phoneNumber: phoneNumber, deviceId: deviceId);
      if (response != null) {
        return SignUpModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<VerifyOtpModel?> verifyUser({
    String? otp,
    String? phoneNumber,
    String? countryCode,
  }) async {
    try {
      final response = await authApi.verifyUser(countryCode: countryCode, phoneNumber: phoneNumber, otp: otp);
      if (response != null) {
        return VerifyOtpModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<VerifyOtpModel?> verifyOTP({String? otp}) async {
    try {
      final response = await authApi.verifyOTP(otp: otp);
      if (response != null) {
        return VerifyOtpModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<ResendOtpModel?> resendOtpApi({String? phoneNumber, String? countryCode}) async {
    try {
      final response = await authApi.resendOtpApi(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      );
      if (response != null) {
        return ResendOtpModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<SetUserDetailsModel?> setMPIN({String? mpin}) async {
    try {
      final response = await authApi.setMPIN(mpin: mpin);
      if (response != null) {
        return SetUserDetailsModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<SetUserDetailsModel?> setUserDetails({
    String? userName,
    String? mpin,
    String? osVersion,
    String? model,
    String? appVersion,
    String? brandName,
    String? deviceOs,
    String? manufacturer,
    String? city,
    String? country,
    String? state,
    String? street,
    String? postalCode,
    String? fullName,
    String? password,
  }) async {
    try {
      final response = await authApi.setUserDetails(
        userName: userName,
        fullName: fullName,
        password: password,
        mpin: mpin,
        osVersion: osVersion,
        appVersion: appVersion,
        brandName: brandName,
        model: model,
        deviceOs: deviceOs,
        manufacturer: manufacturer,
        city: city,
        country: country,
        state: state,
        street: street,
        postalCode: postalCode,
      );
      if (response != null) {
        return SetUserDetailsModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<dynamic> fcmToken({
    int? id,
    String? fcmToken1,
  }) async {
    try {
      final response = await authApi.fcmToken(id: id, fcmToken1: fcmToken1);
      if (response != null) {
        return response.data;
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<SignInModel?> forgotPassword({
    String? countryCodeFP,
    String? phoneNumberFP,
  }) async {
    try {
      final response = await authApi.forgotPassword(
        countryCodeFP: countryCodeFP,
        phoneNumberFP: phoneNumberFP,
      );
      if (response != null) {
        return SignInModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<dynamic> resetPass({
    String? countryCode,
    String? password,
    String? phoneNumber,
    String? otp,
    String? confirmPassword,
  }) async {
    try {
      final response = await authApi.resetPass(
        password: password,
        otp: otp,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        confirmPassword: confirmPassword,
      );
      if (response != null) {
        return response.data;
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<dynamic> forgotMPI() async {
    try {
      final response = await authApi.forgotMPI();
      if (response != null) {
        return response.data;
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<dynamic> verifyMPIN({
    String? id,
    String? mpin,
    String? deviceId,
    String? city,
    String? country,
    String? state,
    String? street,
    String? postalCode,
  }) async {
    try {
      final response = await authApi.verifyMPIN(
          id: id,
          mpin: mpin,
          deviceId: deviceId,
          city: city,
          country: country,
          state: state,
          street: street,
          postalCode: postalCode);
      if (response != null) {
        return response.data;
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<dynamic> changeMPIN({
    String? oldMPIN,
    String? newMPIN,
    String? reEnterMPIN,
  }) async {
    try {
      final response = await authApi.changeMPIN(
        newMPIN: newMPIN,
        oldMPIN: oldMPIN,
        reEnterMPIN: reEnterMPIN,
      );
      if (response != null) {
        return response.data;
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<dynamic> changePassword({
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
  }) async {
    try {
      final response = await authApi.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      if (response != null) {
        return response.data;
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<dynamic> appVersionCheck() async {
    try {
      final response = await authApi.appVersionCheck();
      if (response != null) {
        return response.data;
      }
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }
}
