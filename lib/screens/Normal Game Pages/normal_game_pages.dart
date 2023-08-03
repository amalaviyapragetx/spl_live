import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../Custom Controllers/wallet_controller.dart';
import '../../components/edit_text_field_with_icon.dart';
import '../../components/simple_button_with_corner.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/constant_image.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../../helper_files/ui_utils.dart';
import '../../routes/app_routes_name.dart';
import 'controller/normal_game_page_controller.dart';

///////// ODD Even Page DIGITBASEDJODI
class NormalGamePage extends StatelessWidget {
  NormalGamePage({super.key});
  final controller = Get.find<NormalGamePageController>();
  final walletController = Get.put(WalletController());
  var verticalSpace = SizedBox(
    height: Dimensions.h10,
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppUtils().simpleAppbar(
        appBarTitle: "NormalMarket",
        actions: [
          InkWell(
            onTap: () => Get.offAndToNamed(AppRoutName.transactionPage),
            child: Row(
              children: [
                SizedBox(
                  height: Dimensions.w22,
                  width: Dimensions.w25,
                  child: SvgPicture.asset(
                    ConstantImage.walletAppbar,
                    color: AppColors.white,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: Dimensions.r8,
                      bottom: Dimensions.r10,
                      left: Dimensions.r15,
                      right: Dimensions.r10),
                  child: Obx(
                    () => Text(
                      walletController.walletBalance.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                // mainAxisAlignment: controller.gameMode.value.name!
                //         .toUpperCase()
                //         .contains("JODI")
                //     ? MainAxisAlignment.center
                //     : MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "hello",
                    // controller.gameMode.value.name!.toUpperCase(),
                    style: CustomTextStyle.textRobotoSansBold.copyWith(
                      color: AppColors.appbarColor,
                      fontSize: Dimensions.h20,
                    ),
                  ),
                  Text(
                    "",
                    // controller.gameMode.value.name!
                    //         .toUpperCase()
                    //         .contains("JODI")
                    //     ? ""
                    //     : controller.biddingType.value.toUpperCase(),
                    style: CustomTextStyle.textRobotoSansBold.copyWith(
                      color: AppColors.appbarColor,
                      fontSize: Dimensions.h20,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(Dimensions.r10)),
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 3,
                              spreadRadius: 0.2,
                              color: AppColors.grey.withOpacity(0.7),
                            ),
                          ],
                        ),
                        child: RoundedCornerEditTextWithIcon(
                            tapTextStyle: AppColors.appbarColor,
                            hintTextColor:
                                AppColors.appbarColor.withOpacity(0.5),
                            width: size.width / 2,
                            textAlign: TextAlign.center,
                            controller: controller.coinController,
                            textStyle:
                                CustomTextStyle.textPTsansMedium.copyWith(
                              color: AppColors.black.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.h15,
                            ),
                            hintTextStyle:
                                CustomTextStyle.textRobotoSansMedium.copyWith(
                              color: AppColors.black.withOpacity(0.7),
                              fontSize: Dimensions.h15,
                              fontWeight: FontWeight.bold,
                            ),
                            formatter: [FilteringTextInputFormatter.digitsOnly],
                            // onEditingComplete: () {
                            //   if (controller.coinController.text.length <
                            //       2) {
                            //
                            //   }
                            // },
                            onChanged: (val) {
                              if (val != null) {
                                print("111111111111");
                                if (val.characters.characterAt(0) ==
                                    Characters("0")) {
                                  print("22222222222222");
                                  // we need to remove the first char
                                  controller.coinController.text =
                                      val.substring(1);
                                  // we need to move the cursor
                                  controller.coinController.selection =
                                      TextSelection.collapsed(
                                    offset:
                                        controller.coinController.text.length,
                                  );
                                } else if (int.parse(val) > 10000) {
                                  AppUtils.showErrorSnackBar(
                                      bodyText:
                                          "You can not add more than 10000 points");
                                } else {
                                  // if (int.parse(val) >= 1) {
                                  //   print("333333333333333   ${val.length}");
                                  //   // controller.validCoinsEntered.value = true;
                                  //   // controller.isEnable.value = true;
                                  // } else {
                                  //   print("444444444444444444   ${val.length}");
                                  //   // controller.ondebounce();

                                  //   // controller.validCoinsEntered.value = false;
                                  //   // controller.isEnable.value = false;
                                  // }
                                }
                              }
                            },
                            maxLength: 5,
                            hintText: "COINS".tr,
                            contentPadding: const EdgeInsets.only(right: 40),
                            imagePath: "",
                            containerBackColor: AppColors.black,
                            iconColor: AppColors.white,
                            height: Dimensions.h35,
                            keyboardType: TextInputType.number),
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.w10,
                    ),
                    Expanded(
                      child: RoundedCornerButton(
                        text: "PLUSADD".tr,
                        color: AppColors.appbarColor,
                        borderColor: AppColors.appbarColor,
                        fontSize: Dimensions.h12,
                        fontWeight: FontWeight.w600,
                        fontColor: AppColors.white,
                        letterSpacing: 1,
                        borderRadius: Dimensions.r5,
                        borderWidth: 0.2,
                        textStyle: CustomTextStyle.textRobotoSansBold,
                        onTap: () {
                          // controller.coinsFocusNode.unfocus();
                          // controller.openFocusNode.requestFocus();
                          //   controller.onTapOfAddButton();
                        },
                        height: Dimensions.h35,
                        width: Dimensions.w150,
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
