import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spllive/controller/starline_market_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/common_utils.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';

class StarlineBidHistory extends StatefulWidget {
  const StarlineBidHistory({super.key});

  @override
  State<StarlineBidHistory> createState() => _StarlineBidHistoryState();
}

class _StarlineBidHistoryState extends State<StarlineBidHistory> {
  final starlineCon = Get.find<StarlineMarketController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    starlineCon.getMarketBidsByUserId(
        lazyLoad: false,
        endDate: DateFormat('yyyy-MM-dd').format(starlineCon.startEndDate),
        startDate: DateFormat('yyyy-MM-dd').format(starlineCon.startEndDate));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Dimensions.h11),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                  height: 45,
                  child: TextField(
                    style: CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.appbarColor),
                    controller: starlineCon.dateinput,
                    decoration: InputDecoration(
                      hintText: DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
                      hintStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                        color: AppColors.appbarColor,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.w8, vertical: Dimensions.h10),
                      filled: true,
                      fillColor: AppColors.grey.withOpacity(0.15),
                      prefixIcon: Icon(Icons.calendar_month_sharp, color: AppColors.appbarColor),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: starlineCon.startEndDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        String formattedDate2 = DateFormat('dd-MM-yyyy').format(pickedDate);
                        starlineCon.dateinput.text = formattedDate2;

                        starlineCon.getMarketBidsByUserId(
                          lazyLoad: false,
                          startDate: formattedDate,
                          endDate: formattedDate,
                        );
                        starlineCon.startEndDate = pickedDate;
                      }
                    },
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => {
                  Get.dialog(
                    barrierDismissible: false,
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: Get.width, minWidth: Get.width - 30),
                      child: Dialog(
                        insetPadding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(color: AppColors.appbarColor),
                                  child: Text(
                                    "SET FILTER",
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: Get.height / 1.2,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(color: AppColors.white),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Winning Status",
                                        textAlign: TextAlign.center,
                                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                          color: AppColors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Obx(
                                        () => Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: starlineCon.winStatusList
                                              .map(
                                                (e) => Row(
                                                  children: [
                                                    Checkbox(
                                                      activeColor: AppColors.appbarColor,
                                                      value: e.isSelected.value,
                                                      onChanged: (bool? value) {
                                                        starlineCon.winStatusList
                                                            .forEach((e) => e.isSelected.value = false);
                                                        e.isSelected.value = value ?? false;
                                                        if (e.isSelected.value) {
                                                          starlineCon.isSelectedWinStatusIndex.value = e.id;
                                                        } else {
                                                          starlineCon.isSelectedWinStatusIndex.value = null;
                                                        }
                                                      },
                                                    ),
                                                    Text(
                                                      e.name ?? "",
                                                      style: CustomTextStyle.textRobotoSansMedium
                                                          .copyWith(color: AppColors.black),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                      Text(
                                        "Markets",
                                        textAlign: TextAlign.center,
                                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                          color: AppColors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Obx(
                                        () => Expanded(
                                          child: ScrollbarTheme(
                                            data: ScrollbarThemeData(
                                              thumbColor: MaterialStateProperty.all<Color>(AppColors.appbarColor),
                                              trackColor: MaterialStateProperty.all<Color>(AppColors.appbarColor),
                                            ),
                                            child: Scrollbar(
                                              trackVisibility: true,
                                              thickness: 5,
                                              radius: const Radius.circular(20),
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  physics: BouncingScrollPhysics(),
                                                  children: starlineCon.filterMarketList
                                                      .map(
                                                        (e) => Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                              vertical: 5.0, horizontal: 5.0),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    blurRadius: 6.97777795791626,
                                                                    spreadRadius: 0.8722222447395325,
                                                                    offset: Offset(0, 0),
                                                                    color: AppColors.black.withOpacity(0.25))
                                                              ],
                                                              color: AppColors.white,
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Checkbox(
                                                                  activeColor: AppColors.appbarColor,
                                                                  value: e.isSelected.value,
                                                                  onChanged: (bool? value) {
                                                                    e.isSelected.value = value ?? false;
                                                                    if (e.isSelected.value) {
                                                                      starlineCon.selectedFilterMarketList
                                                                          .add(e.id ?? 0);
                                                                    } else {
                                                                      starlineCon.selectedFilterMarketList.clear();
                                                                    }
                                                                  },
                                                                ),
                                                                Text(
                                                                  e.name ?? "",
                                                                  style: CustomTextStyle.textRobotoSansMedium
                                                                      .copyWith(color: AppColors.black),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              starlineCon.marketHistoryList.clear();
                                              starlineCon.getMarketBidsByUserId(
                                                  lazyLoad: false,
                                                  endDate: DateFormat('yyyy-MM-dd').format(starlineCon.startEndDate),
                                                  startDate: DateFormat('yyyy-MM-dd').format(starlineCon.startEndDate));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.appbarColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              padding: const EdgeInsets.all(10),
                                              child: Center(
                                                child: Text(
                                                  "SUBMIT",
                                                  style: CustomTextStyle.textRobotoSansMedium
                                                      .copyWith(color: AppColors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              starlineCon.selectedFilterMarketList.value = [];
                                              starlineCon.filterMarketList.forEach((e) => e.isSelected.value = false);
                                              starlineCon.isSelectedWinStatusIndex.value = null;
                                              starlineCon.winStatusList.forEach((e) => e.isSelected.value = false);
                                              Get.back();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.appbarColor,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              padding: const EdgeInsets.all(10),
                                              child: Center(
                                                child: Text(
                                                  "CANCEL",
                                                  style: CustomTextStyle.textRobotoSansMedium
                                                      .copyWith(color: AppColors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                },
                child: Obx(
                  () => starlineCon.selectedFilterMarketList.isNotEmpty ||
                          starlineCon.isSelectedWinStatusIndex.value != null
                      ? InkWell(
                          onTap: () {
                            starlineCon.selectedFilterMarketList.value = [];
                            starlineCon.filterMarketList.forEach((e) => e.isSelected.value = false);
                            starlineCon.isSelectedWinStatusIndex.value = null;
                            starlineCon.winStatusList.forEach((e) => e.isSelected.value = false);
                            starlineCon.getMarketBidsByUserId(
                                lazyLoad: false,
                                endDate: DateFormat('yyyy-MM-dd').format(starlineCon.startEndDate),
                                startDate: DateFormat('yyyy-MM-dd').format(starlineCon.startEndDate));
                          },
                          child: Stack(
                            children: [
                              SvgPicture.asset(ConstantImage.filter),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.redColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: AppColors.white,
                                  size: 10,
                                ),
                              )
                            ],
                          ),
                        )
                      : SvgPicture.asset(ConstantImage.filter),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: Dimensions.h11),
        Obx(
          () => starlineCon.marketHistoryList.isEmpty
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
                  itemCount: starlineCon.marketHistoryList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return listveiwTransaction(
                      isWin: starlineCon.marketHistoryList[index].isWin ?? false,
                      requestId: starlineCon.marketHistoryList[index].requestId ?? "",
                      bidTime: CommonUtils().convertUtcToIstFormatStringToDDMMYYYYHHMMA(
                          starlineCon.marketHistoryList[index].bidTime.toString()),
                      ballance: " ${starlineCon.marketHistoryList[index].balance.toString()} ",
                      coins: starlineCon.marketHistoryList[index].coins.toString(),
                      bidNumber:
                          "${starlineCon.marketHistoryList[index].gameMode ?? ""} ${starlineCon.marketHistoryList[index].bidNo ?? ""}",
                      marketName: starlineCon.marketHistoryList[index].marketName ?? "00:00 AM",
                    );
                  },
                ),
        )
      ],
    );
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
          border: Border.all(width: 0.87),
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
                    style:
                        CustomTextStyle.textRobotoSansLight.copyWith(fontSize: Dimensions.h12, color: AppColors.black),
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
}
