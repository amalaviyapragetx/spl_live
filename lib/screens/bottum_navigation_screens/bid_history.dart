import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/controller/bid_history_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/utils/constant.dart';

import '../../helper_files/common_utils.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../../helper_files/ui_utils.dart';
import 'controller/bottum_navigation_controller.dart';

class BidHistory extends StatefulWidget {
  BidHistory({super.key, required this.appbarTitle});
  final String appbarTitle;

  @override
  State<BidHistory> createState() => _BidHistoryState();
}

class _BidHistoryState extends State<BidHistory> {
  var controller = Get.put(MoreListController());

  final bidHistoryCon = Get.put<BidHistoryController>(BidHistoryController());
  @override
  void initState() {
    super.initState();
    bidHistoryCon.marketBidsByUserId(lazyLoad: false);
  }

  // var homePageController = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppUtils().simpleAppbar(
          appBarTitle: "",
          leadingWidht: Dimensions.w200,
          leading: Row(
            children: [
              SizedBox(width: Dimensions.w15),
              Text(
                widget.appbarTitle,
                style: CustomTextStyle.textRobotoSansMedium.copyWith(fontSize: Dimensions.h20),
              ),
            ],
          ),
        ),
        Expanded(
          child: bidHistoryList(),
        ),
      ],
    );
  }

  bidHistoryList() {
    return Obx(
      () => bidHistoryCon.marketBidHistoryList.isEmpty
          ? Center(
              child: Text(
                "NOHISTORYAVAILABLEFORLAST7DAYS".tr,
                style: CustomTextStyle.textPTsansMedium.copyWith(
                  fontSize: Dimensions.h13,
                  color: AppColors.black,
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: Dimensions.h10),
              itemCount: bidHistoryCon.marketBidHistoryList.length,
              itemBuilder: (context, index) {
                return listveiwTransactionNew(
                  requestId: "RequestId :  ${bidHistoryCon.marketBidHistoryList[index].requestId ?? ""}",
                  isWin: bidHistoryCon.marketBidHistoryList[index].isWin ?? false,
                  bidNo: bidHistoryCon.marketBidHistoryList[index].bidNo.toString(),
                  ballance: bidHistoryCon.marketBidHistoryList[index].balance.toString(),
                  coins: bidHistoryCon.marketBidHistoryList[index].coins.toString(),
                  closeTime:
                      CommonUtils().formatStringToHHMMA(bidHistoryCon.marketBidHistoryList[index].closeTime ?? ""),
                  openTime: CommonUtils().formatStringToHHMMA(bidHistoryCon.marketBidHistoryList[index].openTime ?? ""),
                  transactiontype: bidHistoryCon.marketBidHistoryList[index].marketName.toString(),
                  timeDate: CommonUtils().convertUtcToIstFormatStringToDDMMYYYYHHMMA(
                      bidHistoryCon.marketBidHistoryList[index].bidTime.toString()),
                  marketName: bidHistoryCon.marketBidHistoryList[index].transactionType ?? "",
                  gameMode: bidHistoryCon.marketBidHistoryList[index].gameMode ?? "",
                  bidType: bidHistoryCon.marketBidHistoryList[index].bidType ?? "",
                );
              },
            ),
    );
  }

  Widget listveiwTransactionNew({
    String? marketName,
    String? openTime,
    String? closeTime,
    String? coins,
    String? ballance,
    String? transactiontype,
    String? timeDate,
    String? gameMode,
    String? bidType,
    String? bidNo,
    String? requestId,
    bool? isWin,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.h5),
      child: InkWell(
        // onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: 0.5,
                color: AppColors.grey,
                blurRadius: 2,
                offset: const Offset(2, 4),
              )
            ],
            border: Border.all(width: 0.2),
            color: isWin == true ? AppColors.greenAccent : AppColors.white,
            borderRadius: BorderRadius.circular(Dimensions.r8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$transactiontype :",
                      style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h14),
                    ),
                    SizedBox(width: Dimensions.w5),
                    Text(
                      bidNo ?? "",
                      style: CustomTextStyle.textRobotoSansMedium
                          .copyWith(color: AppColors.appbarColor, fontSize: Dimensions.h13),
                    ),
                    const Expanded(child: SizedBox()),
                    Row(
                      children: [
                        Text(
                          "Points :",
                          style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h14),
                        ),
                        Text(
                          " $coins",
                          style: CustomTextStyle.textRobotoSansMedium
                              .copyWith(fontSize: Dimensions.h14, color: AppColors.appbarColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimensions.h8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      requestId ?? "",
                      style: CustomTextStyle.textRobotoSansLight.copyWith(fontSize: Dimensions.h12),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimensions.h8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      gameMode ?? "",
                      style: CustomTextStyle.textRobotoSansLight.copyWith(fontSize: Dimensions.h12),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppImage.walletAppbar,
                          height: Dimensions.h13,
                        ),
                        SizedBox(width: Dimensions.w8),
                        Text(ballance ?? "",
                            style: CustomTextStyle.textRobotoSansLight.copyWith(fontSize: Dimensions.h12)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: Dimensions.h30,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.greyShade.withOpacity(0.4),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Dimensions.r8),
                    bottomRight: Radius.circular(Dimensions.r8),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.h8),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppImage.clockSvg,
                        height: Dimensions.h14,
                      ),
                      SizedBox(width: Dimensions.w8),
                      Text(
                        timeDate ?? "",
                        style: CustomTextStyle.textRobotoSansBold,
                      ),
                      const Expanded(child: SizedBox()),
                      Text(
                        bidType ?? "",
                        style: CustomTextStyle.textRobotoSansBold,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
