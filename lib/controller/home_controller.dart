import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spllive/api/service_locator.dart';
import 'package:spllive/api/services/home_service.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/balance_model.dart';
import 'package:spllive/models/banner_model.dart';
import 'package:spllive/models/daily_market_api_response_model.dart';
import 'package:spllive/models/notifiaction_models/get_all_notification_model.dart';
import 'package:spllive/models/notifiaction_models/notification_count_model.dart';
import 'package:spllive/models/starline_daily_market_api_response.dart';

class HomeController extends GetxController {
  Map<String, String>? headers = {};
  Map<String, String>? headersWithToken = {};
  Map<String, String>? headersWithImageAndToken = {};
  String contentType = "";
  String authToken = '';
  final homeService = getIt.get<HomeService>();

  // Future<BannerModel?> getBannerData() async {
  //   try {
  //     final resp = await homeService.getBannerData();
  //     if (resp != null) {
  //       // return resp;
  //     }
  //   } catch (e) {
  //     AppUtils.hideProgressDialog();
  //     AppUtils.showErrorSnackBar(bodyText: e.toString());
  //     return null;
  //   }
  // }

  RxBool load = false.obs;
  RxList<BannerDataModel> bannerData = <BannerDataModel>[].obs;
  Rx<BannerModel>? bannerModel = BannerModel().obs;
  Rx<DailyMarketApiResponseModel> dailyMarketModel = DailyMarketApiResponseModel().obs;
  RxList<MarketData> normalMarketList = <MarketData>[].obs;
  RxBool noMarketFound = false.obs;

  Rx<StarLineDailyMarketApiResponseModel> starLineModel = StarLineDailyMarketApiResponseModel().obs;
  RxList<StarlineMarketData> starLineMarketList = <StarlineMarketData>[].obs;
  Rx<BalanceModel> balanceModel = BalanceModel().obs;
  RxString walletBalance = "00".obs;
  Rx<NotifiactionCountModel> notificationModel = NotifiactionCountModel().obs;
  Rx<GetAllNotificationsData> getAllNotificationModel = GetAllNotificationsData().obs;
  RxInt getNotificationCount = 0.obs;

  RxList<NotificationData> notificationData = <NotificationData>[].obs;
  getHomeData() async {
    try {
      load.value = true;
      final resp = await Future.wait([
        homeService.getBannerData(),
        homeService.getDailyMarkets(),
        homeService.getBalance(),
        homeService.getNotificationCount(),
        homeService.getAllNotifications()
      ]);
      if (resp.isNotEmpty) {
        if (resp[0].runtimeType == BannerModel) {
          bannerModel?.value = resp[0] as BannerModel;
          if (bannerModel?.value.status ?? false) {
            bannerData.value = bannerModel?.value.data ?? [];
          }
        }
        if (resp[1].runtimeType == DailyMarketApiResponseModel) {
          dailyMarketModel.value = resp[1] as DailyMarketApiResponseModel;
          if (dailyMarketModel.value.status ?? false) {
            if (dailyMarketModel.value.data != null && dailyMarketModel.value.data!.isNotEmpty) {
              normalMarketList.value = dailyMarketModel.value.data ?? [];
              noMarketFound.value = false;
              var biddingOpenMarketList = normalMarketList
                  .where((element) =>
                      (element.isBidOpenForClose == true || element.isBidOpenForOpen == true) &&
                      element.isBlocked == false)
                  .toList();
              var biddingClosedMarketList = normalMarketList
                  .where((element) =>
                      (element.isBidOpenForOpen == false && element.isBidOpenForClose == false) &&
                      element.isBlocked == false)
                  .toList();
              var tempFinalMarketList = <MarketData>[];
              biddingOpenMarketList.sort((a, b) {
                DateTime dateTimeA = DateFormat('hh:mm a').parse(a.openTime ?? "00:00 AM");
                DateTime dateTimeB = DateFormat('hh:mm a').parse(b.openTime ?? "00:00 AM");
                return dateTimeA.compareTo(dateTimeB);
              });
              tempFinalMarketList = biddingOpenMarketList;
              biddingClosedMarketList.sort((a, b) {
                DateTime dateTimeA = DateFormat('hh:mm a').parse(a.openTime ?? "00:00 AM");
                DateTime dateTimeB = DateFormat('hh:mm a').parse(b.openTime ?? "00:00 AM");
                return dateTimeA.compareTo(dateTimeB);
              });
              tempFinalMarketList.addAll(biddingClosedMarketList);
              normalMarketList.value = tempFinalMarketList;
            } else {
              noMarketFound.value = true;
            }
          }
          load.value = false;
        }
        // if (resp[2].runtimeType == StarLineDailyMarketApiResponseModel) {
        //   starLineModel.value = resp[2] as StarLineDailyMarketApiResponseModel;
        //   if (starLineModel.value.status ?? false) {
        //     if (starLineModel.value.data?.isNotEmpty ?? false) {
        //       var biddingOpenMarketList = starLineModel.value.data
        //           ?.where((element) => element.isBidOpen == true && element.isBlocked == false)
        //           .toList();
        //       var biddingClosedMarketList = starLineModel.value.data
        //           ?.where((element) => element.isBidOpen == false && element.isBlocked == false)
        //           .toList();
        //       var tempFinalMarketList = <StarlineMarketData>[];
        //       biddingOpenMarketList?.sort((a, b) {
        //         DateTime dateTimeA = DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
        //         DateTime dateTimeB = DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
        //         return dateTimeA.compareTo(dateTimeB);
        //       });
        //       tempFinalMarketList = biddingOpenMarketList ?? [];
        //       biddingClosedMarketList?.sort((a, b) {
        //         DateTime dateTimeA = DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
        //         DateTime dateTimeB = DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
        //         return dateTimeA.compareTo(dateTimeB);
        //       });
        //       tempFinalMarketList.addAll(biddingClosedMarketList ?? []);
        //       starLineMarketList.value = tempFinalMarketList;
        //     }
        //   }
        // }
        if (resp[2].runtimeType == BalanceModel) {
          balanceModel.value = resp[2] as BalanceModel;
          if (balanceModel.value.status ?? false) {
            var tempBalance = balanceModel.value.data?.Amount ?? 00;
            walletBalance.value = tempBalance.toString();
          }
        }
        if (resp[3].runtimeType == NotifiactionCountModel) {
          notificationModel.value = resp[3] as NotifiactionCountModel;
          if (notificationModel.value.status ?? false) {
            getNotificationCount.value = notificationModel.value.data!.notificationCount == null
                ? 0
                : notificationModel.value.data!.notificationCount!.toInt();
            if (notificationModel.value.message!.isNotEmpty) {
              AppUtils.showSuccessSnackBar(bodyText: notificationModel.value.message, headerText: "SUCCESSMESSAGE".tr);
            }
          }
        }
        if (resp[4].runtimeType == GetAllNotificationsData) {
          getAllNotificationModel.value = resp[4] as GetAllNotificationsData;
          if (getAllNotificationModel.value.status ?? false) {
            notificationData.value = getAllNotificationModel.value.data!.rows as List<NotificationData>;
          }
          load.value = false;
        }
      }
    } catch (e) {
      load.value = false;
    }
  }
}
