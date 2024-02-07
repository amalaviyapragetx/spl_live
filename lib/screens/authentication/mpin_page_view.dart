import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spllive/components/pin_code_field.dart';
import 'package:spllive/controller/auth_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/utils/constant.dart';

import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';

class MPINPageView extends StatefulWidget {
  int? id;
  MPINPageView({Key? key, this.id}) : super(key: key);

  @override
  State<MPINPageView> createState() => _MPINPageViewState();
}

class _MPINPageViewState extends State<MPINPageView> {
  final controller = Get.put<AuthController>(AuthController());
  @override
  void initState() {
    super.initState();
    controller.userId.value = "${widget.id ?? ""}";
    // controller.getLocationsDataMpin();
    controller.getPublicIpAddress();
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
            _buildOtpAndMpinForm(context),
          ],
        ),
      ),
    );
  }

  _buildOtpAndMpinForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.h20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          CommonPinCodeField(
            title: "MPIN".tr,
            pinCodeLength: 4,
            autoFocus: true,
            onCompleted: (val) {
              controller.verifyMpin.value = val;
              if (controller.verifyMpin.isEmpty || controller.verifyMpin.value.length < 4) {
                controller.mpinErrorController.add(ErrorAnimationType.shake);
              } else {
                controller.verifyMPIN();
              }
            },
          ),
          SizedBox(height: Dimensions.h20),
          Center(
            child: GestureDetector(
              onTap: () => controller.forgotMPI(),
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
        ],
      ),
    );
  }

  // _buildPinCodeField({
  //   required BuildContext context,
  //   required String title,
  //   required RxString pinType,
  //   required int pinCodeLength,
  // }) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: Dimensions.w18),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           title,
  //           textAlign: TextAlign.center,
  //           style: CustomTextStyle.textPTsansMedium.copyWith(
  //             fontWeight: FontWeight.bold,
  //             fontSize: Dimensions.h15,
  //             letterSpacing: 1,
  //             color: AppColors.black,
  //           ),
  //         ),
  //         PinCodeFields(
  //           autofocus: true,
  //           length: pinCodeLength,
  //           obscureText: false,
  //           obscureCharacter: "",
  //           textStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
  //             color: AppColors.black,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 20,
  //           ),
  //           animationDuration: const Duration(milliseconds: 200),
  //           onComplete: (val) {
  //             pinType.value = val;
  //             if (controller.verifyMpin.isEmpty || controller.verifyMpin.value.length < 4) {
  //               controller.mpinErrorController.add(ErrorAnimationType.shake);
  //             } else {
  //               controller.verifyMPIN();
  //             }
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
