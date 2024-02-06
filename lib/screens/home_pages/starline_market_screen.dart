import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/controller/home_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/screens/home_pages/normal_market_screen.dart';

class StarlineMarketScreen extends StatelessWidget {
  StarlineMarketScreen({super.key});
  final homeCon = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.h5),
      child: Obx(() => GridView.builder(
            padding: EdgeInsets.all(Dimensions.h5),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: Get.width / 2,
              mainAxisExtent: Get.width / 2.5,
              crossAxisSpacing: 7,
              mainAxisSpacing: Dimensions.h10,
            ),
            itemCount: homeCon.starLineMarketList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  // homeCon.starLineMarketList[index].isBidOpen == true
                  //     ? homeCon.onTapOfStarlineMarket(homeCon.starLineMarketList[index])
                  //     : null;
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 0.2,
                        color: AppColors.grey,
                        blurRadius: 2.5,
                        offset: const Offset(2, 3),
                      )
                    ],
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(Dimensions.h10),
                    border: Border.all(color: Colors.red, width: 1),
                  ),
                  child: Column(
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: Dimensions.h5),
                      SizedBox(height: Dimensions.h5),
                      Text(
                        homeCon.starLineMarketList.elementAt(index).time ?? "",
                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                          color: AppColors.black,
                          fontSize: Dimensions.h15,
                        ),
                      ),
                      SizedBox(height: Dimensions.h5),
                      buildResult(
                        isOpenResult: true,
                        resultDeclared: homeCon.starLineMarketList[index].isResultDeclared ?? false,
                        result: homeCon.starLineMarketList[index].result ?? 0,
                      ),
                      SizedBox(height: Dimensions.h5),
                      playButton(),
                      Expanded(child: SizedBox(height: Dimensions.h5)),
                      Container(
                        height: Dimensions.h30,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400.withOpacity(0.8),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            homeCon.starLineMarketList[index].isBidOpen == true
                                ? "Bidding is Open"
                                : "Bidding is Closed",
                            style: homeCon.starLineMarketList[index].isBidOpen == true
                                ? CustomTextStyle.textPTsansMedium.copyWith(color: AppColors.greenShade)
                                : CustomTextStyle.textPTsansMedium.copyWith(color: AppColors.redColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
