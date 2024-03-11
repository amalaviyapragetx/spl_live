import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/common_utils.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/screens/home_screen/controller/homepage_controller.dart';

class BidHistory extends StatefulWidget {
  const BidHistory({super.key});

  @override
  State<BidHistory> createState() => _BidHistoryState();
}

class _BidHistoryState extends State<BidHistory> {
  var controller = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.marketHistoryList.isEmpty
          ? Container(
              height: Dimensions.h35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.shade300,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.2,
                    color: AppColors.grey,
                    blurRadius: 1,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  "NOBIDHISTORY".tr,
                  style: CustomTextStyle.textRobotoSansMedium.copyWith(
                    fontSize: Dimensions.h16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: Dimensions.h10),
              itemCount: controller.marketHistoryList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return listveiwTransaction(
                  isWin: controller.marketHistoryList[index].isWin ?? false,
                  requestId: controller.marketHistoryList[index].requestId ?? "",
                  bidTime: CommonUtils().convertUtcToIstFormatStringToDDMMYYYYHHMMA(
                      controller.marketHistoryList[index].bidTime.toString()),
                  ballance: " ${controller.marketHistoryList[index].balance.toString()} ",
                  coins: controller.marketHistoryList[index].coins.toString(),
                  bidNumber:
                      "${controller.marketHistoryList[index].gameMode ?? ""} ${controller.marketHistoryList[index].bidNo ?? ""}",
                  marketName: controller.marketHistoryList[index].marketName ?? "00:00 AM",
                );
              },
            ),
    );
  }
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
