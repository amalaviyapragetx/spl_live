import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spllive/routes/app_routes_name.dart';
import 'package:spllive/screens/More%20Details%20Screens/Create%20Withdrawal%20Page/controller/create_withdrawal_page_controller.dart';

import '../../../components/edit_text_field_with_icon.dart';
import '../../../components/simple_button_with_corner.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';

// ignore: must_be_immutable
class CreatewithDrawalPage extends StatelessWidget {
  CreatewithDrawalPage({super.key});
  var controller = Get.put(CreateWithDrawalPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppUtils().simpleAppbar(
        appBarTitle: "Request Admin",
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () => _showExitDialog(),
              child: Icon(
                Icons.note_alt_rounded,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.h5),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Obx(
              () => Column(
                children: [
                  SizedBox(height: Dimensions.h10),
                  Row(
                    children: [
                      Expanded(
                        child: RoundedCornerEditTextWithIcon(
                          height: Dimensions.h40,
                          controller: controller.amountTextController,
                          keyboardType: TextInputType.phone,
                          hintText: "Enter Amount",
                          imagePath: "",
                          maxLines: 1,
                          minLines: 1,
                          isEnabled: true,
                          maxLength: 10,
                          formatter: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.h10),
                  listTileDetails(text: "BANK_TEXT".tr, value: controller.bankName.value),
                  listTileDetails(text: "ACNAME_TEXT".tr, value: controller.accountName.value),
                  listTileDetails(text: "ACNO_TEXT".tr, value: controller.accountNumber.value),
                  listTileDetails(text: "IFSC_TEXT".tr, value: controller.ifcsCode.value),
                  SizedBox(height: Dimensions.h10),
                  SizedBox(height: Dimensions.h10),
                  controller.bankName.value != ""
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: RoundedCornerButton(
                            text: "CONTINUE".tr,
                            color: AppColors.appbarColor,
                            borderColor: AppColors.appbarColor,
                            fontSize: Dimensions.h15,
                            fontWeight: FontWeight.w500,
                            fontColor: AppColors.white,
                            letterSpacing: 0,
                            borderRadius: Dimensions.r25,
                            borderWidth: 1,
                            textStyle: CustomTextStyle.textRobotoSlabBold,
                            onTap: () {
                              controller.createWithdrawalRequest();
                            },
                            height: Dimensions.h35,
                            width: double.infinity,
                          ),
                        )
                      : Container(),
                  SizedBox(height: Dimensions.h30),
                  Obx(
                    () => controller.bankName.value == "" || controller.bankName.value.isEmpty
                        ? SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "To Add Bank Detaiils ",
                                  style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                    fontSize: Dimensions.h13,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.offAndToNamed(AppRoutName.myAccountPage);
                                  },
                                  child: Text(
                                    "Click Here",
                                    style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                      fontSize: Dimensions.h13,
                                      color: AppColors.redColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    Get.defaultDialog(
      barrierDismissible: false,
      title: "Contact Admin",
      onWillPop: () async => false,
      titleStyle: CustomTextStyle.textRobotoSansMedium,
      content: Column(
        children: [Text("SNACKMSG_TEXT".tr, style: CustomTextStyle.textRobotoSansMedium)],
      ),
      actions: [
        InkWell(
          onTap: () async {
            Get.back();
          },
          child: Container(
            color: AppColors.appbarColor,
            height: Dimensions.h40,
            width: Dimensions.w150,
            child: Center(
              child: Text(
                'OK',
                style: CustomTextStyle.textRobotoSansBold.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // AlertDialog onExitAlert(BuildContext context,
  //     {required Function() onCancel}) {
  //   return AlertDialog(
  //     content:
  //         Text("SNACKMSG_TEXT".tr, style: CustomTextStyle.textRobotoSansMedium),
  //     actions: [
  //       Center(
  //         child: InkWell(
  //           onTap: onCancel,
  //           child: Container(
  //             height: Dimensions.h40,
  //             width: Dimensions.w150,
  //             color: AppColors.appbarColor,
  //             child: Center(
  //               child: Text(
  //                 'Ok',
  //                 style: CustomTextStyle.textRobotoSansBold.copyWith(
  //                   color: AppColors.white,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Padding listTileDetails({required String text, required String value}) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.w8),
      child: Container(
        height: Dimensions.h60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(Dimensions.r5),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: Dimensions.w10),
          child: Row(
            children: [
              Expanded(
                child: Text(text,
                    style: CustomTextStyle.textPTsansBold.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h16,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Expanded(
                child: Text(
                  value,
                  style: CustomTextStyle.textRobotoSansMedium.copyWith(
                    fontSize: Dimensions.h14,
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
