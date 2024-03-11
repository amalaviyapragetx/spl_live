import 'package:get/get.dart';
import 'package:spllive/helper_files/constant_image.dart';

class StarlineMarketController extends GetxController {
  RxList<StarlineFilterModel> starlineButtonList = [
    StarlineFilterModel(
      isSelected: false.obs,
      name: "Bid History",
      image: ConstantImage.bidHistoryIcon,
    ),
    StarlineFilterModel(isSelected: false.obs, name: "Result History", image: ConstantImage.resultHistoryIcons),
    StarlineFilterModel(isSelected: false.obs, name: "Chart", image: ConstantImage.chartIcon),
  ].obs;

  // void getDailyStarLineMarkets(String startDate, String endDate) async {
  //   ApiService().getDailyStarLineMarkets(startDate: startDate, endDate: endDate).then((value) async {
  //     if (value['status']) {
  //       StarLineDailyMarketApiResponseModel responseModel = StarLineDailyMarketApiResponseModel.fromJson(value);
  //       marketList.value = responseModel.data ?? <StarlineMarketData>[];
  //       marketListForResult.value = responseModel.data ?? <StarlineMarketData>[];
  //       if (marketList.isNotEmpty) {
  //         var biddingOpenMarketList =
  //             marketList.where((element) => element.isBidOpen == true && element.isBlocked == false).toList();
  //         var biddingClosedMarketList =
  //             marketList.where((element) => element.isBidOpen == false && element.isBlocked == false).toList();
  //         var tempFinalMarketList = <StarlineMarketData>[];
  //         biddingOpenMarketList.sort((a, b) {
  //           DateTime dateTimeA = DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
  //           DateTime dateTimeB = DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
  //           return dateTimeA.compareTo(dateTimeB);
  //         });
  //         tempFinalMarketList = biddingOpenMarketList;
  //         biddingClosedMarketList.sort((a, b) {
  //           DateTime dateTimeA = DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
  //           DateTime dateTimeB = DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
  //           return dateTimeA.compareTo(dateTimeB);
  //         });
  //         tempFinalMarketList.addAll(biddingClosedMarketList);
  //         marketList.value = tempFinalMarketList;
  //         marketListForResult.sort((a, b) {
  //           DateTime dateTimeA = DateFormat('hh:mm a').parse(a.time ?? "00:00 AM");
  //           DateTime dateTimeB = DateFormat('hh:mm a').parse(b.time ?? "00:00 AM");
  //           return dateTimeA.compareTo(dateTimeB);
  //         });
  //       }
  //     } else {
  //       AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
  //     }
  //   });
  // }
}

class StarlineFilterModel {
  final String? image;
  final String? name;
  final RxBool isSelected;
  final void Function()? onTap;

  StarlineFilterModel({this.image, this.name, this.onTap, required this.isSelected});
}
