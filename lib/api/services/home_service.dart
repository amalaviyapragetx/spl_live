import 'package:dio/dio.dart';
import 'package:spllive/api/dio_exceptions.dart';
import 'package:spllive/api/request/home_api.dart';
import 'package:spllive/models/balance_model.dart';
import 'package:spllive/models/banner_model.dart';
import 'package:spllive/models/daily_market_api_response_model.dart';
import 'package:spllive/models/notifiaction_models/get_all_notification_model.dart';
import 'package:spllive/models/notifiaction_models/notification_count_model.dart';
import 'package:spllive/models/starline_daily_market_api_response.dart';

class HomeService {
  final HomeApi authApi;
  HomeService(this.authApi);

  Future<BannerModel?> getBannerData() async {
    try {
      final response = await authApi.getBannerData();
      if (response != null) {
        return BannerModel.fromJson(response.data);
      }
    } catch (e) {
      final errorMessage = DioExceptions.fromDioError(e as DioException);
      throw errorMessage;
    }
    return null;
  }

  Future<DailyMarketApiResponseModel?> getDailyMarkets() async {
    try {
      final response = await authApi.getDailyMarkets();
      if (response != null) {
        return DailyMarketApiResponseModel.fromJson(response.data);
      }
    } catch (e) {
      final errorMessage = DioExceptions.fromDioError(e as DioException);
      throw errorMessage;
    }
    return null;
  }

  Future<StarLineDailyMarketApiResponseModel?> getDailyStarLineMarkets({String? startDate, String? endDate}) async {
    try {
      final response = await authApi.getDailyStarLineMarkets(startDate: startDate, endDate: endDate);
      if (response != null) {
        return StarLineDailyMarketApiResponseModel.fromJson(response.data);
      }
    } catch (e) {
      final errorMessage = DioExceptions.fromDioError(e as DioException);
      throw errorMessage;
    }
    return null;
  }

  Future<BalanceModel?> getBalance() async {
    try {
      final response = await authApi.getBalance();
      if (response != null) {
        return BalanceModel.fromJson(response.data);
      }
    } catch (e) {
      final errorMessage = DioExceptions.fromDioError(e as DioException);
      throw errorMessage;
    }
    return null;
  }

  Future<NotifiactionCountModel?> getNotificationCount() async {
    try {
      final response = await authApi.getNotificationCount();
      if (response != null) {
        return NotifiactionCountModel.fromJson(response.data);
      }
    } catch (e) {
      final errorMessage = DioExceptions.fromDioError(e as DioException);
      throw errorMessage;
    }
    return null;
  }

  Future<GetAllNotificationsData?> getAllNotifications() async {
    try {
      final response = await authApi.getAllNotifications();
      if (response != null) {
        return GetAllNotificationsData.fromJson(response.data);
      }
    } catch (e) {
      final errorMessage = DioExceptions.fromDioError(e as DioException);
      throw errorMessage;
    }
    return null;
  }
}
