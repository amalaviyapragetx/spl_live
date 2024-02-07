import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spllive/controller/home_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/utils/constant.dart';

class ResultHistoryScreen extends StatefulWidget {
  const ResultHistoryScreen({super.key});

  @override
  State<ResultHistoryScreen> createState() => _ResultHistoryScreenState();
}

class _ResultHistoryScreenState extends State<ResultHistoryScreen> {
  final homeCon = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    homeCon.getDailyStarLineMarkets();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.h10),
      child: Obx(
        () => Column(
          children: [
            SizedBox(height: Dimensions.h11),
            SizedBox(
              height: 45,
              child: TextField(
                controller: homeCon.dateInputForResultHistory,
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
                      initialDate: homeCon.bidHistoryDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                    String formattedDate2 = DateFormat('dd-MM-yyyy').format(pickedDate);
                    homeCon.dateInputForResultHistory.text = formattedDate2;

                    homeCon.getDailyStarLineMarkets(startDate: formattedDate, endDate: formattedDate);
                    homeCon.bidHistoryDate = pickedDate;
                  }
                },
              ),
            ),
            SizedBox(height: Dimensions.h11),
            homeCon.marketListForResult.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: homeCon.marketListForResult.length,
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
                              SizedBox(width: Dimensions.w35, child: SvgPicture.asset(AppImage.stopWatchIcon)),
                              SizedBox(width: Dimensions.w10),
                              Text(
                                homeCon.marketListForResult[index].time ?? "00:00 AM",
                                style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h15),
                              ),
                              Expanded(child: SizedBox(width: Dimensions.w10)),
                              homeCon.getResult(
                                        homeCon.marketListForResult[index].isResultDeclared ?? false,
                                        homeCon.marketListForResult[index].result ?? 0,
                                      ) !=
                                      "***-*"
                                  ? Padding(
                                      padding: EdgeInsets.only(right: Dimensions.h50),
                                      child: Text(
                                        homeCon.getResult(
                                          homeCon.marketListForResult[index].isResultDeclared ?? false,
                                          homeCon.marketListForResult[index].result ?? 0,
                                        ),
                                        style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h15),
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(right: Dimensions.h50),
                                      child: SvgPicture.asset(AppImage.openStarsSvg, width: Dimensions.w60),
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
      ),
    );
  }
}
