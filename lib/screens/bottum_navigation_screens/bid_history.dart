import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/routes/app_routes_name.dart';
import 'package:spllive/screens/home_screen/controller/homepage_controller.dart';

import '../../helper_files/common_utils.dart';
import '../../helper_files/constant_image.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../../helper_files/ui_utils.dart';
import '../../models/normal_market_bid_history_response_model.dart';
import 'controller/bottum_navigation_controller.dart';

class BidHistory extends StatelessWidget {
  BidHistory({
    super.key,
    required this.appbarTitle,
  });
  final String appbarTitle;
  var controller = Get.put(MoreListController());
  var homePageController = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        AppUtils().simpleAppbar(
          appBarTitle: "",
          leadingWidht: Dimensions.w200,
          leading: Container(
            child: Row(
              children: [
                SizedBox(width: Dimensions.w15),
                Text(
                  appbarTitle,
                  style: CustomTextStyle.textRobotoSansMedium
                      .copyWith(fontSize: Dimensions.h20),
                ),
              ],
            ),
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
      () => homePageController.marketBidHistoryList.isEmpty
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
              padding:
                  EdgeInsets.symmetric(vertical: 5, horizontal: Dimensions.h10),
              itemCount: homePageController.marketBidHistoryList.length,
              itemBuilder: (context, index) {
                // var data = controller.marketHistoryList.elementAt(index);
                // print(")))))))))))))))))))))))))))))))))))))))))))))))))) $data");
                return listveiwTransaction(
                  ballance: homePageController
                      .marketBidHistoryList[index].balance
                      .toString(),
                  coins: homePageController.marketBidHistoryList[index].coins
                      .toString(),
                  closeTime: CommonUtils().formatStringToHHMMA(
                      homePageController
                              .marketBidHistoryList[index].closeTime ??
                          ""),
                  openTime: CommonUtils().formatStringToHHMMA(
                      homePageController.marketBidHistoryList[index].openTime ??
                          ""),
                  transactiontype: homePageController
                      .marketBidHistoryList[index].marketName
                      .toString(),
                  timeDate: CommonUtils().formatStringToDDMMYYYYHHMMA(
                    homePageController.marketBidHistoryList[index].bidTime
                        .toString(),
                  ),
                  // openResut:
                  //     homePageController.marketBidHistoryList[index].openTime ==
                  //             null
                  //         ? ""
                  //         : homePageController
                  //             .getResult(
                  //               true,
                  //               homePageController
                  //                       .marketBidHistoryList[index].openTime ??
                  //                   0,
                  //             )
                  //             .toString(),
                  marketName: homePageController
                          .marketBidHistoryList[index].transactionType ??
                      "",
                  containerColor:
                      homePageController.marketBidHistoryList[index].isWin ==
                              true
                          ? AppColors.greenAccent.withOpacity(0.65)
                          : AppColors.white,

                  gameMode:
                      homePageController.marketBidHistoryList[index].gameMode ??
                          "",

                  bidType:
                      homePageController.marketBidHistoryList[index].bidType ??
                          "",
                  // closeResult:
                  //     homePageController.marketBidHistoryList[index].closeResult ==
                  //             null
                  //         ? ""
                  //         : homePageController
                  //             .reverse(homePageController.getResult(
                  //               true,
                  //               homePageController
                  //                       .marketBidHistoryList[index].closeResult ??
                  //                   0,
                  //             ))
                  //             .toString(),
                  // onTap: () {
                  //   Get.toNamed(AppRoutName.newBidHistorypage, arguments: {
                  //     "marketData": homePageController.marketBidHistoryList.value,
                  //     "marketId": homePageController.marketBidHistoryList[index].id
                  //         .toString(),
                  //     "marketName":
                  //         homePageController.marketBidHistoryList[index].marketName,
                  //   });
                  // },
                );
              },
            ),
    );
  }

  Widget listveiwTransaction({
    required String marketName,
    // required String openResut,
    required String openTime,
    required String closeTime,
    required String coins,
    required String ballance,
    required String transactiontype,
    required Color containerColor,
    required String timeDate,
    required String gameMode,
    required String bidType,
    // required String closeResult,
    // required Function() onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.h5),
      child: InkWell(
        // onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                color: AppColors.grey,
                blurRadius: 10,
                offset: Offset(7, 4),
              ),
            ],
            border: Border.all(width: 0.6),
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      marketName,
                      style: CustomTextStyle.textRobotoSansBold
                          .copyWith(fontSize: Dimensions.h14),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          Text(
                            transactiontype,
                            style: CustomTextStyle.textRobotoSansLight,
                          ),
                          // openResut != ""
                          //     ? Text(
                          //         // "446-47-359",
                          //         openResut,
                          //         style: CustomTextStyle.textRobotoSansBold,
                          //       )
                          //     : SvgPicture.asset(
                          //         ConstantImage.openStarsSvg,
                          //         height: Dimensions.h13,
                          //       ),
                          // closeResult != ""
                          //     ? Text(
                          //         // "446-47-359",
                          //         closeResult,
                          //         style: CustomTextStyle.textRobotoSansBold,
                          //       )
                          //     : SvgPicture.asset(
                          //         ConstantImage.closeStarsSvg,
                          //         height: Dimensions.h13,
                          //       ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$openTime - $closeTime",
                      style: CustomTextStyle.textRobotoSansLight,
                    ),
                    Text(
                      "$gameMode - $bidType",
                      style: CustomTextStyle.textRobotoSansLight,
                    ),
                    // Text(
                    //   bidType,
                    //   style: CustomTextStyle.textRobotoSansLight,
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Points",
                      style: CustomTextStyle.textRobotoSansLight,
                    ),
                    SizedBox(
                      width: Dimensions.w5,
                    ),
                    // SizedBox(
                    //   width: Dimensions.w5,
                    // ),
                    Text(
                      coins,
                      style: CustomTextStyle.textRobotoSansLight.copyWith(
                        fontSize: Dimensions.h14,
                        color: AppColors.balanceCoinsColor,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      width: Dimensions.w5,
                    ),
                    SizedBox(
                      width: Dimensions.w5,
                    ),
                    Text(
                      ballance,
                      style: CustomTextStyle.textRobotoSansLight.copyWith(
                        fontSize: Dimensions.h14,
                        color: AppColors.balanceCoinsColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: Dimensions.h30,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.greywhite,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Dimensions.r8),
                    bottomRight: Radius.circular(Dimensions.r8),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Time : $timeDate",
                    style: CustomTextStyle.textRobotoSansLight,
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
