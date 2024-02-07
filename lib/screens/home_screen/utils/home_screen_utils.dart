import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/controller/home_controller.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/screens/home_screen/controller/homepage_controller.dart';
import 'package:spllive/utils/constant.dart';

import '../../../helper_files/app_colors.dart';
import '../../../helper_files/dimentions.dart';

class HomeScreenUtils {
  var controller = Get.put(HomePageController());
  final homeCon = Get.find<HomeController>();
  Widget buildResult({required bool isOpenResult, required bool resultDeclared, required int result}) {
    if (resultDeclared && result != 0 && result.toString().isNotEmpty) {
      int sum = 0;
      for (int i = result; i > 0; i = (i / 10).floor()) {
        sum += (i % 10);
      }
      return Text(
        isOpenResult ? "$result - ${sum % 10}" : "${sum % 10} - $result",
        style: CustomTextStyle.textRobotoSansMedium.copyWith(
          fontSize: Dimensions.h13,
          fontWeight: FontWeight.bold,
          color: AppColors.redColor,
          letterSpacing: 1,
        ),
      );
    } else if (result == 0 && result.toString().isNotEmpty && resultDeclared) {
      return Text(
        isOpenResult ? "000 - $result" : "$result - 000",
        style: CustomTextStyle.textRobotoSansMedium.copyWith(
          fontSize: Dimensions.h13,
          fontWeight: FontWeight.bold,
          color: AppColors.redColor,
          letterSpacing: 1,
        ),
      );
    } else {
      return SvgPicture.asset(
        isOpenResult ? AppImage.openStarsSvg : AppImage.closeStarsSvg,
        width: Dimensions.w60,
      );
    }
  }

