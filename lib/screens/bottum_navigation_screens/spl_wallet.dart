import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/custom_text_style.dart';

import '../../helper_files/constant_image.dart';
import '../../helper_files/dimentions.dart';
import '../../helper_files/ui_utils.dart';
import '../home_screen/controller/homepage_controller.dart';
import 'controller/bottum_navigation_controller.dart';

class SPLWallet extends StatelessWidget {
  SPLWallet({super.key});
  var controller = Get.put(MoreListController());
  var homeController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      //  color: Colors.green,
      height: size.height,
      width: double.infinity,
      child: Column(
        children: [
          AppUtils().simpleAppbar(
            appBarTitle: "",
            leadingWidht: Dimensions.w200,
            leading: Container(
              child: Row(
                children: [
                  SizedBox(width: Dimensions.w15),
                  Text(
                    "SPL_WALLET".tr,
                    style: CustomTextStyle.textRobotoSansMedium.copyWith(fontSize: Dimensions.h20),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: Dimensions.h10,
                  ),
                  Container(
                    height: Dimensions.h100,
                    width: size.width,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "WALLETBALANCE".tr,
                          style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h22),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: Dimensions.w40,
                              width: Dimensions.w40,
                              child: SvgPicture.asset(
                                ConstantImage.walletAppbar,
                                color: AppColors.appbarColor,
                              ),
                            ),
                            SizedBox(
                              width: Dimensions.w10,
                            ),
                            Text(
                              controller.walletBalance.toString(),
                              style: CustomTextStyle.textRobotoSansMedium
                                  .copyWith(fontSize: Dimensions.h28, color: AppColors.appbarColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.h10,
                  ),
                  SizedBox(
                    height: Dimensions.h10,
                  ),
                  InkWell(
                    onTap: () {
                      homeController.pageWidget.value = 0;
                      homeController.currentIndex.value = 0;
                      homeController.widgetContainer.value = 2;
                      // launch(
                      //   "https://wa.me/+917769826748/?text=hi",
                      // );
                    },
                    child: Container(
                      height: Dimensions.h50,
                      width: size.width,
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
                      child: Row(children: [
                        SizedBox(width: Dimensions.w10),
                        SvgPicture.asset(
                          ConstantImage.addFundIconInWallet,
                          height: Dimensions.h17,
                        ),
                        SizedBox(width: Dimensions.w15),
                        Text(
                          "ADDFUND".tr,
                          style: CustomTextStyle.textRobotoSansMedium.copyWith(fontSize: Dimensions.h18),
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.h10,
                  ),
                  InkWell(
                    onTap: () {
                      homeController.pageWidget.value = 5;
                      homeController.currentIndex.value = 5;
                    },
                    child: Container(
                      height: Dimensions.h50,
                      width: size.width,
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
                      child: Row(children: [
                        SizedBox(
                          width: Dimensions.w10,
                        ),
                        SvgPicture.asset(
                          ConstantImage.withDrawalFundIcon,
                          height: Dimensions.h17,
                        ),
                        SizedBox(
                          width: Dimensions.w15,
                        ),
                        Text(
                          "Withdrawal Fund",
                          style: CustomTextStyle.textRobotoSansMedium.copyWith(fontSize: Dimensions.h18),
                        ),
                      ]),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Expanded(
                  //         child: ButtonWidget(
                  //           onTap: () {},
                  //           text: "ADDFUND".tr,
                  //           buttonColor: AppColors.buttonColorDarkGreen,
                  //           height: Dimensions.h30,
                  //           width: size.width / 2,
                  //           radius: Dimensions.h25,
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: Dimensions.w5,
                  //       ),
                  //       Expanded(
                  //         child: ButtonWidget(
                  //           onTap: () {
                  //             homeController.pageWidget.value = 5;
                  //             homeController.currentIndex.value = 5;
                  //           },
                  //           text: "WITHDRAWAL_TXT".tr,
                  //           buttonColor: AppColors.buttonColorOrange,
                  //           height: Dimensions.h30,
                  //           width: size.width / 2,
                  //           radius: Dimensions.h25,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
