import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:get/get.dart';

import '../../components/simple_button_with_corner.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/constant_image.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import 'controller/set_mpin_page_controller.dart';

class SetMPINPage extends StatefulWidget {
  SetMPINPage({Key? key}) : super(key: key);

  @override
  State<SetMPINPage> createState() => _SetMPINPageState();
}

class _SetMPINPageState extends State<SetMPINPage> {
  final controller = Get.find<SetMPINPageController>();
  @override
  void initState() {
    controller.getPublicIpAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildOtpAndMpinForm(context),
    );
  }

  _buildOtpAndMpinForm(context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.h20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            // SizedBox(height: Get.height * 0.1),
            Center(
              child: SizedBox(
                height: Dimensions.h70,
                width: Dimensions.w150,
                child: Image.asset(
                  ConstantImage.splLogo,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Center(
              child: Text(
                // "SET MPIN",
                "SETMPIN".tr,
                style: CustomTextStyle.textRobotoSlabBold.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.h25,
                  letterSpacing: 1,
                  color: AppColors.appbarColor,
                ),
              ),
            ),
            SizedBox(height: Dimensions.h20),
            _buildPinCodeField(
                context: context,
                title: "MPIN".tr,
                pinType: controller.mpin,
                pinCodeLength: 4,
                focusNode: controller.focusNode1,
                onChanged: (v) {
                  if (controller.mpin.value.length == 4) {
                    controller.focusNode1.unfocus();
                    controller.focusNode2.requestFocus();
                  }
                }),
            SizedBox(height: Dimensions.h20),
            _buildPinCodeField(
                context: context,
                title: "REENTERMPIN".tr,
                pinType: controller.confirmMpin,
                pinCodeLength: 4,
                focusNode: controller.focusNode2,
                onChanged: (v) {
                  if (v.length == 4) {
                    controller.onTapOfContinue();
                  }
                }),
            SizedBox(height: Dimensions.h20),
            RoundedCornerButton(
              text: "CONTINUE".tr,
              color: AppColors.appbarColor,
              borderColor: AppColors.appbarColor,
              fontSize: Dimensions.h13,
              fontWeight: FontWeight.w500,
              fontColor: AppColors.white,
              letterSpacing: 1,
              borderRadius: Dimensions.r9,
              borderWidth: 1,
              textStyle: CustomTextStyle.textRobotoSansMedium,
              onTap: () => controller.onTapOfContinue(),
              height: Dimensions.h30,
              width: double.infinity,
            ),
            SizedBox(height: Get.height * 0.4),
          ],
        ),
      ),
    );
  }

  _buildPinCodeField({
    required BuildContext context,
    required String title,
    required RxString pinType,
    required int pinCodeLength,
    FocusNode? focusNode,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: CustomTextStyle.textRobotoSansMedium.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: Dimensions.h15,
            letterSpacing: 1,
            color: AppColors.appbarColor,
          ),
        ),
        SizedBox(height: Dimensions.h10),
        PinCodeFields(
          autofocus: true,
          length: pinCodeLength,
          obscureText: false,
          focusNode: focusNode,
          obscureCharacter: "",
          textStyle: CustomTextStyle.textRobotoSansMedium
              .copyWith(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 20),
          animationDuration: const Duration(milliseconds: 200),
          onComplete: (val) {
            pinType.value = val;
          },
          keyboardType: TextInputType.number,
          animation: Animations.fade,
          activeBorderColor: AppColors.appbarColor,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          onChange: (val) {
            pinType.value = val;
            onChanged(val);
          },
          enabled: true,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          responsive: true,
        )
        // PinCodeTextField(
        //   length: pinCodeLength,
        //   appContext: context,
        //   obscureText: false,
        //   autoFocus: true,
        //   focusNode: focusNode,
        //   animationType: AnimationType.fade,
        //   keyboardType: TextInputType.number,
        //   enableActiveFill: true,
        //   cursorColor: AppColors.black,
        //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   // pinTheme: PinTheme.defaults(shape: PinCodeFieldShape.underline  ),
        //   // enablePinAutofill: false,
        //   // pinTheme: PinTheme(
        //   //   shape: PinCodeFieldShape.box,
        //   //   activeFillColor: AppColors.grey.withOpacity(0.2),
        //   //   inactiveFillColor: AppColors.grey.withOpacity(0.2),
        //   //   selectedFillColor: AppColors.grey.withOpacity(0.2),
        //   //   inactiveColor: Colors.transparent,
        //   //   activeColor: Colors.transparent,
        //   //   selectedColor: Colors.transparent,
        //   //   errorBorderColor: Colors.transparent,
        //   //   fieldOuterPadding: EdgeInsets.only(right: Dimensions.h15),
        //   //   borderRadius: BorderRadius.all(
        //   //     Radius.circular(Dimensions.r5),
        //   //   ),
        //   //   borderWidth: 0,
        //   //   activeBorderWidth: 0,
        //   //   inactiveBorderWidth: 0,
        //   //   disabledBorderWidth: 0,
        //   //   errorBorderWidth: 0,
        //   //   selectedBorderWidth: 0,
        //   // ),
        //   pinTheme: PinTheme(
        //     shape: PinCodeFieldShape.box,
        //     activeFillColor: AppColors.grey.withOpacity(0.2),
        //     inactiveFillColor: AppColors.grey.withOpacity(0.2),
        //     selectedFillColor: AppColors.grey.withOpacity(0.2),
        //     borderWidth: 0,
        //   ),

        //   textStyle: CustomTextStyle.textRobotoSansMedium
        //       .copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
        //   animationDuration: const Duration(milliseconds: 200),

        //   onCompleted: (val) {
        //     pinType.value = val;
        //   },
        //   onChanged: (val) {
        //     pinType.value = val;
        //     onChanged(val);
        //   },
        //   beforeTextPaste: (text) {
        //     return false;
        //   },
        // ),
      ],
    );
  }
}
