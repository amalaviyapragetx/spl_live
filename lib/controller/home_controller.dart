import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spllive/api_services/api_service.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/benner_model.dart';
import 'package:spllive/models/daily_market_api_response_model.dart';
import 'package:spllive/screens/bottom_bar_screens/home_screen.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxInt pageWidget = 0.obs;
  final notificationCount = Rxn<int>();
  RxList<BannerData> bannerData = <BannerData>[].obs;
  RxList<MarketData> normalMarketList = <MarketData>[].obs;
  getDashBoardPages(index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return Container();
      case 2:
        return Container();
      case 3:
        return Container();
    }
  }

  void getBannerData() async {
    ApiService().getBannerData().then((value) async {
      if (value != null) {
        if (value.status ?? false) {
          bannerData.value = value.data as List<BannerData>;
          //  NotifiactionCountModel model = NotifiactionCountModel.fromJson(value);
          // getNotifiactionCount.value = model.data!.notificationCount!.toInt();
          // if (model.message!.isNotEmpty) {}
        } else {
          AppUtils.showErrorSnackBar(bodyText: value.message ?? "");
        }
      }
    });
  }

  RxBool noMarketFound = false.obs;
  void getDailyMarkets() async {
    final resp = await ApiService().getDailyMarkets();
    if (resp != null) {
      if (resp.status ?? false) {
        if (resp.data != null && resp.data!.isNotEmpty) {
          normalMarketList.value = resp.data!;
          noMarketFound.value = false;
          var biddingOpenMarketList = normalMarketList
              .where((element) =>
                  (element.isBidOpenForClose == true || element.isBidOpenForOpen == true) && element.isBlocked == false)
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
      } else {
        AppUtils.showErrorSnackBar(bodyText: resp.message ?? "");
      }
    }
  }
}
