import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:spllive/api/service_locator.dart';
import 'package:spllive/api/services/home_service.dart';
import 'package:spllive/api_services/api_service.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/balance_model.dart';
import 'package:spllive/models/banner_model.dart';
import 'package:spllive/models/commun_models/bid_request_model.dart';
import 'package:spllive/models/commun_models/starline_bid_request_model.dart';
import 'package:spllive/models/daily_market_api_response_model.dart';
import 'package:spllive/models/normal_market_bid_history_response_model.dart';
import 'package:spllive/models/notifiaction_models/get_all_notification_model.dart';
import 'package:spllive/models/notifiaction_models/notification_count_model.dart';
import 'package:spllive/models/starline_daily_market_api_response.dart';
import 'package:spllive/models/starlinechar_model/new_starlinechart_model.dart';
import 'package:spllive/screens/More%20Details%20Screens/Withdrawal%20Page/withdrawal_page.dart';
import 'package:spllive/screens/bottum_navigation_screens/bid_history.dart';
import 'package:spllive/screens/bottum_navigation_screens/moreoptions.dart';
import 'package:spllive/screens/bottum_navigation_screens/passbook_page.dart';
import 'package:spllive/screens/bottum_navigation_screens/spl_wallet.dart';
import 'package:spllive/screens/home_pages/home_screen.dart';
import 'package:spllive/utils/constant.dart';

class HomeController extends GetxController {
  RxInt widgetContainer = 0.obs;
  RxInt pageWidget = 0.obs;
  RxBool isStarline = false.obs;
  RxInt currentIndex = 0.obs;
  final homeService = getIt.get<HomeService>();
  var position = 0;

  void getBannerData() async {
    try {
      final resp = await homeService.getBannerData();
      if (resp != null) {
        if (resp.status ?? false) {
          bannerData.value = bannerModel?.value.data ?? [];
        }
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: e.toString());
      return null;
    }
  }

  void getDailyStarLineMarkets({String? startDate, String? endDate}) async {
    try {
      final resp = await homeService.getDailyStarLineMarkets(startDate: startDate, endDate: endDate);
      if (resp != null) {
        if (resp.status ?? false) {
          starLineModel.value = resp;

          ///marketList.value = starLineModel.value.data ?? <StarlineMarketData>[];
          marketListForResult.value = starLineModel.value.data ?? <StarlineMarketData>[];
          if (starLineModel.value.data?.isNotEmpty ?? false) {
            var biddingOpenMarketList = starLineModel.value.data
                ?.where((element) => element.isBidOpen == true && element.isBlocked == false)
                .toList();
            var biddingClosedMarketList = starLineModel.value.data
                ?.where((element) => element.isBidOpen == false && element.isBlocked == false)
                .toList();
            var tempFinalMarketList = <StarlineMarketData>[];
            biddingOpenMarketList?.sort((a, b) {
              DateTime dateTimeA = DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
              DateTime dateTimeB = DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
              return dateTimeA.compareTo(dateTimeB);
            });
            tempFinalMarketList = biddingOpenMarketList ?? [];
            biddingClosedMarketList?.sort((a, b) {
              DateTime dateTimeA = DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
              DateTime dateTimeB = DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
              return dateTimeA.compareTo(dateTimeB);
            });
            tempFinalMarketList.addAll(biddingClosedMarketList ?? []);
            starLineMarketList.value = tempFinalMarketList;
            marketListForResult.sort((a, b) {
              DateTime dateTimeA = DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
              DateTime dateTimeB = DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
              return dateTimeA.compareTo(dateTimeB);
            });
          }
        }
      }
    } catch (e) {
      AppUtils.hideProgressDialog();
      AppUtils.showErrorSnackBar(bodyText: e.toString());
      return null;
    }
  }