  marketIcon({required Function() onTap, required String text, required String iconData, required Color iconColor}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: Dimensions.h22,
              width: Dimensions.w22,
              child: SvgPicture.asset(
                iconData,
                color: iconColor ?? AppColors.iconColorMain,
              ),
            ),
            // Icon(iconData),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: CustomTextStyle.textPTsansMedium.copyWith(
                    color: iconColor ?? AppColors.iconColorMain,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                    fontSize: Dimensions.h11),
              ),
            )
          ],
        ),
      ),
    );
  }

  iconsContainer({
    required Function() onTap1,
    required Function() onTap2,
    required Function() onTap3,
    required Color iconColor1,
    required Color iconColor2,
    required Color iconColor3,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            // color: Colors.amber,
            width: Dimensions.w100,
            child: marketIcon(
              iconColor: iconColor1,
              onTap: onTap1,
              text: "MARKET".tr,
              iconData: AppImage.marketIcon,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            // color: Colors.amber,
            width: Dimensions.w100,
            child:
                marketIcon(iconColor: iconColor2, onTap: onTap2, text: "STARLINE".tr, iconData: AppImage.starLineIcon),
          ),
        ),
        Expanded(
          child: SizedBox(
            // color: Colors.amber,
            width: Dimensions.w100,
            child: marketIcon(
              onTap: onTap3,
              iconColor: iconColor3,
              text: "ADD FUND".tr,
              iconData: AppImage.addFundIcon,
            ),
          ),
        ),
      ],
    );
  }

  iconsContainer2({
    required Function() onTap1,
    required Function() onTap2,
    required Function() onTap3,
    required Color iconColor1,
    required Color iconColor2,
    required Color iconColor3,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.h5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              // color: Colors.amber,
              width: Dimensions.w100,
              child: marketIcon(
                  iconColor: iconColor1, onTap: onTap1, text: "BIDHISTORY".tr, iconData: AppImage.bidHistoryIcon),
            ),
          ),
          Expanded(
            child: SizedBox(
              // color: Colors.amber,
              width: Dimensions.w100,
              child: marketIcon(
                  onTap: onTap2,
                  iconColor: iconColor2,
                  text: "RESULTHISTORY2".tr,
                  iconData: AppImage.resultHistoryIcons),
            ),
          ),
          Expanded(
            child: SizedBox(
              // color: Colors.amber,
              width: Dimensions.w100,
              child: marketIcon(
                onTap: onTap3,
                iconColor: iconColor3,
                text: "CHART2".tr,
                iconData: AppImage.chartIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // gridColumn() {
  //   return Obx(
  //     () => controller.normalMarketList.isNotEmpty
  //         ? Column(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //                 child: InkWell(
  //                   onTap: () => launch("https://wa.me/+917769826748/?text=hi"),
  //                   child: Container(
  //                     width: double.infinity,
  //                     height: Dimensions.h30,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(25),
  //                       gradient: LinearGradient(
  //                         colors: [AppColors.wpColor1, AppColors.wpColor2],
  //                       ),
  //                     ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Padding(
  //                           padding: const EdgeInsets.all(3.0),
  //                           child: Image.asset(
  //                             AppImage.whatsaapIcon,
  //                             fit: BoxFit.contain,
  //                           ),
  //                         ),
  //                         const SizedBox(width: 4),
  //                         Text(
  //                           "+91 7769826748",
  //                           style: CustomTextStyle.textRobotoSansBold.copyWith(color: AppColors.white),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               GridView.builder(
  //                 padding: EdgeInsets.all(Dimensions.h5),
  //                 shrinkWrap: true,
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
  //                   maxCrossAxisExtent: Get.width / 2,
  //                   mainAxisExtent: Get.width / 2.4,
  //                   crossAxisSpacing: 0,
  //                   mainAxisSpacing: 10,
  //                 ),
  //                 itemCount: controller.normalMarketList.length,
  //                 itemBuilder: (context, index) {
  //                   MarketData marketData;
  //                   marketData = controller.normalMarketList[index];
  //                   return Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: Dimensions.h5),
  //                     child: GestureDetector(
  //                       onTap: () => marketData.isBidOpenForClose == true
  //                           ? controller.onTapOfNormalMarket(controller.normalMarketList[index])
  //                           : null,
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           boxShadow: [
  //                             BoxShadow(
  //                               spreadRadius: 0.2,
  //                               color: AppColors.grey,
  //                               blurRadius: 3.5,
  //                               offset: const Offset(2, 4),
  //                             )
  //                           ],
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(Dimensions.h10),
  //                           border: Border.all(color: Colors.red, width: 1),
  //                         ),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             SizedBox(
  //                               height: Dimensions.h10,
  //                             ),
  //                             Text(
  //                               "${marketData.openTime ?? " "} | ${marketData.closeTime ?? ""}",
  //                               style: CustomTextStyle.textRobotoSansLight.copyWith(fontWeight: FontWeight.w300),
  //                             ),
  //                             Text(
  //                               controller.normalMarketList[index].market ?? "",
  //                               // "MADHUR DAY",
  //                               style: CustomTextStyle.textPTsansBold.copyWith(
  //                                 fontWeight: FontWeight.w800,
  //                                 fontSize: Dimensions.h14,
  //                               ),
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: [
  //                                 buildResult(
  //                                     isOpenResult: true,
  //                                     resultDeclared: marketData.isOpenResultDeclared ?? false,
  //                                     result: marketData.openResult ?? 0),
  //                                 buildResult(
  //                                   isOpenResult: false,
  //                                   resultDeclared: marketData.isCloseResultDeclared ?? false,
  //                                   result: marketData.closeResult ?? 0,
  //                                 )
  //                               ],
  //                             ),
  //                             playButton(),
  //                             SizedBox(height: Dimensions.h5),
  //                             Container(
  //                               height: Dimensions.h30,
  //                               decoration: BoxDecoration(
  //                                 color: Colors.grey.shade400.withOpacity(0.8),
  //                                 borderRadius: const BorderRadius.only(
  //                                   bottomLeft: Radius.circular(10),
  //                                   bottomRight: Radius.circular(10),
  //                                 ),
  //                               ),
  //                               child: Center(
  //                                 child: Text(
  //                                   marketData.isBidOpenForClose == true ? "Bidding is Open" : "Bidding is Closed",
  //                                   style: marketData.isBidOpenForClose == true
  //                                       ? CustomTextStyle.textPTsansMedium.copyWith(
  //                                           color: AppColors.greenShade,
  //                                           fontWeight: FontWeight.w500,
  //                                         )
  //                                       : CustomTextStyle.textPTsansMedium.copyWith(
  //                                           color: AppColors.redColor,
  //                                           fontWeight: FontWeight.w500,
  //                                         ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ],
  //           )
  //         : const Center(child: Text("No Data Found")),
  //   );
  // }

  Container playButton() {
    return Container(
      height: Dimensions.h25,
      width: Dimensions.w80,
      decoration: BoxDecoration(color: AppColors.blueButton, borderRadius: BorderRadius.circular(25)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            child: Padding(
              padding: EdgeInsets.only(left: Dimensions.w15, bottom: 2),
              child: Text(
                "PLAY2".tr,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: Icon(
                Icons.play_circle_fill,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  notificationAbout(BuildContext context) {
    return Stack(
      children: [
        Material(
          color: AppColors.black.withOpacity(0.4),
          child: Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: Dimensions.h95,
              bottom: 60.0,
            ),
            child: Container(
              color: AppColors.white,
              width: double.infinity,
              child: Obx(
                () => ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.notificationData.length,
                  itemBuilder: (context, index) {
                    return notificationWidget(
                      notifiactionHeder: controller.notificationData[index].title ?? "",
                      notifiactionSubTitle: controller.notificationData[index].description ?? "",
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Material(
          color: AppColors.transparent,
          child: Padding(
            padding: EdgeInsets.only(
              top: Dimensions.h87,
              bottom: 8.0,
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  // controller.resetNotificationCount();
                  // controller.getNotifiactionCount.refresh();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(Dimensions.r10),
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.redColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget notificationWidget({required String notifiactionHeder, required String notifiactionSubTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              color: AppColors.grey.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.h8),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Dimensions.h5,
              ),
              Text(
                notifiactionHeder,
                style: CustomTextStyle.textRobotoSansBold.copyWith(
                  color: AppColors.black,
                  fontSize: Dimensions.h14,
                ),
              ),
              SizedBox(
                height: Dimensions.h5,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  child: Text(
                    notifiactionSubTitle,
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h13,
                    ),
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
