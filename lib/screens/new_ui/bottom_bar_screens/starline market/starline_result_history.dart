import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spllive/controller/starline_market_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';

class StarlineResultHistory extends StatefulWidget {
  const StarlineResultHistory({super.key});

  @override
  State<StarlineResultHistory> createState() => _StarlineResultHistoryState();
}

class _StarlineResultHistoryState extends State<StarlineResultHistory> {
  final starlineCon = Get.find<StarlineMarketController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          SizedBox(height: Dimensions.h11),
          SizedBox(
            height: 45,
            child: TextField(
              controller: starlineCon.dateInputForResultHistory,
              style: CustomTextStyle.textRobotoSansMedium.copyWith(color: AppColors.appbarColor),
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
                    initialDate: starlineCon.bidHistoryDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  String formattedDate2 = DateFormat('dd-MM-yyyy').format(pickedDate);
                  starlineCon.dateInputForResultHistory.text = formattedDate2;

                  starlineCon.getDailyStarLineMarkets(startDate: formattedDate, endDate: formattedDate);
                  starlineCon.bidHistoryDate = pickedDate;
                }
              },
            ),
          ),
          SizedBox(height: Dimensions.h11),
          starlineCon.marketListForResult.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: starlineCon.marketListForResult.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        height: Dimensions.h50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 0.2,
                              color: AppColors.grey,
                              blurRadius: 1,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: Dimensions.w20),
                            SizedBox(width: Dimensions.w35, child: SvgPicture.asset(ConstantImage.stopWatchIcon)),
                            // Icon(Icons.watch, color: AppColors.black),
                            SizedBox(width: Dimensions.w10),
                            Text(
                              starlineCon.marketListForResult[index].time ?? "00:00 AM",
                              style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h15),
                            ),
                            Expanded(
                              child: SizedBox(width: Dimensions.w10),
                            ),
                            getResult(
                                      starlineCon.marketListForResult[index].isResultDeclared ?? false,
                                      starlineCon.marketListForResult[index].result ?? 0,
                                    ) !=
                                    "***-*"
                                ? Padding(
                                    padding: EdgeInsets.only(right: Dimensions.h50),
                                    child: Text(
                                      getResult(
                                        starlineCon.marketListForResult[index].isResultDeclared ?? false,
                                        starlineCon.marketListForResult[index].result ?? 0,
                                      ),
                                      style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h15),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(right: Dimensions.h50),
                                    child: SvgPicture.asset(
                                      ConstantImage.openStarsSvg,
                                      width: Dimensions.w60,
                                    ),
                                  )
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Container(
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
                      "NORESULTHISTORY".tr,
                      style: CustomTextStyle.textRobotoSansMedium.copyWith(
                        fontSize: Dimensions.h16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  String getResult(bool resultDeclared, int result) {
    if (resultDeclared) {
      int sum = 0;
      for (int i = result; i > 0; i = (i / 10).floor()) {
        sum += (i % 10);
      }
      return "$result - ${sum % 10}";
    } else {
      return "***-*";
    }
  }
}
