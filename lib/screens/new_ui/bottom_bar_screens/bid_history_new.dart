import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/common_utils.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/screens/bottum_navigation_screens/controller/bottum_navigation_controller.dart';
import 'package:spllive/screens/new_ui/bottom_bar_screens/set_filter.dart';

class BidHistoryNew extends StatefulWidget {
  const BidHistoryNew({super.key});

  @override
  State<BidHistoryNew> createState() => _BidHistoryNewState();
}

class _BidHistoryNewState extends State<BidHistoryNew> {
  var controller = Get.put(MoreListController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.marketBidHistoryList.isEmpty
          ? Column(
              children: [
                AppUtils().simpleAppbar(
                  centerTitle: true,
                  appBarTitle: "",
                  leadingWidht: Dimensions.w200,
                  leading: Row(
                    children: [
                      SizedBox(width: Dimensions.w10),
                      SvgPicture.asset(
                        ConstantImage.walletAppbar,
                        height: 25,
                        width: 30,
                        color: AppColors.white,
                      ),
                      SizedBox(width: Dimensions.w2),
                      GetBuilder<WalletController>(
                        builder: (con) => Text(
                          con.walletBalance.value,
                          style: CustomTextStyle.textRobotoSansMedium
                              .copyWith(fontSize: Dimensions.h16, color: AppColors.white),
                        ),
                      ),
                      // SizedBox(width: Dimensions.w20),
                      Text(
                        "Bid History",
                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                          fontSize: Dimensions.h17,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    InkWell(
                        onTap: () => Get.to(() => const SetFilter()), child: SvgPicture.asset(ConstantImage.filter)),
                    SizedBox(width: Dimensions.w10),
                  ],
                ),
                // Expanded(
                //   child: bidHistoryList(),
                // ),
              ],
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: Dimensions.h10),
              itemCount: controller.marketBidHistoryList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return listveiwTransaction(
                  isWin: controller.marketBidHistoryList[index].isWin ?? false,
                  requestId: controller.marketBidHistoryList[index].requestId ?? "",
                  bidTime: CommonUtils().convertUtcToIstFormatStringToDDMMYYYYHHMMA(
                      controller.marketBidHistoryList[index].bidTime.toString()),
                  ballance: " ${controller.marketBidHistoryList[index].balance.toString()} ",
                  coins: controller.marketBidHistoryList[index].coins.toString(),
                  bidNumber:
                      "${controller.marketBidHistoryList[index].gameMode ?? ""} ${controller.marketBidHistoryList[index].bidNo ?? ""}",
                  marketName: controller.marketBidHistoryList[index].marketName ?? "00:00 AM",
                );
              },
            ),
    );
  }
  // bidHistoryList() {
  //   return Obx(
  //         () => homePageController.marketBidHistoryList.isEmpty
  //         ? Center(
  //       child: Text(
  //         "NOHISTORYAVAILABLEFORLAST7DAYS".tr,
  //         style: CustomTextStyle.textPTsansMedium.copyWith(
  //           fontSize: Dimensions.h13,
  //           color: AppColors.black,
  //         ),
  //       ),
  //     )
  //         : ListView.builder(
  //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: Dimensions.h10),
  //       itemCount: homePageController.marketBidHistoryList.length,
  //       itemBuilder: (context, index) {
  //         var data = homePageController.marketBidHistoryList[index];
  //         return listveiwTransactionNew(
  //           requestId: "RequestId :  ${data.requestId ?? ""}",
  //           isWin: data.isWin ?? false,
  //           bidNo: data.bidNo.toString(),
  //           ballance: data.balance.toString(),
  //           coins: data.coins.toString(),
  //           closeTime: CommonUtils().formatStringToHHMMA(data.closeTime ?? ""),
  //           openTime: CommonUtils().formatStringToHHMMA(data.openTime ?? ""),
  //           transactiontype: data.marketName.toString(),
  //           timeDate: CommonUtils().convertUtcToIstFormatStringToDDMMYYYYHHMMA(data.bidTime.toString()),
  //           marketName: data.transactionType ?? "",
  //           gameMode: data.gameMode ?? "",
  //           bidType: data.bidType ?? "",
  //         );
  //       },
  //     ),
  //   );
  // }
}

Widget listveiwTransaction({
  required String marketName,
  required String bidNumber,
  required String coins,
  required String ballance,
  required String bidTime,
  required String requestId,
  required bool isWin,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: Dimensions.h5),
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: AppColors.grey,
            blurRadius: 10,
            offset: const Offset(7, 4),
          ),
        ],
        border: Border.all(width: 0.6),
        color: isWin == true ? AppColors.greenAccent : AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  marketName,
                  style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h14),
                ),
                Text(
                  // "446-47-359",
                  bidNumber,
                  style: CustomTextStyle.textRobotoSansBold,
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
                  "RequestId:  $requestId",
                  style: CustomTextStyle.textRobotoSansLight.copyWith(fontSize: Dimensions.h12),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("POINTS  ", style: CustomTextStyle.textRobotoSansLight),
                SizedBox(width: Dimensions.w5),
                SizedBox(width: Dimensions.w5),
                Text(
                  coins,
                  style: CustomTextStyle.textRobotoSansLight.copyWith(
                    fontSize: Dimensions.h14,
                    color: AppColors.balanceCoinsColor,
                  ),
                ),
                const Expanded(child: SizedBox()),
                // Text(
                //   "Balance",
                //   style: CustomTextStyle.textRobotoSansLight,
                // ),
                SizedBox(width: Dimensions.w5),
                // Image.asset(
                //   ConstantImage.ruppeeBlueIcon,
                //   height: 25,
                //   width: 25,
                // ),
                SizedBox(width: Dimensions.w5),
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
                  const Expanded(child: SizedBox()),
                  Text(bidTime, style: CustomTextStyle.textRobotoSansBold),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
