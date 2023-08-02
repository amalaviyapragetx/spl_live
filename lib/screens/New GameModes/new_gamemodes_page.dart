import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/components/new_auto_complete_text_field_with_suggetion.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/screens/New%20GameModes/controller/new_gamemode_page_controller.dart';
import '../../Custom Controllers/wallet_controller.dart';
import '../../components/simple_button_with_corner.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/constant_image.dart';
import '../../helper_files/dimentions.dart';
import '../../helper_files/ui_utils.dart';
import '../../routes/app_routes_name.dart';

class NewGameModePage extends StatelessWidget {
  NewGameModePage({super.key});
  var walletController = Get.put(WalletController());
  var controller = Get.put(NewGamemodePageController());
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
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Single Ank",
                    style: CustomTextStyle.textRobotoSansMedium.copyWith(
                      color: AppColors.appbarColor,
                      fontSize: Dimensions.h20,
                    ),
                  ),
                  Text(
                    "Open",
                    style: CustomTextStyle.textRobotoSansMedium.copyWith(
                      color: AppColors.appbarColor,
                      fontSize: Dimensions.h20,
                    ),
                  )
                ],
              ),
            ),
            verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                spDpTp(AppColors.wpColor1, "SP", AppColors.white),
                spDpTp(AppColors.wpColor1, "DP", AppColors.white),
                spDpTp(AppColors.white, "TP", AppColors.grey)
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoTextFieldWithSuggetion(
                      imagePath: "",
                      optionsBuilder: (p0) {
                        return Characters("");
                      },
                      height: Dimensions.h35,
                      controller: controller.digitController,
                      hintText: "Enter Single Ank",
                      containerWidth: double.infinity,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoTextFieldWithSuggetion(
                      imagePath: "",
                      optionsBuilder: (p0) {
                        return Characters("");
                      },
                      height: Dimensions.h35,
                      controller: controller.digitController,
                      hintText: "Enter Points",
                      containerWidth: double.infinity,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace,
            RoundedCornerButton(
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
                // controller.onTapOfAddBidButton();
              },
              height: Dimensions.h30,
              width: Dimensions.w150,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: Dimensions.h50,
                width: size.width,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 1,
                        spreadRadius: 3,
                        color: AppColors.grey.withOpacity(0.2),
                        offset: const Offset(0, 1)),
                  ],
                ),
                child: Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        nameColumn(
                            subText: "",
                            titleText: "open",
                            textColor2: AppColors.black.withOpacity(0.5),
                            textColor: AppColors.black),
                        nameColumn(
                            subText: "",
                            titleText: "1",
                            textColor2: AppColors.black.withOpacity(0.5),
                            textColor: AppColors.black),
                        nameColumn(
                            subText: "",
                            titleText: "20",
                            textColor2: AppColors.black.withOpacity(0.5),
                            textColor: AppColors.black),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, left: 0),
                      child: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.delete,
                          color: AppColors.redColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: size.width,
        height: Dimensions.h45,
        color: AppColors.appbarColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            nameColumn(
                titleText: "Bids",
                subText: "0",
                textColor: AppColors.white,
                textColor2: AppColors.white),
            nameColumn(
                titleText: "Bids",
                subText: "0",
                textColor: AppColors.white,
                textColor2: AppColors.white),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: RoundedCornerButton(
                text: "SAVE".tr.toUpperCase(),
                color: AppColors.white,
                borderColor: AppColors.white,
                fontSize: Dimensions.h11,
                fontWeight: FontWeight.w600,
                fontColor: AppColors.black,
                letterSpacing: 1,
                borderRadius: Dimensions.r5,
                borderWidth: 0.2,
                textStyle: CustomTextStyle.textRobotoSansBold,
                onTap: () {
                  // controller.coinsFocusNode.unfocus();
                  // controller.openFocusNode.requestFocus();
                  // controller.onTapOfAddBidButton();
                },
                height: Dimensions.h25,
                width: Dimensions.w100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget spDpTp(Color containerColor, String text, Color textColor) {
    return Container(
      height: Dimensions.h20,
      width: Dimensions.w70,
      decoration: BoxDecoration(
        color: containerColor,
        border: Border.all(color: AppColors.grey),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style:
                CustomTextStyle.textRobotoSansMedium.copyWith(color: textColor),
          ),
          Icon(
            Icons.check_box,
            color: textColor,
            size: 15,
          )
        ],
      ),
    );
  }

  Widget nameColumn(
      {required String? titleText,
      required String subText,
      required Color textColor,
      required Color textColor2}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3.0,
      ),
      child: SizedBox(
        // color: AppColors.balanceCoinsColor,
        width: Dimensions.w95,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              titleText == ""
                  ? Container()
                  : Text(
                      textAlign: TextAlign.center,
                      titleText!,
                      style: CustomTextStyle.textRobotoSansMedium.copyWith(
                        color: textColor,
                        fontSize: Dimensions.h13,
                      ),
                    ),
              subText == ""
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        subText,
                        style: CustomTextStyle.textRobotoSansLight.copyWith(
                          color: textColor2,
                          fontSize: Dimensions.h13,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
