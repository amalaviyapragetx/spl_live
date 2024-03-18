import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:spllive/api_services/api_service.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/constant_variables.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/commun_models/user_details_model.dart';
import 'package:spllive/models/normal_market_bid_history_response_model.dart';
import 'package:spllive/models/starline_daily_market_api_response.dart';
import 'package:spllive/models/starlinechar_model/new_starlinechart_model.dart';

class StarlineMarketController extends GetxController {
  final selectedIndex = Rxn<int>();
  RxList<StarlineFilterModel> starlineButtonList = [
    StarlineFilterModel(
      isSelected: false.obs,
      name: "Bid History",
      image: ConstantImage.bidHistoryIcon,
    ),
    StarlineFilterModel(isSelected: false.obs, name: "Result History", image: ConstantImage.resultHistoryIcons),
    StarlineFilterModel(isSelected: false.obs, name: "Chart", image: ConstantImage.chartIcon),
  ].obs;
  RxList<StarlineMarketData> starLineMarketList = <StarlineMarketData>[].obs;
  RxList<StarlineMarketData> marketList = <StarlineMarketData>[].obs;
  RxList<StarlineMarketData> marketListForResult = <StarlineMarketData>[].obs;
  DateTime startEndDate = DateTime.now();
  DateTime bidHistoryDate = DateTime.now();
  TextEditingController dateInputForResultHistory = TextEditingController();

  getDailyStarLineMarkets({String? startDate, String? endDate}) async {
    ApiService().getDailyStarLineMarkets(startDate: startDate ?? "", endDate: endDate ?? "").then((value) async {
      if (value['status']) {
        StarLineDailyMarketApiResponseModel responseModel = StarLineDailyMarketApiResponseModel.fromJson(value);
        starLineMarketList.value = responseModel.data ?? <StarlineMarketData>[];
        marketListForResult.value = responseModel.data ?? <StarlineMarketData>[];
        starLineMarketList.forEach((e) {
          filterMarketList.add(FilterModel(isSelected: false.obs, name: e.time, id: e.starlineMarketId));
        });
        if (starLineMarketList.isNotEmpty) {
          var biddingOpenMarketList =
              starLineMarketList.where((element) => element.isBidOpen == true && element.isBlocked == false).toList();
          var biddingClosedMarketList =
              starLineMarketList.where((element) => element.isBidOpen == false && element.isBlocked == false).toList();
          var tempFinalMarketList = <StarlineMarketData>[];
          biddingOpenMarketList.sort((a, b) {
            DateTime dateTimeA = DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
            DateTime dateTimeB = DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
            return dateTimeA.compareTo(dateTimeB);
          });
          tempFinalMarketList = biddingOpenMarketList;
          biddingClosedMarketList.sort((a, b) {
            DateTime dateTimeA = DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
            DateTime dateTimeB = DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
            return dateTimeA.compareTo(dateTimeB);
          });
          tempFinalMarketList.addAll(biddingClosedMarketList);
          starLineMarketList.value = tempFinalMarketList;
          marketListForResult.sort((a, b) {
            DateTime dateTimeA = DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
            DateTime dateTimeB = DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
            return dateTimeA.compareTo(dateTimeB);
          });
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  ////// StarLine Bid history
  RxList<ResultArr> marketHistoryList = <ResultArr>[].obs;
  TextEditingController dateinput = TextEditingController();
  RxInt offset = 0.obs;
  UserDetailsModel userData = UserDetailsModel();
  RxBool isStarline = false.obs;

  getUserData() async {
    final data = GetStorage().read(ConstantsVariables.userData);
    userData = UserDetailsModel.fromJson(data);
    // callFcmApi(userData.id);
  }

  void getMarketBidsByUserId({
    required bool lazyLoad,
    required String startDate,
    required String endDate,
  }) {
    ApiService()
        .getBidHistoryByUserId(
            userId: userData.id.toString(),
            startDate: startDate,
            endDate: endDate,
            limit: "5000",
            offset: offset.value.toString(),
            isStarline: true)
        .then(
      (value) async {
        if (value['status']) {
          if (value['data'] != null) {
            NormalMarketBidHistoryResponseModel model = NormalMarketBidHistoryResponseModel.fromJson(value);
            lazyLoad
                ? marketHistoryList.addAll(model.data?.resultArr ?? <ResultArr>[])
                : marketHistoryList.value = model.data?.resultArr ?? <ResultArr>[];
            if (isSelectedWinStatusIndex.value != null || selectedFilterMarketList.isNotEmpty) {
              Get.back();
            }
          }
        } else {
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        }
      },
    );
  }

  //// starLine chart

  RxList<StarLineDateTime> starlineChartDateAndTime = <StarLineDateTime>[].obs;
  RxList<Markets> starlineChartTime = <Markets>[].obs;
  void callGetStarLineChart() async {
    ApiService().getStarlineChar().then((value) async {
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

  RxString bannerImage = "".obs;
  RxBool bannerLoad = false.obs;
  void getStarlineBanner() async {
    try {
      bannerLoad.value = true;
      ApiService().getStarlineBanner().then((value) async {
        if (value['status']) {
          bannerLoad.value = false;
          bannerImage.value = value['data'][0]['Banner'];
          // "Banner" -> "https://vishnulive.in:9870/public/banner/Test-1.png"
        } else {
          bannerLoad.value = false;
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        }
      });
    } catch (e) {
      bannerLoad.value = false;
      print(e);
    }
  }

  List<FilterModel> filterMarketList = [];
  List<FilterModel> winStatusList = [
    FilterModel(id: 1, name: 'Win', isSelected: false.obs),
    FilterModel(id: 2, name: 'Loss', isSelected: false.obs),
    FilterModel(id: 3, name: 'Pending', isSelected: false.obs)
  ];
  var isSelectedWinStatusIndex = Rxn<int>();
  RxList<int> selectedFilterMarketList = <int>[].obs;
}

class StarlineFilterModel {
  final String? image;
  final String? name;
  final RxBool isSelected;
  final void Function()? onTap;

  StarlineFilterModel({this.image, this.name, this.onTap, required this.isSelected});
}

class FilterModel {
  final int? id;
  final String? name;
  final RxBool isSelected;

  FilterModel({this.id, this.name, required this.isSelected});
}
