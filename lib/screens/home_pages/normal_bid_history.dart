import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spllive/controller/home_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/common_utils.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';

class NormalMarketBidHistory extends StatefulWidget {
  const NormalMarketBidHistory({super.key});

  @override
  State<NormalMarketBidHistory> createState() => _NormalMarketBidHistoryState();
}

class _NormalMarketBidHistoryState extends State<NormalMarketBidHistory> {
  final homeCon = Get.find<HomeController>();
  @override
  void initState() {
    homeCon.getMarketBidsByUserId(
        lazyLoad: false,
        endDate: DateFormat('yyyy-MM-dd').format(homeCon.startEndDate),
        startDate: DateFormat('yyyy-MM-dd').format(homeCon.startEndDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.h10),
      child: Column(
        children: [
          SizedBox(height: Dimensions.h11),
          SizedBox(
            height: 45,
            child: TextField(
              style: CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.appbarColor),
              controller: homeCon.bidHistoryController,
              decoration: InputDecoration(
                hintText: DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
                hintStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                  color: AppColors.appbarColor,
                ),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.w8, vertical: Dimensions.h10),
                filled: true,
                fillColor: AppColors.grey.withOpacity(0.15),
                prefixIcon: Icon(Icons.calendar_month_sharp, color: AppColors.appbarColor),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: homeCon.startEndDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101));
                if (pickedDate != null) {
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  String formattedDate2 = DateFormat('dd-MM-yyyy').format(pickedDate);
                  homeCon.bidHistoryController.text = formattedDate2;
                  homeCon.getMarketBidsByUserId(
                    lazyLoad: false,
                    startDate: formattedDate,
                    endDate: formattedDate,
                  );
                  homeCon.startEndDate = pickedDate;
                }
              },
            ),
          ),
          SizedBox(height: Dimensions.h11),
          Obx(
            () => homeCon.marketHistoryList.isEmpty
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
                : ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(height: 5),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: Dimensions.h10),
                    itemCount: homeCon.marketHistoryList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return listViewTransaction(
                        isWin: homeCon.marketHistoryList[index].isWin ?? false,
                        requestId: homeCon.marketHistoryList[index].requestId ?? "",
                        bidTime: CommonUtils().convertUtcToIstFormatStringToDDMMYYYYHHMMA(
                            homeCon.marketHistoryList[index].bidTime.toString()),
                        balance: " ${homeCon.marketHistoryList[index].balance.toString()} ",
                        coins: homeCon.marketHistoryList[index].coins.toString(),
                        bidNumber:
                            "${homeCon.marketHistoryList[index].gameMode ?? ""} ${homeCon.marketHistoryList[index].bidNo ?? ""}",
                        marketName: homeCon.marketHistoryList[index].marketName ?? "00:00 AM",
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  Widget listViewTransaction({
    required String marketName,
    required String bidNumber,
    required String coins,
    required String balance,
    required String bidTime,
    required String requestId,
    required bool isWin,
  }) {
    return Container(
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
                    style: CustomTextStyle.textRobotoSansBold),
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
                SizedBox(width: Dimensions.w5),
                SizedBox(width: Dimensions.w5),
                Text(
                  balance,
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
    );
  }
}
