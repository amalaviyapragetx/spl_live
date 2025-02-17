import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/helper_files/ui_utils.dart';

import '../../Custom Controllers/wallet_controller.dart';
import '../../components/new_edit_text_field_with_icon.dart';
import '../../components/simple_button_with_corner.dart';
import 'controller/game_page_controller.dart';

class SingleAnkPage extends StatefulWidget {
  SingleAnkPage({super.key});

  @override
  State<SingleAnkPage> createState() => _SingleAnkPageState();
}

class _SingleAnkPageState extends State<SingleAnkPage> {
  final controller = Get.find<GamePageController>();

  final walletController = Get.put(WalletController());
  @override
  void initState() {
    super.initState();
    controller.getArguments();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
        appBar: AppUtils().simpleAppbar(
          appBarTitle: controller.marketName.value,
          actions: [
            InkWell(
              onTap: () {},
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
        backgroundColor: AppColors.white,
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.h10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: Dimensions.h10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${controller.gameMode.name}".toUpperCase(),
                            // controller.gameMode.name!
                            //         .toUpperCase()
                            //         .contains("JODI")
                            //     ? " ${controller.gameMode.name}".toUpperCase(),
                            // : " ${controller.gameMode.name}".toUpperCase(),
                            style: CustomTextStyle.textRobotoSansBold
                                .copyWith(color: AppColors.appbarColor, fontSize: Dimensions.h18),
                            // style: TextStyle(
                            //     color: AppColors.appbarColor,
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: Dimensions.h18),
                          ),
                          Text(
                            controller.biddingType.value.toUpperCase(),
                            style: CustomTextStyle.textRobotoSansBold
                                .copyWith(color: AppColors.appbarColor, fontSize: Dimensions.h18),
                            // style: TextStyle(
                            //     color: AppColors.appbarColor,
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: Dimensions.h18),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.h5,
                      ),
                      Row(
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
                              child: RoundedCornerEditTextWithIcon2(
                                formatter: [FilteringTextInputFormatter.digitsOnly],
                                tapTextStyle: AppColors.black,
                                hintTextColor: AppColors.black.withOpacity(0.5),
                                //textAlign: TextAlign.center,
                                hintTextStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                                  color: AppColors.black.withOpacity(0.5),
                                  fontSize: Dimensions.h15,
                                  fontWeight: FontWeight.bold,
                                ),
                                textStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                                  color: AppColors.black.withOpacity(0.8),
                                  fontSize: Dimensions.h15,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLength: 5,
                                width: size.width / 2,
                                onChanged: (val) {
                                  if (val != null) {
                                    if (val.characters.characterAt(0) == Characters("0")) {
                                      // we need to remove the first char
                                      controller.coinController.text = val.substring(1);
                                      // we need to move the cursor
                                      controller.coinController.selection = TextSelection.collapsed(
                                        offset: controller.coinController.text.length,
                                      );
                                    } else if (int.parse(val) >= 1) {
                                      controller.validCoinsEntered.value = true;
                                      controller.isEnable.value = true;
                                    } else if (int.parse(val) > 10000) {
                                      AppUtils.showErrorSnackBar(bodyText: "You can not add more than 10000 points");
                                      controller.validCoinsEntered.value = false;
                                      controller.isEnable.value = false;
                                    } else {
                                      controller.ondebounce();
                                      controller.validCoinsEntered.value = false;
                                      controller.isEnable.value = false;
                                    }
                                  } else {
                                    controller.validCoinsEntered.value = false;
                                    controller.isEnable.value = false;
                                  }
                                  controller.update();
                                },
                                controller: controller.coinController,
                                hintText: "Enter Points",
                                imagePath: "",
                                autofocus: true,
                                textAlign: TextAlign.center,
                                contentPadding: const EdgeInsets.only(right: 40),
                                containerBackColor: AppColors.transparent,
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
                              child: RoundedCornerEditTextWithIcon2(
                                formatter: [FilteringTextInputFormatter.digitsOnly],
                                tapTextStyle: AppColors.black,
                                hintTextColor: AppColors.black.withOpacity(0.5),
                                //textAlign: TextAlign.center,
                                hintTextStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                                  color: AppColors.black.withOpacity(0.5),
                                  fontSize: Dimensions.h15,
                                  fontWeight: FontWeight.bold,
                                ),
                                textStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                                  color: AppColors.black.withOpacity(0.8),
                                  fontSize: Dimensions.h15,
                                  fontWeight: FontWeight.bold,
                                ),
                                width: size.width / 2,
                                onChanged: (val) => controller.onSearch(val),
                                // onChanged: (value) {
                                //   controller.serchListMatch =
                                //       controller.digitList;
                                //   if (value == '') {
                                //     controller.matches.clear();
                                //     //controller.serchListMatch.clear();
                                //     return const Iterable<String>.empty();
                                //   } else {
                                //     // controller.matches.clear();
                                //     controller.matches
                                //         .addAll(controller.suggestionList);
                                //     controller.matches.retainWhere((s) {
                                //       return s.toLowerCase().contains(
                                //             value!.toLowerCase(),
                                //           );
                                //     });
                                //     for (var i = 0;
                                //         i < controller.serchListMatch.length;
                                //         i++) {
                                //       print(controller
                                //           .serchListMatch[i].isSelected);
                                //       print(
                                //           "******${controller.serchListMatch[i].value!} -- ${controller.serchListMatch[i].value!.contains(controller.searchController.text)}");
                                //       if (controller.serchListMatch[i].value!
                                //           .contains(
                                //         controller.searchController.text,
                                //       )) {
                                //         print(
                                //           " controller.serchListMatch[index].isSelected :- ${controller.serchListMatch[i].isSelected} ",
                                //         );
                                //       }
                                //     }
                                //   }
                                // },
                                controller: controller.searchController,
                                hintText: "SEARCH_TEXT".tr,
                                imagePath: ConstantImage.serchZoomIcon,
                                containerBackColor: AppColors.transparent,
                                height: Dimensions.h35,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.h11,
              ),
              numberLine(controller: controller),
              Obx(
                () {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 50,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: controller.digitList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(Dimensions.r10),
                            onTap: () => controller.isEnable.value ? controller.onTapNumberList(index) : null,
                            child: Opacity(
                              opacity: controller.validCoinsEntered.value ? 1 : 0.5,
                              child: numberRedioButton(
                                textColor: controller.digitList[index].isSelected ?? false
                                    ? AppColors.green
                                    : AppColors.appbarColor,
                                container: controller.digitList[index].isSelected ?? false
                                    ? Container(
                                        height: Dimensions.h15,
                                        width: Dimensions.h15,
                                        decoration: BoxDecoration(
                                          color: AppColors.green,
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(
                                            color: AppColors.green,
                                            width: Dimensions.w2,
                                          ),
                                        ),
                                        child: Center(
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Icon(Icons.check, size: 13, color: AppColors.white),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: Dimensions.h15,
                                        width: Dimensions.w15,
                                        decoration: BoxDecoration(
                                          color: AppColors.transparent,
                                          borderRadius: BorderRadius.circular(25),
                                          border: Border.all(
                                            color: AppColors.appbarColor,
                                            width: Dimensions.w2,
                                          ),
                                        ),
                                      ),
                                color: controller.digitList[index].isSelected ?? false
                                    ? AppColors.green
                                    : AppColors.transparent,
                                controller.digitList[index].value ?? "",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              )
              //  buttonContainer(size),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          width: size.width,
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
                  subText: controller.totalAmount.value.toString(),
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
                    controller.onTapOfSaveButton();
                  },
                  height: Dimensions.h25,
                  width: Dimensions.w100,
                ),
              ),
            ],
          ),
        ),
        //  bottomNavigationBar: bottomNavigationBar(controller.totalAmount.value),
      ),
    );
  }

  Widget nameColumn(
      {required String titleText, required String subText, required Color textColor, required Color textColor2}) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 2,
      ),
      child: SizedBox(
        width: Dimensions.w95,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                textAlign: TextAlign.center,
                titleText,
                style: CustomTextStyle.textRobotoSansBold.copyWith(
                  color: textColor,
                  fontSize: Dimensions.h13,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  textAlign: TextAlign.center,
                  subText,
                  style: CustomTextStyle.textRobotoSansBold.copyWith(
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

  bottomNavigationBar(String totalAmount) {
    return SafeArea(
      child: Container(
        height: Dimensions.h50,
        color: AppColors.appbarColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.commonPaddingForScreen,
              ),
              child: Text(
                "TOTALCOIN".tr,
                style: CustomTextStyle.textRobotoSansMedium.copyWith(
                  color: AppColors.white,
                  fontSize: Dimensions.h18,
                ),
                // style: TextStyle(
                // color: AppColors.white,
                // fontSize: Dimensions.h18,
                // ),
              ),
            ),
            Row(
              children: [
                Container(
                  height: Dimensions.h25,
                  width: Dimensions.h25,
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      ConstantImage.rupeeImage,
                      fit: BoxFit.contain,
                      color: AppColors.appbarColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.commonPaddingForScreen,
                  ),
                  child: Text(
                    totalAmount,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: Dimensions.h18,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget numberRedioButton(text, {required Color color, required Widget container, required Color textColor}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(Dimensions.r10),
        border: Border.all(
          color: color,
          width: Dimensions.w2,
        ),
      ),
      height: Dimensions.h40,
      width: Dimensions.w130,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              // child: widgetContainer,
              child: container),
          SizedBox(
            width: Dimensions.w20,
          ),
          Text(
            text,
            style: CustomTextStyle.textRobotoSansLight.copyWith(
              fontSize: Dimensions.h15,
              color: textColor,
            ),
          )
        ],
      ),
    );
  }

  // buttonContainer(size) {
  numberLine({required GamePageController controller}) {
    return controller.showNumbersLine.value
        ? Column(
            children: [
              SizedBox(
                //color: Colors.amberAccent,
                height: Dimensions.h33,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.digitRow.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            controller.onTapOfNumbersLine(index);
                            controller.selectedIndexOfDigitRow = index;
                          },
                          child: Container(
                            width: Dimensions.w30,
                            height: Dimensions.w30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: controller.digitRow[index].isSelected!
                                      ? AppColors.numberListContainer
                                      : AppColors.wpColor1,
                                  width: 1),
                              borderRadius: BorderRadius.circular(4),
                              color: controller.digitRow[index].isSelected! ? AppColors.white : AppColors.wpColor1,
                            ),
                            child: Center(
                              child: Text(
                                controller.digitRow[index].value ?? "",
                                style: TextStyle(
                                    color: controller.digitRow[index].isSelected ?? false
                                        ? AppColors.black
                                        : AppColors.white,
                                    fontSize: Dimensions.h15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: Dimensions.h10,
              ),
            ],
          )
        : const SizedBox();
  }
}
