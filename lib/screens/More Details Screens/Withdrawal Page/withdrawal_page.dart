import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/components/simple_button_with_corner.dart';
import 'package:spllive/controller/home_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/custom_text_style.dart';

import '../../../helper_files/dimentions.dart';
import '../../../routes/app_routes_name.dart';

class WithdrawalPage extends StatefulWidget {
  WithdrawalPage({super.key});

  @override
  State<WithdrawalPage> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  final walletController = Get.put(WalletController());

  final homeCon = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        walletController.selectedIndex.value = null;
        return false;
      },
      child: Material(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: AppColors.appbarColor,
                padding: const EdgeInsets.all(10),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => walletController.selectedIndex.value = null,
                            child: Icon(Icons.arrow_back, color: AppColors.white),
                          ),
                          const SizedBox(width: 5),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.w20, vertical: Dimensions.h10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Dimensions.h15),
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
                          SizedBox(height: Dimensions.h15),
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
                                " 500/-",
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
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      textAlign: TextAlign.start,
                                      "Withdrawal request processing time minimum 60 min to 24 Hrs ",
                                      style: CustomTextStyle.textRobotoSansLight.copyWith(
                                        color: AppColors.black,
                                        fontSize: Dimensions.h13,
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
                    SizedBox(height: Dimensions.h15),
                    SizedBox(height: Dimensions.h10),
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
                              fontWeight: FontWeight.w600,
                              fontColor: AppColors.black,
                              letterSpacing: 0.5,
                              borderRadius: Dimensions.r3,
                              borderWidth: 0,
                              textStyle: CustomTextStyle.textRobotoSansLight,
                              onTap: () =>   Get.toNamed(AppRoutName.createWithDrawalPage),
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
            ],
          ),
        ),
      ),
    );
  }
}
