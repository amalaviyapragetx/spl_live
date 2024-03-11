import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/components/simple_button_with_corner.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/screens/home_screen/controller/homepage_controller.dart';

import '../../../helper_files/dimentions.dart';
import '../../../routes/app_routes_name.dart';

class WithdrawalPage extends StatelessWidget {
  WithdrawalPage({super.key});
  var walletController = Get.put(WalletController());
  var homeController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    var verticalSpace = SizedBox(height: Dimensions.h15);
    return Material(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppColors.appbarColor,
              padding: const EdgeInsets.all(15.0),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Icons.arrow_back, color: AppColors.white)),
                        // SvgPicture.asset(
                        //   ConstantImage.walletAppbar,
                        //   height: 25,
                        //   width: 30,
                        //   color: AppColors.white,
                        // ),
                        const SizedBox(width: 5),
                        // GetBuilder<WalletController>(
                        //   builder: (con) => Flexible(
                        //     child: Text(
                        //       con.walletBalance.value,
                        //       style: CustomTextStyle.textRobotoSansMedium.copyWith(
                        //         fontSize: Dimensions.h16,
                        //         color: AppColors.white,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Text(
                      textAlign: TextAlign.center,
                      "Withdrawal Fund",
                      style: CustomTextStyle.textRobotoSansMedium.copyWith(
                        color: AppColors.white,
                        fontSize: Dimensions.h18,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
            WillPopScope(
              onWillPop: () async {
                homeController.pageWidget.value = 4;
                homeController.currentIndex.value = 4;
                Get.toNamed(AppRoutName.dashBoardPage);
                return false;
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.w20, vertical: Dimensions.h10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpace,
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 4,
                            color: AppColors.grey.withOpacity(0.5),
                            offset: const Offset(0, 0),
                          )
                        ],
                        borderRadius: BorderRadius.circular(Dimensions.r4),
                      ),
                      child: Column(
                        children: [
                          verticalSpace,
                          Text(
                            "Withdrawal Timing",
                            style: CustomTextStyle.textRamblaBold.copyWith(
                              color: AppColors.appbarColor,
                              fontSize: Dimensions.h20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "10:00 AM",
                                      style: CustomTextStyle.textRobotoSansBold.copyWith(
                                        color: AppColors.black,
                                        fontSize: Dimensions.h14,
                                      ),
                                    ),
                                    Text(
                                      "  to ",
                                      style: CustomTextStyle.textRobotoSansLight.copyWith(
                                        color: AppColors.black,
                                        fontSize: Dimensions.h14,
                                      ),
                                    ),
                                    Text(
                                      "07:00 PM",
                                      style: CustomTextStyle.textRobotoSansBold.copyWith(
                                        color: AppColors.black,
                                        fontSize: Dimensions.h14,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Dimensions.h5),
                                Text(
                                  "(Withdrawal Available all days including Sunday & Bank Holidays )",
                                  textAlign: TextAlign.center,
                                  style: CustomTextStyle.textRobotoSansLight.copyWith(
                                    color: AppColors.black,
                                    fontSize: Dimensions.h14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.h5,
                          ),
                          Text(
                            "Minimum Withdrawal",
                            style: CustomTextStyle.textRamblaBold.copyWith(
                              color: AppColors.appbarColor,
                              fontSize: Dimensions.h20,
                            ),
                          ),
                          SizedBox(height: Dimensions.h5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Rs.",
                                style: CustomTextStyle.textRobotoSansBold.copyWith(
                                  color: AppColors.black,
                                  fontSize: Dimensions.h14,
                                ),
                              ),
                              Text(
                                " 500",
                                style: CustomTextStyle.textRobotoSansLight.copyWith(
                                  color: AppColors.black,
                                  fontSize: Dimensions.h14,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Note :",
                                  textAlign: TextAlign.start,
                                  style: CustomTextStyle.textRamblaBold.copyWith(
                                    color: AppColors.appbarColor,
                                    fontSize: Dimensions.h18,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      textAlign: TextAlign.start,
                                      "Withdrawal request processing time minimum 60 min to 24 Hrs ",
                                      style: CustomTextStyle.textRobotoSansLight.copyWith(
                                        color: AppColors.black,
                                        fontSize: Dimensions.h14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    verticalSpace,
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //     left: Dimensions.w10,
                    //     right: Dimensions.w10,
                    //     top: Dimensions.h10,
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Expanded(
                    //         child: RoundedCornerButton(
                    //           text: "CHECKWITHDRAWAL".tr,
                    //           color: AppColors.appbarColor,
                    //           borderColor: AppColors.appbarColor,
                    //           fontSize: Dimensions.h13,
                    //           fontWeight: FontWeight.w500,
                    //           fontColor: AppColors.white,
                    //           letterSpacing: 0.5,
                    //           borderRadius: Dimensions.r3,
                    //           borderWidth: 0,
                    //           textStyle: CustomTextStyle.textRobotoSansLight,
                    //           onTap: () => Get.toNamed(AppRoutName.createWithDrawalPage),
                    //           height: Dimensions.h40,
                    //           width: Dimensions.w200,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: Dimensions.h10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.w10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RoundedCornerButton(
                              text: "CHECKHISTORY".tr,
                              color: AppColors.wpColor1,
                              borderColor: AppColors.wpColor1,
                              fontSize: Dimensions.h13,
                              fontWeight: FontWeight.w500,
                              fontColor: AppColors.white,
                              letterSpacing: 0.5,
                              borderRadius: Dimensions.r3,
                              borderWidth: 0,
                              textStyle: CustomTextStyle.textRobotoSansLight,
                              onTap: () => Get.toNamed(AppRoutName.checkWithDrawalPage),
                              height: Dimensions.h40,
                              width: Dimensions.w200,
                            ),
                          ),
                        ],
                      ),
                    ),
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