  RxList<ResultArr> marketHistoryList = <ResultArr>[].obs;
  RxInt offset = 0.obs;
  DateTime startEndDate = DateTime.now();
  TextEditingController bidHistoryController = TextEditingController();
  void getMarketBidsByUserId({bool? lazyLoad, String? startDate, String? endDate}) {
    ApiService()
        .getBidHistoryByUserId(
      userId: "${GetStorage().read(ConstantsVariables.id) ?? ""}",
      startDate: startDate,
      endDate: endDate,
      limit: "5000",
      offset: offset.value.toString(),
      isStarline: isStarline.value,
    )
        .then(
      (value) {
        if (value['status']) {
          if (value['data'] != null) {
            NormalMarketBidHistoryResponseModel model = NormalMarketBidHistoryResponseModel.fromJson(value);
            lazyLoad ?? false
                ? marketHistoryList.addAll(model.data?.resultArr ?? <ResultArr>[])
                : marketHistoryList.value = model.data?.resultArr ?? <ResultArr>[];
          }
        } else {
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        }
      },
    );
  }

  void onTapOfStarlineMarket(StarlineMarketData market) {
    if (market.isBidOpen ?? false) {
      Get.toNamed(AppRouteNames.starLineGameModesPage, arguments: market);
    } else {
      AppUtils.showErrorSnackBar(bodyText: "Bidding is Closed!!!!");
    }
  }

  // result History

  TextEditingController dateInputForResultHistory = TextEditingController();
  DateTime bidHistoryDate = DateTime.now();
  RxList<StarlineMarketData> marketListForResult = <StarlineMarketData>[].obs;

  String getResult(bool resultDeclared, int result) {
    if (resultDeclared) {
      int sum = 0;
      for (int i = result; i > 0; i = (i / 10).floor()) {
        sum += (i % 10);
      }
      return "$result - ${sum % 10}";
    } else {
      return "***-*";
    }
  }

  // starLine Char  page

