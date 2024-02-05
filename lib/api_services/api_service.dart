import 'package:get/get.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../helper_files/constant_variables.dart';
import '../screens/Local Storage.dart';
import 'api_urls.dart';
import 'network_info.dart';

class ApiService extends GetConnect implements GetxService {
  Map<String, String>? headers = {};
  Map<String, String>? headersWithToken = {};
  String contentType = "";
  String authToken = '';
  @override
  final allowAutoSignedCert = true;
  @override
  void onInit() {
    allowAutoSignedCert = true;
    super.onInit();
  }

  Future<void> initApiService() async {
    authToken = await LocalStorage.read(ConstantsVariables.authToken) ?? "";
    await NetworkInfo.checkNetwork().whenComplete(() async {
      //    print("Auth Token from API service is :- $authToken");
      headers = {"Accept": "application/json"};
      headersWithToken = {"Accept": "application/json", "Authorization": "Bearer $authToken"};
    });
  }

  Future<dynamic> signUpAPI(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.signUP,
      body,
      headers: headers,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(
        bodyText: response.status.code.toString() + response.toString(),
      );
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> signInAPI(body) async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      await initApiService();
      final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
        ApiUtils.signIN,
        body,
        headers: headers,
        // contentType: contentType,
      );

      if (response.status.hasError) {
        AppUtils.hideProgressDialog();
        AppUtils.showErrorSnackBar(bodyText: "Something went wrong");
        // AppUtils.showErrorSnackBar(
        //   bodyText: response.status.code.toString() + response.toString(),
        // );
        return Future.error(response.statusText!);
      } else {
        AppUtils.hideProgressDialog();
        return response.body;
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      print(e.toString());
    }
  }

  Future<dynamic> verifyUser(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.verifyUSER,
      body,
      headers: headers,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();

      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> logout() async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.logout,
      {},
      headers: headersWithToken,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> forgotPassword(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.forgotPassword,
      body,
      headers: headers,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> resetPassword(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.resetPassword,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getBankDetails(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.getBankDetails,
      body,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> editBankDetails(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.editBankDetails,
      body,
      headers: headersWithToken,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getDailyMarkets() async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.getDailyMarkets,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getGameModes({required String openCloseValue, required int marketID}) async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.getGameModes}$openCloseValue/$marketID",
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> createMarketBid(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.createMarketBid,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> createStarLineMarketBid(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.createStarLineMarketBid,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(
        bodyText: response.status.code.toString() + response.toString(),
      );
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> createWithdrawalRequest(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.createWithdrawalRequest,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getDailyStarLineMarkets({required String startDate, required String endDate}) async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.getDailyStarLineMarkets}?startDate=$startDate&endDate=$endDate",
      headers: headersWithToken,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getStarLineGameModes({required int marketID}) async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.getStarLineGameModes}$marketID",
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getTransactionHistoryById({required int userId, required int offset}) async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.getTransactionHistory}?id=$userId&limit=100&offset=$offset",
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getFeedbackAndRatingsById({required int? userId}) async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.getFeedbackAndRatingsById}$userId",
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getWithdrawalHistoryByUserId({required int? userId}) async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.getWithdrawalHistoryByUserId}$userId",
      headers: headersWithToken,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  // Future<dynamic> getWithdrawalRequestTime() async {
  //   Future.delayed(const Duration(milliseconds: 2), () {
  //     AppUtils.showProgressDialog(isCancellable: false);
  //   });

  //   await initApiService();
  //   final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
  //     ApiUtils.getWithdrawalRequestTime,
  //     headers: headersWithToken,
  //   );
  //   if (response.status.hasError) {
  //     AppUtils.hideProgressDialog();
  //     if (response.status.code != null && response.status.code == 401) {
  //       tokenExpired();
  //     }
  //     return Future.error(response.statusText!);
  //   } else {
  //     AppUtils.hideProgressDialog();
  //     return response.body;
  //   }
  // }

  Future<dynamic> getStarlineGameRates() async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.getStarlineGameRates}true",
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getGameRates({required bool forStarlineGameModes}) async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.getStarlineGameRates}$forStarlineGameModes",
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> createFeedback(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.createFeedback,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> resendOTP(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.resendOTP,
      body,
      headers: headersWithToken,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }

      return response.body;
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> verifyMPIN(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.verifyMPIN,
      body,
      headers: headersWithToken,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }

      return response.body;
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> forgotMPIN() async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.forgotMPIN,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  // new api functions

  Future<dynamic> setUserDetails(body) async {
    //  AppUtils.showProgressDialog(isCancellable: false);
    try {
      await initApiService();
      final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
        ApiUtils.setUserDetails,
        body,
        headers: headersWithToken,
      );
      if (response.status.hasError) {
        AppUtils.hideProgressDialog();
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }

        return response.body;
      } else {
        AppUtils.hideProgressDialog();
        return response.body;
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      print(e);
    }
  }

  // Future<dynamic> setDeviceDetails(body) async {
  //   try {
  //     AppUtils.showProgressDialog(isCancellable: false);
  //     await initApiService();
  //     final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).post(
  //       ApiUtils.setDeviceDetails,
  //       body,
  //       headers: headersWithToken,
  //     );
  //
  //     if (response.status.hasError) {
  //       AppUtils.hideProgressDialog();
  //       if (response.status.code != null && response.status.code == 401) {
  //         tokenExpired();
  //       }
  //
  //       return response.body;
  //     } else {
  //       AppUtils.hideProgressDialog();
  //       return response.body;
  //     }
  //   } catch (e) {
  //     AppUtils.hideProgressDialog();
  //     print(e);
  //   }
  // }

  Future<dynamic> setMPIN(body) async {
    try {
      AppUtils.showProgressDialog(isCancellable: false);
      await initApiService();
      final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
        ApiUtils.setMPIN,
        body,
        headers: headersWithToken,
      );
      if (response.status.hasError) {
        AppUtils.hideProgressDialog();
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }
        return response.body;
      } else {
        AppUtils.hideProgressDialog();
        return response.body;
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      print(e);
    }
  }

  Future<void> tokenExpired() async {
    await LocalStorage.remove(ConstantsVariables.authToken);
    AppUtils.showErrorSnackBar(bodyText: "Session timeout, sign in again");
    Get.offAllNamed(AppRoutName.signInPage);
  }

  Future<dynamic> verifyOTP(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.verifyOTP,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(
        bodyText: response.status.code.toString() + response.toString(),
      );
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getBalance() async {
    try {
      await initApiService();
      final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
        ApiUtils.getBalance,
        headers: headersWithToken,
      );
      if (response.status.hasError) {
        if (response.status.code != null && response.status.code == 401) {
          tokenExpired();
        }
        return Future.error(response.statusText!);
      } else {
        return response.body;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getBidHistoryByUserId({
    required String userId,
    required String limit,
    required String offset,
    required bool isStarline,
    required String? startDate,
    required String? endDate,
  }) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${isStarline ? ApiUtils.starlineMarketBidHistory : ApiUtils.normalMarketBidHistory}?id=$userId&limit=$limit&offset=$offset&startDate=$startDate&endDate=$endDate",
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      AppUtils.hideProgressDialog();
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> changePassword(body) async {
    // AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.changePassword,
      body,
      headers: headersWithToken,
    );

    if (response.status.hasError) {
      // AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }

      return response.body;
    } else {
      return response.body;
    }
  }

  Future<dynamic> changeMPIN(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await put(
      ApiUtils.changeMPIN,
      body,
      headers: headersWithToken,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }

      return response.body;
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getStarlineChar() async {
    Future.delayed(const Duration(milliseconds: 2), () {
      AppUtils.showProgressDialog(isCancellable: false);
    });

    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.webStarLinechar,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  // Future<dynamic> starlineMarketBidHistory({
  //   required String userId,
  //   required String limit,
  //   required String offset,
  // }) async {
  //   AppUtils.showProgressDialog(isCancellable: false);
  //   await initApiService();
  //   final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
  //     "${ApiUtils.dailyStarlineMarketBidHistory}?id=$userId&limit=$limit&offset=$offset",
  //     headers: headersWithToken,
  //   );
  //   if (response.status.hasError) {
  //     if (response.status.code != null && response.status.code == 401) {
  //       tokenExpired();
  //     }
  //     AppUtils.hideProgressDialog();

  //     return Future.error(response.statusText!);
  //   } else {
  //     AppUtils.hideProgressDialog();

  //     return response.body;
  //   }
  // }

  Future<dynamic> newGameModeApi(body, url) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      url,
      body,
      //  headers: headersWithToken,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }

      return response.body;
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getPassBookData({
    required String userId,
    required bool isAll,
    required String limit,
    required String offset,
  }) async {
    // AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.passBookApi}/$userId?isAll=$isAll&limit=$limit&offset=$offset",
      //  "${ApiUtils.dailyStarlineMarketBidHistory}?id=$userId&limit=$limit&offset=$offset",
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      AppUtils.hideProgressDialog();

      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> bidHistoryByUserId({
    required String userId,
  }) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    // final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
    //   "${ApiUtils.marketbidHistory}/$userId",
    //   headers: headersWithToken,
    // );
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      "${ApiUtils.bidHistory}?id=$userId&limit=5000&offset=0",
      headers: headersWithToken,
    );

    if (response.status.hasError) {
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      AppUtils.hideProgressDialog();

      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  // Future<dynamic> getNewMarketBidlistData({
  //   required String dailyMarketId,
  //   required String limit,
  //   required String offset,
  //   required String bidType,
  // }) async {
  //   print(
  //       "${ApiUtils.marketBidNewLists}?dailyMarketId=$dailyMarketId&limit=$limit&offset=$offset&bidType=$bidType");
  //   // AppUtils.showProgressDialog(isCancellable: false);
  //   await initApiService();

  //   final response = await GetConnect(timeout: Duration(seconds: 15), allowAutoSignedCert: true).get(
  //     "${ApiUtils.marketBidNewLists}?dailyMarketId=$dailyMarketId&limit=$limit&offset=$offset&bidType=$bidType",
  //     //  "${ApiUtils.dailyStarlineMarketBidHistory}?id=$userId&limit=$limit&offset=$offset",
  //     headers: headersWithToken,
  //   );
  //   if (response.status.hasError) {
  //     if (response.status.code != null && response.status.code == 401) {
  //       tokenExpired();
  //     }
  //     AppUtils.hideProgressDialog();

  //     return Future.error(response.statusText!);
  //   } else {
  //     AppUtils.hideProgressDialog();
  //     return response.body;
  //   }
  // }
  ///////// Notifications ///////////

  Future<dynamic> getNotificationCount() async {
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.getNotificationCount,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      AppUtils.hideProgressDialog();
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getAllNotifications() async {
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.getAllNotifications,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      AppUtils.hideProgressDialog();
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> resetNotification() async {
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.resetNotificationCount,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      AppUtils.hideProgressDialog();
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> rateApp(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.rateAppApi,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> marketNotifications(body) async {
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await put(
      ApiUtils.marketNotification,
      body,
      headers: headersWithToken,
      // contentType: contentType,
    );

    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> getBennerData() async {
    // print(ApiUtils.bennerApi);
    AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.bennerApi,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return Future.error(response.statusText!);
    } else {
      AppUtils.hideProgressDialog();
      return response.body;
    }
  }

  Future<dynamic> fcmToken(body) async {
    // AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).post(
      ApiUtils.fcmToken,
      body,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      //  AppUtils.hideProgressDialog();
      if (response.status.code != null && response.status.code == 401) {
        tokenExpired();
      }
      return response.body;
    } else {
      return response.body;
    }
  }

  Future<dynamic> appKilledStateApi() async {
    //AppUtils.showProgressDialog(isCancellable: false);
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.appKillApi,
      headers: headersWithToken,
    );
    if (response.status.hasError) {
      // AppUtils.hideProgressDialog();s
      return response.body;
    } else {
      // AppUtils.hideProgressDialog();
      // print("response2 ${response.body}");
      // print("change pass2 ${response.status.code}");
      return response.body;
    }
  }

  Future<dynamic> getAppVersion() async {
    await initApiService();
    final response = await GetConnect(timeout: const Duration(seconds: 15), allowAutoSignedCert: true).get(
      ApiUtils.getVersion,
    );

    if (response.status.hasError) {
      return response.body;
    } else {
      return response.body;
    }
  }
}
