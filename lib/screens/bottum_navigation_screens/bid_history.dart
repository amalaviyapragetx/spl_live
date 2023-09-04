import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/screens/home_screen/controller/homepage_controller.dart';
import '../../helper_files/common_utils.dart';
import '../../helper_files/constant_image.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../../helper_files/ui_utils.dart';
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
    // Size size = MediaQuery.of(context).size;
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
      () => homePageController.marketBidHistoryList.value.isEmpty
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
              padding: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: Dimensions.h10,
              ),
              itemCount: homePageController.marketBidHistoryList.length,
              itemBuilder: (context, index) {
                var data = homePageController.marketBidHistoryList[index];
                print(homePageController.marketBidHistoryList.length);
                return listveiwTransactionNew(
                  requestId: "RequestId :  ${data.requestId ?? ""}",
                  isWin: data.isWin ?? false,
                  bidNo: data.bidNo.toString(),
                  ballance: data.balance.toString(),
                  coins: data.coins.toString(),
                  closeTime:
                      CommonUtils().formatStringToHHMMA(data.closeTime ?? ""),
                  openTime:
                      CommonUtils().formatStringToHHMMA(data.openTime ?? ""),
                  transactiontype: data.marketName.toString(),
                  timeDate: CommonUtils()
                      .convertUtcToIstFormatStringToDDMMYYYYHHMMA(
                          data.bidTime.toString()),
                  marketName: data.transactionType ?? "",
                  gameMode: data.gameMode ?? "",
                  bidType: data.bidType ?? "",
                );
              },
            ),
    );
  }

  // Widget listveiwTransaction({
  //   required String marketName,
  //   required String bidNo,
  //   required String openTime,
  //   required String closeTime,
  //   required String coins,
  //   required String ballance,
  //   required String transactiontype,
  //   required String timeDate,
  //   required String gameMode,
  //   required String bidType,
  //   required bool isWin,
  //   // required Function() onTap,
  // }) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: Dimensions.h5),
  //     child: InkWell(
  //       // onTap: onTap,
  //       child: Container(
  //         decoration: BoxDecoration(
  //           boxShadow: [
  //             isWin == true
  //                 ? BoxShadow()
  //                 : BoxShadow(
  //                     spreadRadius: 1,
  //                     color: AppColors.grey,
  //                     blurRadius: 10,
  //                     offset: const Offset(7, 4),
  //                   ),
  //           ],
  //           border: Border.all(width: 0.6),
  //           color: isWin == true ? AppColors.greenAccent : AppColors.white,
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Text(
  //                         " $marketName",
  //                         style: CustomTextStyle.textRobotoSansBold
  //                             .copyWith(fontSize: Dimensions.h14),
  //                       ),
  //                       SizedBox(
  //                         width: Dimensions.w8,
  //                       ),
  //                       Text(
  //                         bidNo.toString(),
  //                         style: CustomTextStyle.textRobotoSansLight.copyWith(
  //                           fontSize: Dimensions.h14,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 2),
  //                     child: Row(
  //                       children: [
  //                         Text(
  //                           transactiontype,
  //                           style: CustomTextStyle.textRobotoSansLight,
  //                         ),
  //                         // openResut != ""
  //                         //     ? Text(
  //                         //         // "446-47-359",
  //                         //         openResut,
  //                         //         style: CustomTextStyle.textRobotoSansBold,
  //                         //       )
  //                         //     : SvgPicture.asset(
  //                         //         ConstantImage.openStarsSvg,
  //                         //         height: Dimensions.h13,
  //                         //       ),
  //                         // closeResult != ""
  //                         //     ? Text(
  //                         //         // "446-47-359",
  //                         //         closeResult,
  //                         //         style: CustomTextStyle.textRobotoSansBold,
  //                         //       )
  //                         //     : SvgPicture.asset(
  //                         //         ConstantImage.closeStarsSvg,
  //                         //         height: Dimensions.h13,
  //                         //       ),
  //                       ],
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     "$openTime - $closeTime",
  //                     style: CustomTextStyle.textRobotoSansLight,
  //                   ),
  //                   Text(
  //                     "$gameMode - $bidType",
  //                     style: CustomTextStyle.textRobotoSansLight,
  //                   ),
  //                   // Text(
  //                   //   bidType,
  //                   //   style: CustomTextStyle.textRobotoSansLight,
  //                   // ),
  //                 ],
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Row(
  //                 children: [
  //                   Text(
  //                     "Points",
  //                     style: CustomTextStyle.textRobotoSansLight,
  //                   ),
  //                   SizedBox(
  //                     width: Dimensions.w5,
  //                   ),
  //                   // SizedBox(
  //                   //   width: Dimensions.w5,
  //                   // ),
  //                   Text(
  //                     coins,
  //                     style: CustomTextStyle.textRobotoSansLight.copyWith(
  //                       fontSize: Dimensions.h14,
  //                       color: AppColors.balanceCoinsColor,
  //                     ),
  //                   ),
  //                   const Expanded(child: SizedBox()),
  //                   SizedBox(
  //                     width: Dimensions.w5,
  //                   ),
  //                   SizedBox(
  //                     width: Dimensions.w5,
  //                   ),
  //                   Text(
  //                     ballance,
  //                     style: CustomTextStyle.textRobotoSansLight.copyWith(
  //                       fontSize: Dimensions.h14,
  //                       color: AppColors.balanceCoinsColor,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               height: Dimensions.h30,
  //               width: double.infinity,
  //               decoration: BoxDecoration(
  //                 color: AppColors.greywhite,
  //                 borderRadius: BorderRadius.only(
  //                   bottomLeft: Radius.circular(Dimensions.r8),
  //                   bottomRight: Radius.circular(Dimensions.r8),
  //                 ),
  //               ),
  //               child: Center(
  //                 child: Text(
  //                   "Time : $timeDate",
  //                   style: CustomTextStyle.textRobotoSansLight,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget listveiwTransactionNew({
    required String marketName,
    required String openTime,
    required String closeTime,
    required String coins,
    required String ballance,
    required String transactiontype,
    required String timeDate,
    required String gameMode,
    required String bidType,
    required String bidNo,
    required String requestId,
    required bool isWin,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$transactiontype :",
                      style: CustomTextStyle.textRobotoSansBold
                          .copyWith(fontSize: Dimensions.h14),
                    ),
                    SizedBox(
                      width: Dimensions.w5,
                    ),
                    Text(
                      bidNo,
                      style: CustomTextStyle.textRobotoSansBold.copyWith(
                          color: AppColors.appbarColor,
                          fontSize: Dimensions.h13),
                    ),
                    const Expanded(child: SizedBox()),
                    Row(
                      children: [
                        Text(
                          "Points :",
                          style: CustomTextStyle.textRobotoSansBold
                              .copyWith(fontSize: Dimensions.h14),
                        ),
                        Text(
                          " $coins",
                          style: CustomTextStyle.textRobotoSansBold.copyWith(
                              fontSize: Dimensions.h14,
                              color: AppColors.appbarColor),
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
                      requestId,
                      style: CustomTextStyle.textRobotoSansLight
                          .copyWith(fontSize: Dimensions.h12),
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
                      gameMode,
                      style: CustomTextStyle.textRobotoSansLight
                          .copyWith(fontSize: Dimensions.h12),
                    ),
                    // SizedBox(
                    //   width: 180,
                    // ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          ConstantImage.walletAppbar,
                          height: Dimensions.h13,
                        ),
                        SizedBox(
                          width: Dimensions.w8,
                        ),
                        Text(ballance,
                            style: CustomTextStyle.textRobotoSansLight
                                .copyWith(fontSize: Dimensions.h12)),
                      ],
                    ),

                    // Text(
                    //   bidType,
                    //   style: CustomTextStyle.textRobotoSansLight,
                    // ),
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
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        ConstantImage.clockSvg,
                        height: Dimensions.h14,
                      ),
                      SizedBox(
                        width: Dimensions.w8,
                      ),
                      Text(
                        timeDate,
                        style: CustomTextStyle.textRobotoSansBold,
                      ),
                      const Expanded(child: SizedBox()),
                      Text(
                        bidType,
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
