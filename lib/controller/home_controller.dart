import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:spllive/api_services/api_service.dart';
import 'package:spllive/helper_files/constant_variables.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/banner_model.dart';
import 'package:spllive/models/commun_models/user_details_model.dart';
import 'package:spllive/models/daily_market_api_response_model.dart';
import 'package:spllive/models/market_bid_history.dart';
import 'package:spllive/models/normal_market_bid_history_response_model.dart';
import 'package:spllive/models/notifiaction_models/get_all_notification_model.dart';
import 'package:spllive/models/notifiaction_models/notification_count_model.dart';
import 'package:spllive/screens/bottum_navigation_screens/moreoptions.dart';
import 'package:spllive/screens/bottum_navigation_screens/passbook_page.dart';
import 'package:spllive/screens/bottum_navigation_screens/spl_wallet.dart';
import 'package:spllive/screens/new_ui/bottom_bar_screens/home_screen.dart';

import '../screens/new_ui/bottom_bar_screens/bid_history_new.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxInt pageWidget = 0.obs;
  final notificationCount = Rxn<int>();
  RxList<BannerData> bannerData = <BannerData>[].obs;
  RxList<MarketData> normalMarketList = <MarketData>[].obs;
  RxList<MarketData> normalMarketFilterList = <MarketData>[].obs;
  RxInt getNotificationCount = 0.obs;
  getDashBoardPages(index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return BidHistoryNew();
      case 2:
        return SPLWallet();
      case 3:
        return PassBook();
      case 4:
        return MoreOptions();
    }
  }

  void getBannerData() async {
    ApiService().getBennerData().then((value) async {
      BannerModel model = BannerModel.fromJson(value);
      if (model.status ?? false) {
        bannerData.value = model.data ?? [];
      } else {
        AppUtils.showErrorSnackBar(bodyText: model.message ?? "");
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
          normalMarketList.forEach((e) {
            filterMarketList.add(FilterModel(isSelected: false.obs, name: e.market, id: e.marketId));
          });
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

  //// Normal Market bids
  RxList<MarketBidHistoryList> marketBidHistoryList = <MarketBidHistoryList>[].obs;
  RxInt offset = 0.obs;
  RxList<ResultArr> marketHistoryList = <ResultArr>[].obs;
  DateTime startEndDate = DateTime.now();
  List<FilterModel> winStatusList = [
    FilterModel(id: 1, name: 'Win', isSelected: false.obs),
    FilterModel(id: 2, name: 'Loss', isSelected: false.obs),
    FilterModel(id: 3, name: 'Pending', isSelected: false.obs)
  ];
  List<FilterModel> gameTypeList = [
    FilterModel(id: 1, name: "OPEN", isSelected: false.obs),
    FilterModel(id: 2, name: "CLOSE", isSelected: false.obs),
  ];
  List<FilterModel> filterMarketList = [];
  var isSelectedGameIndex = Rxn<int>();
  var isSelectedWinStatusIndex = Rxn<int>();
  RxList<int> selectedFilterMarketList = <int>[].obs;

  void marketBidsByUserId() async {
    UserDetailsModel userData = UserDetailsModel.fromJson(GetStorage().read(ConstantsVariables.userData));
    ApiService()
        .bidHistoryByUserId(
      userId: userData.id.toString(),
      gameType: "${isSelectedGameIndex.value}",
      winningStatus: "${isSelectedWinStatusIndex.value}",
      markets: selectedFilterMarketList.value,
    )
        .then(
      (value) async {
        if (value['status']) {
          if (value['data'] != null) {
            MarketBidHistory model = MarketBidHistory.fromJson(value['data']);
            marketBidHistoryList.value = model.rows ?? <MarketBidHistoryList>[];
            if (isSelectedGameIndex.value != null ||
                isSelectedWinStatusIndex.value != null ||
                selectedFilterMarketList.isNotEmpty) {
              Get.back();
            }
          }
        } else {
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        }
      },
    );
  }

  ///// notifications

  RxList<NotificationData> notificationData = <NotificationData>[].obs;
  void getNotificationsData() async {
    ApiService().getAllNotifications().then((value) async {
      if (value['status']) {
        GetAllNotificationsData model = GetAllNotificationsData.fromJson(value);
        notificationData.value = model.data!.rows as List<NotificationData>;
        if (model.message!.isNotEmpty) {
          // AppUtils.showSuccessSnackBar(
          //     bodyText: model.message, headerText: "SUCCESSMESSAGE".tr);
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  void resetNotificationCount() async {
    ApiService().resetNotification().then((value) async {
      if (value['status']) {
        NotifiactionCountModel model = NotifiactionCountModel.fromJson(value);
        getNotificationCount.value = model.data!.notificationCount!.toInt();

        if (model.message!.isNotEmpty) {}
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  void getNotificationCountData() async {
    ApiService().getNotificationCount().then((value) async {
      if (value['status']) {
        NotifiactionCountModel model = NotifiactionCountModel.fromJson(value);
        getNotificationCount.value = model.data!.notificationCount == null ? 0 : model.data!.notificationCount!.toInt();
        if (model.message!.isNotEmpty) {
          AppUtils.showSuccessSnackBar(bodyText: model.message, headerText: "SUCCESSMESSAGE".tr);
        }
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }
}

class FilterModel {
  final int? id;
  final String? name;
  final RxBool isSelected;

  FilterModel({this.id, this.name, required this.isSelected});
}
