import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/api/dio_client.dart';
import 'package:spllive/utils/constant.dart';

class AuthApi {
  final DioClient dioClient;

  AuthApi({required this.dioClient});
  Future<Response?> signIn({String? phoneNumber, String? countryCode, String? password, String? deviceId}) async {
    try {
      final response = await dioClient.post(
        EndPoints.signIN,
        data: {"countryCode": countryCode, "phoneNumber": phoneNumber, "password": password, "deviceId": deviceId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> signUP({
    String? deviceId,
    String? phoneNumber,
    String? countryCode,
  }) async {
    try {
      final response = await dioClient.post(
        EndPoints.signUP,
        data: {"countryCode": countryCode, "phoneNumber": phoneNumber, "deviceId": deviceId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> verifyUser({
    String? otp,
    String? phoneNumber,
    String? countryCode,
  }) async {
    try {
      final response = await dioClient.post(
        EndPoints.verifyUSER,
        options: Options(headers: {"Authorization": "Bearer ${GetStorage().read(ConstantsVariables.authToken)}"}),
        data: {
          "countryCode": countryCode,
          "phoneNumber": phoneNumber,
          "otp": otp,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> verifyOTP({
    String? otp,
  }) async {
    try {
      final response = await dioClient.post(
        EndPoints.verifyOTP,
        options: Options(headers: {"Authorization": "Bearer ${GetStorage().read(ConstantsVariables.authToken)}"}),
        data: {"otp": otp},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> resendOtpApi({
    String? phoneNumber,
    String? countryCode,
  }) async {
    try {
      final response = await dioClient.post(
        EndPoints.resendOTP,
        data: {"phoneNumber": phoneNumber, "countryCode": countryCode},
        options: Options(headers: {"Authorization": "Bearer ${GetStorage().read(ConstantsVariables.authToken)}"}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> setMPIN({String? mpin}) async {
    try {
      final response = await dioClient.post(
        EndPoints.setMPIN,
        data: {"mPin": mpin},
        options: Options(headers: {"Authorization": "Bearer ${GetStorage().read(ConstantsVariables.authToken)}"}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> setUserDetails({
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
      final response = await dioClient.post(
        EndPoints.setUserDetails,
        data: userName == null
            ? {
                "oSVersion": osVersion,
                "appVersion": appVersion,
                "brandName": brandName,
                "model": model,
                "os": deviceOs,
                "manufacturer": manufacturer,
                "city": city,
                "country": country,
                "state": state,
                "street": street,
                "postalCode": postalCode
              }
            : {
                "userName": userName,
                "fullName": fullName,
                "password": password,
                "mPin": mpin,
                "oSVersion": osVersion,
                "appVersion": appVersion,
                "brandName": brandName,
                "model": model,
                "os": deviceOs,
                "manufacturer": manufacturer,
                "city": city,
                "country": country,
                "state": state,
                "street": street,
                "postalCode": postalCode
              },
        options: Options(headers: {"Authorization": "Bearer ${GetStorage().read(ConstantsVariables.authToken)}"}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> fcmToken({
    int? id,
    String? fcmToken1,
  }) async {
    try {
      final response = await dioClient.post(
        EndPoints.fcmToken,
        data: {"id": id, "fcmToken": fcmToken1},
        options: Options(
          headers: {'Authorization': "Bearer ${GetStorage().read(ConstantsVariables.authToken) ?? ""}"},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> forgotPassword({
    String? countryCodeFP,
    String? phoneNumberFP,
  }) async {
    try {
      final response = await dioClient.post(
        EndPoints.forgotPassword,
        data: {"countryCode": countryCodeFP, "phoneNumber": phoneNumberFP},
        options: Options(
          headers: {'Authorization': "Bearer ${GetStorage().read(ConstantsVariables.authToken) ?? ""}"},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> resetPass({
    String? countryCode,
    String? password,
    String? phoneNumber,
    String? otp,
    String? confirmPassword,
  }) async {
    try {
      final response = await dioClient.post(
        EndPoints.resetPassword,
        data: {
          "countryCode": countryCode,
          "phoneNumber": phoneNumber,
          "otp": otp,
          "password": password,
          "confirmPassword": confirmPassword,
        },
        options: Options(
          headers: {'Authorization': "Bearer ${GetStorage().read(ConstantsVariables.authToken) ?? ""}"},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> forgotMPI() async {
    try {
      final response = await dioClient.get(
        EndPoints.forgotMPIN,
        options: Options(
          headers: {'Authorization': "Bearer ${GetStorage().read(ConstantsVariables.authToken) ?? ""}"},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> verifyMPIN({
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
      final response = await dioClient.post(
        EndPoints.verifyMPIN,
        data: {
          "id": id,
          "mPin": mpin,
          "deviceId": deviceId,
          "city": city,
          "country": country,
          "state": state,
          "street": street,
          "postalCode": postalCode
        },
        options: Options(
          headers: {'Authorization': "Bearer ${GetStorage().read(ConstantsVariables.authToken) ?? ""}"},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> changeMPIN({
    String? oldMPIN,
    String? newMPIN,
    String? reEnterMPIN,
  }) async {
    try {
      final response = await dioClient.put(
        EndPoints.changeMPIN,
        data: {
          "oldMPin": oldMPIN,
          "confirmMPin": newMPIN,
          "mPin": reEnterMPIN,
        },
        options: Options(
          headers: {'Authorization': "Bearer ${GetStorage().read(ConstantsVariables.authToken) ?? ""}"},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> changePassword({
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
  }) async {
    try {
      final response = await dioClient.post(
        EndPoints.changePassword,
        data: {
          "oldPassword": oldPassword,
          "password": newPassword,
          "confirmPassword": confirmPassword,
        },
        options: Options(
          headers: {'Authorization': "Bearer ${GetStorage().read(ConstantsVariables.authToken) ?? ""}"},
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> appVersionCheck() async {
    try {
      final response = await dioClient.get(EndPoints.getVersion);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
