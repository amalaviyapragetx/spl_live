import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/components/bidlist_for_market.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../../Custom Controllers/wallet_controller.dart';
import '../../components/edit_text_field_with_icon.dart';
import '../../components/simple_button_with_corner.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/constant_image.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../../helper_files/ui_utils.dart';
import 'controller/normal_game_page_controller.dart';

///////// ODD Even Page DIGITBASEDJODI
class NormalGamePage extends StatefulWidget {
  NormalGamePage({super.key});

  @override
  State<NormalGamePage> createState() => _NormalGamePageState();
}

class _NormalGamePageState extends State<NormalGamePage> {
  final controller = Get.find<NormalGamePageController>();
  final walletController = Get.put(WalletController());
  var verticalSpace = SizedBox(height: Dimensions.h10);

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        if (value) {
          return;
        }
        controller.onClose();
        Get.offAndToNamed(AppRoutName.gameModePage, arguments: controller.marketValue.value);
      },
      child: Obx(
        () => Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppUtils().simpleAppbar(
            appBarTitle: controller.marketName.value,
            actions: [
              InkWell(
                onTap: () {
                  //  Get.offAndToNamed(AppRoutName.transactionPage);
                },
                child: Row(
                  children: [
                    SizedBox(
                      height: Dimensions.h20,
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
                        bottom: Dimensions.r5,
                        left: Dimensions.r10,
                        right: Dimensions.r10,
                      ),
                      child: Obx(
                        () => Text(
                          walletController.walletBalance.toString(),
                          style: CustomTextStyle.textRobotoSansMedium.copyWith(
                            color: AppColors.white,
                            fontSize: Dimensions.h17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SizedBox(
            child: Column(
              children: [
                verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: controller.gameMode.value.name != null
                        ? (controller.gameMode.value.name ?? "").toUpperCase().contains("JODI")
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      Text(
                        // controller.gameMode.value.name.toString(),
                        (controller.gameMode.value.name ?? "").toUpperCase(),
                        style: CustomTextStyle.textRobotoSansBold.copyWith(
                          color: AppColors.appbarColor,
                          fontSize: Dimensions.h18,
                        ),
                      ),
                      Text(
                        // "",
                        (controller.gameMode.value.name ?? "").toUpperCase().contains("JODI")
                            ? ""
                            : controller.biddingType.value.toUpperCase(),
                        style: CustomTextStyle.textRobotoSansBold.copyWith(
                          color: AppColors.appbarColor,
                          fontSize: Dimensions.h18,
                        ),
                      )
                    ],
                  ),
                ),
                verticalSpace,
                (controller.gameMode.value.name ?? "").toUpperCase().contains("SPDP")
                    ? Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            spDpTp(
                              controller.spValue1.value ? AppColors.wpColor1 : AppColors.white,
                              controller.spValue,
                              controller.spValue1.value ? AppColors.white : AppColors.grey,
                              onTap: () {
                                controller.spValue1.value = !controller.spValue1.value;
                                if (controller.spValue1.value) {
                                  controller.selectedValues.add("SP");
                                } else {
                                  controller.selectedValues.remove("SP");
                                }
                              },
                            ),
                            spDpTp(
                              controller.dpValue2.value ? AppColors.wpColor1 : AppColors.white,
                              controller.dpValue,
                              controller.dpValue2.value ? AppColors.white : AppColors.grey,
                              onTap: () {
                                controller.dpValue2.value = !controller.dpValue2.value;
                                if (controller.dpValue2.value) {
                                  controller.selectedValues.add("DP");
                                } else {
                                  controller.selectedValues.remove("DP");
                                }
                              },
                            ),
                            spDpTp(
                              controller.tpValue3.value ? AppColors.wpColor1 : AppColors.white,
                              controller.tpValue,
                              controller.tpValue3.value ? AppColors.white : AppColors.grey,
                              onTap: () {
                                controller.tpValue3.value = !controller.tpValue3.value;
                                if (controller.tpValue3.value) {
                                  controller.selectedValues.add("TP");
                                } else {
                                  controller.selectedValues.remove("TP");
                                }
                              },
                            )
                          ],
                        ),
                      )
                    : Container(),
                (controller.gameMode.value.name ?? "").toUpperCase().contains("SPDP") ? verticalSpace : Container(),
                (controller.gameMode.value.name ?? "").toUpperCase().contains("ODD EVEN")
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Obx(
                              () => oddEvenContainer(
                                buttonColor: controller.oddbool.value ? AppColors.wpColor1 : AppColors.white,
                                textColor: controller.oddbool.value ? AppColors.white : AppColors.black,
                                text: "odd",
                                onTap: () {
                                  controller.oddbool.value = !controller.oddbool.value;
                                  if (controller.oddbool.value) {
                                    controller.evenbool.value = false;
                                  } else {
                                    controller.evenbool.value = true;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: Dimensions.w10,
                            ),
                            Obx(
                              () => oddEvenContainer(
                                buttonColor: controller.evenbool.value ? AppColors.wpColor1 : AppColors.white,
                                textColor: controller.evenbool.value ? AppColors.white : AppColors.black,
                                text: "Even",
                                onTap: () {
                                  controller.evenbool.value = !controller.evenbool.value;
                                  if (controller.evenbool.value) {
                                    controller.oddbool.value = false;
                                  } else {
                                    controller.oddbool.value = true;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(Dimensions.r10),
                                    ),
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
                                    hintTextColor: AppColors.appbarColor.withOpacity(0.5),
                                    width: size.width / 2,
                                    textAlign: TextAlign.center,
                                    controller: controller.leftAnkController,
                                    textStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                                      color: AppColors.black.withOpacity(0.7),
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.h15,
                                    ),
                                    autofocus: true,
                                    hintTextStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                                      color: AppColors.black.withOpacity(0.7),
                                      fontSize: Dimensions.h13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    focusNode: controller.leftFocusNode,
                                    formatter: [FilteringTextInputFormatter.digitsOnly],
                                    onChanged: (val) {
                                      if (val?.length == controller.panaControllerLength.value) {
                                        controller.leftFocusNode.nextFocus();
                                        controller.middleFocusNode.requestFocus();
                                      }
                                    },
                                    maxLength: controller.panaControllerLength.value,
                                    hintText: "Left Ank",
                                    contentPadding: const EdgeInsets.only(right: 30),
                                    imagePath: "",
                                    containerBackColor: AppColors.black,
                                    iconColor: AppColors.white,
                                    height: Dimensions.h35,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ),
                            ),
                            (controller.gameMode.value.name ?? "").toUpperCase() == "DIGITS BASED JODI"
                                ? Container()
                                : Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(Dimensions.r10)),
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
                                          hintTextColor: AppColors.appbarColor.withOpacity(0.5),
                                          width: size.width / 2,
                                          textAlign: TextAlign.center,
                                          controller: controller.middleAnkController,
                                          textStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                                            color: AppColors.black.withOpacity(0.7),
                                            fontWeight: FontWeight.bold,
                                            fontSize: Dimensions.h15,
                                          ),
                                          hintTextStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                                            color: AppColors.black.withOpacity(0.7),
                                            fontSize: Dimensions.h13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          formatter: [FilteringTextInputFormatter.digitsOnly],
                                          focusNode: controller.middleFocusNode,
                                          onChanged: (val) {
                                            if (val?.length == controller.panaControllerLength.value) {
                                              controller.middleFocusNode.nextFocus();
                                              controller.rightFocusNode.requestFocus();
                                            }
                                          },
                                          maxLength: controller.panaControllerLength.value,
                                          hintText: "Middle Ank",
                                          contentPadding: const EdgeInsets.only(right: 30),
                                          imagePath: "",
                                          containerBackColor: AppColors.black,
                                          iconColor: AppColors.white,
                                          height: Dimensions.h35,
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ),
                                  ),
                            Expanded(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.r10)),
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
                                  hintTextColor: AppColors.appbarColor.withOpacity(0.5),
                                  width: size.width / 2,
                                  textAlign: TextAlign.center,
                                  controller: controller.rightAnkController,
                                  textStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                                    color: AppColors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimensions.h15,
                                  ),
                                  hintTextStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                                    color: AppColors.black.withOpacity(0.7),
                                    fontSize: Dimensions.h13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  formatter: [FilteringTextInputFormatter.digitsOnly],
                                  focusNode: controller.rightFocusNode,
                                  onChanged: (val) {
                                    if (val?.length == controller.panaControllerLength.value) {
                                      controller.rightFocusNode.nextFocus();
                                      controller.coinFocusNode.requestFocus();
                                    }
                                  },
                                  maxLength: controller.panaControllerLength.value,
                                  hintText: "Right Ank",
                                  contentPadding: const EdgeInsets.only(right: 40),
                                  imagePath: "",
                                  containerBackColor: AppColors.black,
                                  iconColor: AppColors.white,
                                  height: Dimensions.h35,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                verticalSpace,
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(Dimensions.r10)),
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
                              hintTextColor: AppColors.appbarColor.withOpacity(0.5),
                              width: size.width / 2,
                              textAlign: TextAlign.center,
                              controller: controller.coinController,
                              textStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                                color: AppColors.black.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.h15,
                              ),
                              hintTextStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                                color: AppColors.black.withOpacity(0.7),
                                fontSize: Dimensions.h13,
                                fontWeight: FontWeight.bold,
                              ),
                              formatter: [FilteringTextInputFormatter.digitsOnly],
                              focusNode: controller.coinFocusNode,
                              autofocus:
                                  (controller.gameMode.value.name ?? "").toUpperCase() == "ODD EVEN" ? true : false,
                              onChanged: (val) {
                                if (val != null) {
                                  if (val.characters.characterAt(0) == Characters("0")) {
                                    // we need to remove the first char
                                    controller.coinController.text = val.substring(1);
                                    // we need to move the cursor
                                    controller.coinController.selection = TextSelection.collapsed(
                                      offset: controller.coinController.text.length,
                                    );
                                  } else if (int.parse(val) > 10000) {
                                    AppUtils.showErrorSnackBar(bodyText: "You can not add more than 10000 points");
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
                              hintText: "Enter Points",
                              contentPadding: const EdgeInsets.only(right: 40),
                              imagePath: "",
                              containerBackColor: AppColors.black,
                              iconColor: AppColors.white,
                              height: Dimensions.h35,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Dimensions.w10,
                        ),
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(Dimensions.r10)),
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
                            child: RoundedCornerButton(
                              text: "PLUSADD".tr,
                              color: AppColors.appbarColor,
                              borderColor: AppColors.appbarColor,
                              fontSize: Dimensions.h12,
                              fontWeight: FontWeight.w600,
                              fontColor: AppColors.white,
                              letterSpacing: 1,
                              borderRadius: Dimensions.r7,
                              borderWidth: 0.2,
                              textStyle: CustomTextStyle.textRobotoSansBold,
                              onTap: () {
                                // controller.coinsFocusNode.unfocus();
                                // controller.openFocusNode.requestFocus();
                                //   controller.onTapOfAddButton();
                                if ((controller.gameMode.value.name ?? "").toUpperCase().contains("ODD EVEN")) {
                                  controller.onTapAddOddEven();
                                } else if ((controller.gameMode.value.name ?? "").toUpperCase() ==
                                    "DIGITS BASED JODI") {
                                  controller.newDigitBasedData();
                                  // controller.digitsBasedJodiData();
                                } else if (controller.gameMode.value.name == "Choice Pana SPDP") {
                                  if (controller.spValue1.value == false &&
                                      controller.dpValue2.value == false &&
                                      controller.tpValue3.value == false) {
                                    AppUtils.showErrorSnackBar(
                                      bodyText: "Please select SP,DP or TP",
                                      duration: const Duration(milliseconds: 900),
                                    );
                                  } else {
                                    controller.getChoicePanaSPDPTP();
                                    controller.groupJodiData();
                                  }
                                  //  controller.groupJodiData();
                                } else {
                                  controller.groupJodiData();
                                }
                              },
                              height: Dimensions.h35,
                              width: Dimensions.w150,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace,
                bidList(size),
                verticalSpace,
                verticalSpace,
                verticalSpace,
                verticalSpace,
              ],
            ),
          ),
          bottomSheet: bottombar(size, context),
        ),
      ),
    );
  }

  Expanded oddEvenContainer({
    required String text,
    required Function() onTap,
    required Color textColor,
    required Color buttonColor,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: Dimensions.h35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(Dimensions.r10)),
            color: buttonColor,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 3,
                spreadRadius: 0.2,
                color: AppColors.grey.withOpacity(0.7),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: CustomTextStyle.textRobotoSansBold.copyWith(
                color: textColor,
                fontSize: Dimensions.h14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bottombar(Size size, context) {
    return Obx(
      () => Container(
        width: size.width,
        height: Dimensions.h45,
        color: AppColors.appbarColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            nameColumn(
                titleText: "Bids",
                subText: controller.selectedBidsList.length.toString(),
                textColor: AppColors.white,
                textColor2: AppColors.white),
            nameColumn(
                titleText: "Points",
                subText: controller.totalAmount.toString(),
                textColor: AppColors.white,
                textColor2: AppColors.white),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: RoundedCornerButton(
                text: "SUBMIT".tr.toUpperCase(),
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

                  controller.onTapOfSaveButton(context);
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

  Widget bidList(Size size) {
    return Obx(
      () => controller.selectedBidsList.isEmpty
          ? Container()
          : Expanded(
              child: ListView.builder(
                itemCount: controller.selectedBidsList.length,
                itemBuilder: (context, item) {
                  return BidHistoryList(
                    bidType: controller.biddingType.value.toString(),
                    bidCoin: controller.selectedBidsList.elementAt(item).coins.toString(),
                    bidNo: controller.selectedBidsList.elementAt(item).bidNo.toString(),
                    onDelete: () => controller.onDeleteBids(item),
                    marketName: controller.checkType(item),
                  );
                },
              ),
            ),
    );
  }

  Widget spDpTp(Color containerColor, String text, Color textColor, {required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        height: Dimensions.h25,
        width: Dimensions.w70,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              spreadRadius: 0.2,
              color: AppColors.grey.withOpacity(0.7),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: CustomTextStyle.textRobotoSansMedium.copyWith(color: textColor),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Icon(
                Icons.check_box,
                color: textColor,
                size: 15,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget nameColumn(
      {required String? titleText, required String subText, required Color textColor, required Color textColor2}) {
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
                      titleText ?? "",
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
