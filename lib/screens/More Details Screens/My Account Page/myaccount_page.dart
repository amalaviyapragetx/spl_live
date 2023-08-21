import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/components/edit_text_field_with_icon.dart';

import 'package:spllive/components/simple_button_with_corner.dart';

import '../../../helper_files/app_colors.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import 'controller/myaccount_page_controller.dart';

class MyAccountPage extends StatelessWidget {
  MyAccountPage({super.key});
  var controller = Get.put(MyAccountPageController());

  @override
  Widget build(BuildContext context) {
    var verticalSpace = SizedBox(
      height: Dimensions.h10,
    );
    return Scaffold(
      appBar: AppUtils().simpleAppbar(
        appBarTitle: "MYACCOUNT".tr,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                AppUtils.showErrorSnackBar(bodyText: "SNACKMSG_TEXT".tr);
              },
              child: Icon(
                Icons.note_alt_rounded,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Obx(
          () => Column(
            children: [
              verticalSpace,
              listTileDetails(
                  text: "BANK_TEXT".tr,
                  value: controller.bankName.value,
                  fieldController: controller.bankNameController,
                  autofocus: true),
              listTileDetails(
                  text: "ACNAME_TEXT".tr,
                  value: controller.accountName.value,
                  fieldController: controller.accHolderNameController),
              listTileDetails(
                  text: "ACNO_TEXT".tr,
                  value: controller.accountNumber.value,
                  fieldController: controller.accNoController),
              listTileDetails(
                  text: "IFSC_TEXT".tr,
                  value: controller.ifcsCode.value,
                  fieldController: controller.ifscCodeController),
              controller.isEditDetails.value == true
                  ? RoundedCornerButton(
                      text: "Submit",
                      color: AppColors.appbarColor,
                      borderColor: AppColors.appbarColor,
                      fontSize: Dimensions.h13,
                      fontWeight: FontWeight.bold,
                      fontColor: AppColors.white,
                      letterSpacing: 1,
                      borderRadius: 5,
                      borderWidth: 0,
                      textStyle: CustomTextStyle.textPTsansMedium,
                      onTap: () {
                        controller.onTapOfEditDetails();
                        Get.back();
                      },
                      height: 40,
                      width: 200,
                    )
                  // ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         backgroundColor: AppColors.appbarColor),
                  //     onPressed: () {
                  //       controller.onTapOfEditDetails();
                  //     },
                  //     child: Text(
                  //       "Submit",
                  //       style: CustomTextStyle.textPTsansMedium.copyWith(
                  //         fontSize: Dimensions.h14,
                  //         color: AppColors.white,
                  //       ),
                  //     ),
                  //   )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Padding listTileDetails(
      {required String text,
      required String value,
      required TextEditingController fieldController,
      bool? autofocus}) {
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
                flex: 1,
                child: Text(
                  text,
                  style: CustomTextStyle.textPTsansBold.copyWith(
                    color: AppColors.black,
                    fontSize: Dimensions.h16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: controller.isEditDetails.value == false
                    ? Text(
                        value,
                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                          fontSize: Dimensions.h14,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: bidHistoryList(fieldController,
                            autofocus: autofocus),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bidHistoryList(TextEditingController controller, {bool? autofocus}) {
    return RoundedCornerEditTextWithIcon(
      controller: controller,
      hintText: "",
      imagePath: "",
      height: Dimensions.h42,
      keyboardType: TextInputType.text,
      autofocus: autofocus,
    );
  }
}

// bidHistoryList(TextEditingController controller) {
//   return TextField(
//       controller: controller,
//       style: CustomTextStyle.textPTsansMedium.copyWith(
//         fontSize: Dimensions.h14,
//       ));
// }