  RxList<StarLineDateTime> starlineChartDateAndTime = <StarLineDateTime>[].obs;
  RxList<Markets> starlineChartTime = <Markets>[].obs;
  void getStarlineChart() async {
    ApiService().getStarlineChart().then((value) async {
      if (value['status']) {
        NewStarLineChartModel model = NewStarLineChartModel.fromJson(value);
        starlineChartDateAndTime.value = model.data!.data!;
        for (var i = 0; i < model.data!.markets!.length; i++) {
          starlineChartTime.value = model.data!.markets as List<Markets>;
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  String getResult2(bool resultDeclared, int result) {
    if (resultDeclared) {
      int sum = 0;
      for (int i = result; i > 0; i = (i / 10).floor()) {
        sum += (i % 10);
      }

      return "$result";
    } else {
      return "***";
    }
  }

  String getResult3(bool resultDeclared, int result) {
    if (resultDeclared) {
      int sum = 0;
      for (int i = result; i > 0; i = (i / 10).floor()) {
        sum += (i % 10);
      }
      return "${sum % 10}";
    } else {
      return "*";
    }
  }

  // main Home page market Data
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

  RxList<Bids> selectedBidsList = <Bids>[].obs;
  RxBool starlineCheck = false.obs;
  RxList<StarLineBids> bidList = <StarLineBids>[].obs;
  void setBoolData() {
    GetStorage().write(ConstantsVariables.timeOut, true);
    GetStorage().write(ConstantsVariables.mPinTimeOut, false);
    GetStorage().write(ConstantsVariables.bidsList, selectedBidsList);
    GetStorage().write(ConstantsVariables.starlineBidsList, bidList);
    GetStorage().write(ConstantsVariables.totalAmount, "0");
    GetStorage().write(ConstantsVariables.marketName, "");
    GetStorage().write(ConstantsVariables.marketNotification, true);
    GetStorage().write(ConstantsVariables.starlineNotification, true);
    starlineCheck.value = GetStorage().read(ConstantsVariables.starlineConnect) ?? false;
    starlineCheck.value == true ? widgetContainer.value = 1 : widgetContainer.value;
    starlineCheck.value == true ? isStarline.value = true : isStarline.value;
    getHomeData();
    Timer(const Duration(seconds: 1), () => GetStorage().write(ConstantsVariables.starlineConnect, false));
  }

  void getNotificationsData() async {
    ApiService().getAllNotifications().then((value) async {
      if (value['status']) {
        GetAllNotificationsData model = GetAllNotificationsData.fromJson(value);
        notificationData.value = model.data!.rows as List<NotificationData>;
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  Widget getDashBoardPages(index, BuildContext context, {required String notificationCount}) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return BidHistory(appbarTitle: "Your Market");
      case 2:
        return SPLWallet();
      case 3:
        return PassBook();
      case 4:
        return MoreOptions();
      case 5:
        return WithdrawalPage();
      default:
        return const HomeScreen();
    }
  }
}
// SafeArea(
// child: SingleChildScrollView(
// scrollDirection: Axis.vertical,
// child: Column(
// children: [
// SizedBox(height: Dimensions.h10),
// Obx(
// () => CarouselSlider(
// items: bannerData
//     .map(
// (element) => Builder(
// builder: (context) => Padding(
// padding: EdgeInsets.symmetric(horizontal: Dimensions.h7),
// child: CachedNetworkImage(
// imageUrl: element.banner ?? "",
// fit: BoxFit.cover,
// placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
// errorWidget: (context, url, error) => const Icon(Icons.error),
// ),
// ),
// ),
// )
//     .toList(),
// options: CarouselOptions(
// height: Dimensions.h90,
// enlargeCenterPage: true,
// autoPlay: true,
// aspectRatio: 15 / 4,
// autoPlayCurve: Curves.fastOutSlowIn,
// enableInfiniteScroll: true,
// autoPlayAnimationDuration: const Duration(milliseconds: 600),
// viewportFraction: 1,
// ),
// ),
// ),
// SizedBox(height: Dimensions.h10),
// Padding(
// padding: EdgeInsets.symmetric(horizontal: Dimensions.h10),
// child: Container(
// decoration: BoxDecoration(
// color: AppColors.white,
// boxShadow: [
// BoxShadow(
// spreadRadius: 1,
// color: AppColors.grey,
// blurRadius: 7,
// offset: const Offset(6, 4),
// )
// ],
// borderRadius: BorderRadius.circular(Dimensions.h5),
// border: Border.all(color: AppColors.redColor, width: 1),
// ),
// //padding: const EdgeInsets.symmetric(horizontal: 60),
// child: Column(
// children: [
// SizedBox(height: Dimensions.h10),
// HomeScreenUtils().iconsContainer(
// iconColor1: widgetContainer.value == 0 ? AppColors.appbarColor : AppColors.iconColorMain,
// iconColor2: widgetContainer.value == 1 ? AppColors.appbarColor : AppColors.iconColorMain,
// iconColor3: widgetContainer.value == 2 ? AppColors.appbarColor : AppColors.iconColorMain,
// onTap1: () {
// position = 0;
// widgetContainer.value = position;
// isStarline.value = false;
// // print(widgetContainer.value);
// },
// onTap2: () {
// position = 1;
// isStarline.value = true;
// widgetContainer.value = position;
// //   print(widgetContainer.value);
// },
// onTap3: () {
// position = 2;
// widgetContainer.value = position;
// isStarline.value = false;
// },
// ),
// SizedBox(height: Dimensions.h10),
// Obx(
// () {
// return isStarline.value
// ? HomeScreenUtils().iconsContainer2(
// iconColor1:
// widgetContainer.value == 3 ? AppColors.appbarColor : AppColors.iconColorMain,
// iconColor2:
// widgetContainer.value == 4 ? AppColors.appbarColor : AppColors.iconColorMain,
// iconColor3:
// widgetContainer.value == 5 ? AppColors.appbarColor : AppColors.iconColorMain,
// onTap1: () {
// position = 3;
// widgetContainer.value = position;
// },
// onTap2: () {
// position = 4;
// widgetContainer.value = position;
// },
// onTap3: () {
// position = 5;
// widgetContainer.value = position;
// })
//     : Container();
// },
// ),
// SizedBox(height: Dimensions.h10),
// ],
// ),
// ),
// ),
// ],
// ),
// ),
// );
