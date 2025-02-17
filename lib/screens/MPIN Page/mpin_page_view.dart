import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_variables.dart';

import '../../helper_files/constant_image.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import 'controller/mpin_page_controller.dart';

class MPINPageView extends StatefulWidget {
  MPINPageView({Key? key}) : super(key: key);

  @override
  State<MPINPageView> createState() => _MPINPageViewState();
}

class _MPINPageViewState extends State<MPINPageView> {
  final controller = Get.find<MPINPageController>();
  @override
  void initState() {
    super.initState();
    GetStorage().write(ConstantsVariables.timeOut, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: _buildOtpAndMpinForm(context),
      ),
    );
  }

  _buildOtpAndMpinForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.h20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Get.height * 0.18),
          Center(
            child: SizedBox(
              height: Dimensions.h100,
              width: Dimensions.w150,
              child: Image.asset(
                ConstantImage.splLogo,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Center(
            child: Text(
              // "MPIN".tr,
              "ENTER MPIN",
              style: CustomTextStyle.textRobotoSlabBold.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.h25,
                letterSpacing: 1,
                color: AppColors.appbarColor,
              ),
            ),
          ),
          SizedBox(height: Dimensions.h20),
          Center(
            child: SizedBox(
              child: Icon(
                Icons.lock_open_rounded,
                size: 40,
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
          ),
          SizedBox(height: Dimensions.h20),
          Center(
            child: GestureDetector(
              onTap: () => controller.forgotMPINApi(),
              child: Text(
                "${"FORGOTYOURMPIN".tr} ?",
                textAlign: TextAlign.center,
                style: CustomTextStyle.textRobotoSansMedium.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: Dimensions.h13,
                  decoration: TextDecoration.underline,
                  letterSpacing: 1,
                  color: AppColors.appbarColor,
                ),
              ),
            ),
          ),
          SizedBox(height: Get.height * 0.3),
        ],
      ),
    );
  }

  _buildPinCodeField({
    required BuildContext context,
    required String title,
    required RxString pinType,
    required int pinCodeLength,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.w18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: CustomTextStyle.textPTsansMedium.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.h15,
              letterSpacing: 1,
              color: AppColors.black,
            ),
          ),
          // SizedBox(
          //   height: Dimensions.h10,
          // ),
          PinCodeFields(
            autofocus: true,
            length: pinCodeLength,
            obscureText: false,
            obscureCharacter: "",
            textStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            animationDuration: const Duration(milliseconds: 200),
            onComplete: (val) {
              pinType.value = val;
              controller.onCompleteMPIN();
            },
            keyboardType: TextInputType.number,
            animation: Animations.fade,
            activeBorderColor: AppColors.appbarColor,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            onChange: (val) {
              pinType.value = val;
            },
            enabled: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            responsive: true,
          ),
          // PinCodeTextField(
          //   length: pinCodeLength,
          //   appContext: context,
          //   obscureText: false,
          //   cursorColor: AppColors.black,
          //   autoFocus: true,
          //   animationType: AnimationType.fade,
          //   keyboardType: TextInputType.number,
          //   enableActiveFill: true,
          //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   pinTheme: PinTheme(
          //     shape: PinCodeFieldShape.box,
          //     activeFillColor: AppColors.grey.withOpacity(0.2),
          //     inactiveFillColor: AppColors.grey.withOpacity(0.2),
          //     selectedFillColor: AppColors.grey.withOpacity(0.2),
          //     inactiveColor: Colors.transparent,
          //     activeColor: Colors.transparent,
          //     selectedColor: Colors.transparent,
          //     errorBorderColor: Colors.transparent,
          //     fieldOuterPadding: EdgeInsets.only(right: Dimensions.h15),
          //     borderWidth: 0,
          //     borderRadius: BorderRadius.all(Radius.circular(Dimensions.r5)),
          //   ),
          //   // textStyle: CustomTextStyle.textGothamBold.copyWith(
          //   //     color: AppColors.splashScreenTextColor,
          //   //     fontWeight: FontWeight.bold),
          //   animationDuration: const Duration(milliseconds: 200),
          //   onCompleted: (val) {
          //     pinType.value = val;
          //     controller.onCompleteMPIN();
          //   },
          //   onChanged: (val) {
          //     pinType.value = val;
          //   },
          //   beforeTextPaste: (text) {
          //     return false;
          //   },
          // ),
        ],
      ),
    );
  }
}
