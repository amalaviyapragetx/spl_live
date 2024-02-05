import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/components/pin_code_field.dart';
import 'package:spllive/controller/auth_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/utils/constant.dart';

import '../../components/simple_button_with_corner.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';

class VerifyOTPPage extends StatefulWidget {
  final String? countryCode;
  final String? phoneCon;
  const VerifyOTPPage({super.key, this.countryCode, this.phoneCon});

  @override
  State<VerifyOTPPage> createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends State<VerifyOTPPage> {
  final controller = Get.put<AuthController>(AuthController());
  @override
  void initState() {
    super.initState();
    controller.phoneNumberOtp = widget.phoneCon ?? "";
    controller.countryCodeOtp = widget.countryCode ?? "";
    controller.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: Dimensions.h100,
                width: Dimensions.w150,
                child: Image.asset(
                  AppImage.splLogo,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(
              "ENTEROTP".tr,
              style: CustomTextStyle.textRobotoSlabBold.copyWith(
                fontSize: Dimensions.h20,
                letterSpacing: 1,
                color: AppColors.appbarColor,
              ),
            ),
            _buildOtpAndMpinForm(context),
          ],
        ),
      ),
    );
  }

  _buildOtpAndMpinForm(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonPinCodeField(
          title: "OTP",
          pinCodeLength: 6,
          autoFocus: true,
          onChanged: (v) {
            if (v.length == 6) {
              controller.phoneNumberOtp != "" && controller.countryCodeOtp != ""
                  ? controller.verifyUser()
                  : controller.verifyOTP();
            }
          },
          onCompleted: (val) {
            controller.otp.value = val;
            if (val.length == 6) {
              controller.phoneNumberOtp != "" && controller.countryCodeOtp != ""
                  ? controller.verifyUser()
                  : controller.verifyOTP();
            }
          },
        ),

        // _buildPinCodeField(
        //   onChange: (v) {
        //     controller.onTapOfContinue();
        //   },
        //   context: context,
        //   title: "OTP",
        //   pinType: controller.otp,
        //   pinCodeLength: 6,
        // ),
        SizedBox(height: Dimensions.h20),
        Obx(
          () => Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.h12),
              child: GestureDetector(
                onTap: () => controller.secondsRemaining.value == 0 ? controller.resendOtpApi() : null,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "DIDOTP".tr,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.appbarColor,
                      fontWeight: FontWeight.normal,
                      fontSize: Dimensions.h14,
                    ),
                    children: [
                      controller.formattedTime.toString() != "0:00"
                          ? TextSpan(
                              text: controller.formattedTime.toString(),
                              style: CustomTextStyle.textRobotoSansLight.copyWith(
                                color: AppColors.appbarColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.normal,
                                fontSize: Dimensions.h14,
                              ),
                            )
                          : TextSpan(
                              text: "RESENDOTP".tr,
                              style: CustomTextStyle.textRobotoSansLight.copyWith(
                                color: AppColors.appbarColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.normal,
                                fontSize: Dimensions.h14,
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: Dimensions.h20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.w18),
          child: RoundedCornerButton(
            text: "CONTINUE".tr,
            color: AppColors.appbarColor,
            borderColor: AppColors.appbarColor,
            fontSize: Dimensions.h12,
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
        ),
      ],
    );
  }

  // _buildPinCodeField({
  //   required BuildContext context,
  //   required String title,
  //   required RxString pinType,
  //   required int pinCodeLength,
  //   required onChange,
  // }) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: Dimensions.w18),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           title,
  //           textAlign: TextAlign.center,
  //           style: CustomTextStyle.textRobotoSansMedium.copyWith(
  //             fontWeight: FontWeight.normal,
  //             fontSize: Dimensions.h15,
  //             letterSpacing: 1,
  //             color: AppColors.black,
  //           ),
  //         ),
  //         SizedBox(height: Dimensions.h10),
  //         CommonPinCodeField(
  //           title: title,
  //           pinCodeLength: pinCodeLength,
  //           autoFocus: true,
  //           onChanged: (val) => pinType.value = val,
  //           onCompleted: (val) {
  //             pinType.value = val;
  //             onChange(val);
  //           },
  //         ),
  //         PinCodeFields(
  //           autofocus: true,
  //           length: pinCodeLength,
  //           obscureText: false,
  //           obscureCharacter: "",
  //           textStyle: CustomTextStyle.textRobotoSansMedium
  //               .copyWith(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 20),
  //           animationDuration: const Duration(milliseconds: 200),
  //           onComplete: (val) {
  //             pinType.value = val;
  //             onChange(val);
  //           },
  //           keyboardType: TextInputType.number,
  //           animation: Animations.fade,
  //           activeBorderColor: AppColors.appbarColor,
  //           margin: const EdgeInsets.symmetric(horizontal: 20),
  //           onChange: (val) {
  //             pinType.value = val;
  //           },
  //           enabled: true,
  //           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //           responsive: true,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
