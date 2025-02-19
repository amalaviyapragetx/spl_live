import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../components/simple_button_with_corner.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import 'controller/give_feedback_page_controller.dart';

class GiveFeedbackPage extends StatelessWidget {
  GiveFeedbackPage({Key? key}) : super(key: key);

  final controller = Get.find<GiveFeedbackPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppUtils().simpleAppbar(
        appBarTitle: "GIVEFEEDBACK".tr,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "FEEDBACK".tr,
                  style:
                      CustomTextStyle.textRobotoMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.h14),
                ),
                SizedBox(height: Dimensions.h10),
                RoundedCornerEditText2(
                  isEnabled: true,
                  controller: controller.feedbackController,
                  maxLines: 10,
                  minLines: 10,
                  hintText: "",
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 20),
                Center(
                  child: controller.isGiveFeedback == false
                      ? RoundedCornerButton(
                          height: Dimensions.h30,
                          width: Dimensions.w130,
                          letterSpacing: 0,
                          color: AppColors.appbarColor,
                          fontSize: Dimensions.h14,
                          fontWeight: FontWeight.bold,
                          text: "SUBMIT".tr,
                          textStyle: CustomTextStyle.textRobotoMedium,
                          borderRadius: Dimensions.r5,
                          borderColor: AppColors.appbarColor,
                          borderWidth: 1,
                          fontColor: AppColors.white,
                          onTap: () {
                            if (controller.feedbackController.text.trim().isNotEmpty) {
                              controller.addFeedbackApi(5);
                            } else {
                              AppUtils.showErrorSnackBar(bodyText: "You can't submit empty Feedback");
                            }
                          },
                        )
                      : CircularProgressIndicator(
                          color: AppColors.appBlueColor,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedCornerEditText2 extends StatelessWidget {
  RoundedCornerEditText2(
      {Key? key,
      required this.controller,
      required this.maxLines,
      required this.minLines,
      required this.hintText,
      this.isEnabled = true,
      required this.keyboardType,
      this.validateValue,
      this.maxLength})
      : super(key: key);

  final TextEditingController controller;
  int? maxLength;
  int? maxLines;
  int? minLines;
  String hintText;
  bool isEnabled;
  TextInputType keyboardType;
  Function(bool, String)? validateValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      enabled: isEnabled,
      controller: controller,
      validator: (value) {
        validateValue!(false, value.toString());
        return null;
      },
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s+'), replacementString: " "),
      ],
      cursorColor: AppColors.appbarColor,
      style: CustomTextStyle.textPTsansMedium
          .copyWith(color: AppColors.black, fontWeight: FontWeight.normal, fontSize: Dimensions.h16),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(Dimensions.h10),
        focusColor: AppColors.black,
        filled: true,
        fillColor: AppColors.grey.withOpacity(0.2),
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        counterText: "",
        border: InputBorder.none,
        errorMaxLines: 4,
        hintText: hintText,
        hintStyle: CustomTextStyle.textPTsansBold.copyWith(
          color: AppColors.grey,
          fontSize: Dimensions.h15,
        ),
      ),
    );
  }
}
