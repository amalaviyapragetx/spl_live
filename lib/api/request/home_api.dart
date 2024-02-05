import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/api/dio_client.dart';
import 'package:spllive/utils/constant.dart';

class HomeApi {
  final DioClient dioClient;
  HomeApi({required this.dioClient});

  Future<Response?> getBannerData() async {
    try {
      final response = await dioClient.get(
        EndPoints.bennerApi,
        options: Options(headers: {"Authorization": "Bearer ${GetStorage().read(ConstantsVariables.authToken)}"}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> getDailyMarkets() async {
    try {
      final response = await dioClient.get(
        EndPoints.getDailyMarkets,
        options: Options(headers: {"Authorization": "Bearer ${GetStorage().read(ConstantsVariables.authToken)}"}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> getDailyStarLineMarkets({String? startDate, String? endDate}) async {
    try {
      final response = await dioClient.get(
        EndPoints.getDailyStarLineMarkets,
        queryParameters: {
          "startDate": startDate,
          "endDate": endDate,
        },
        options: Options(headers: {"Authorization": "Bearer ${GetStorage().read(ConstantsVariables.authToken)}"}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> getBalance() async {
    try {
      final response = await dioClient.get(
        EndPoints.getBalance,
        options: Options(headers: {"Authorization": "Bearer ${GetStorage().read(ConstantsVariables.authToken)}"}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> getNotificationCount() async {
    try {
      final response = await dioClient.get(
        EndPoints.getNotificationCount,
        options: Options(headers: {"Authorization": "Bearer ${GetStorage().read(ConstantsVariables.authToken)}"}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> getAllNotifications() async {
    try {
      final response = await dioClient.get(
        EndPoints.getAllNotifications,
        options: Options(headers: {"Authorization": "Bearer ${GetStorage().read(ConstantsVariables.authToken)}"}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
