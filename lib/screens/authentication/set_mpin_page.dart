import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/components/pin_code_field.dart';
import 'package:spllive/components/simple_button_with_corner.dart';
import 'package:spllive/controller/auth_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/utils/constant.dart';

class SetMPINPage extends StatefulWidget {
  final UserDetails? userDetails;
  final bool? fromLogin;

  const SetMPINPage({super.key, this.userDetails, this.fromLogin});
  @override
  State<SetMPINPage> createState() => _SetMPINPageState();
}

class _SetMPINPageState extends State<SetMPINPage> {
  final controller = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    controller.getLocationsData(isLogin: widget.fromLogin, userDetail: widget.userDetails);
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

  _buildOtpAndMpinForm(context) {
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
          CommonPinCodeField(
            title: "MPIN".tr,
            pinCodeLength: 4,
            autoFocus: true,
            focusNode: controller.focusNodeMpin,
            onChanged: (v) {
              if (v.length == 4) {
                controller.focusNodeMpin.unfocus();
                controller.focusNodeSetMpin.requestFocus();
              }
            },
            onCompleted: (val) {
              controller.mpin.value = val;
              if (val.length == 4) {
                controller.focusNodeMpin.unfocus();
                controller.focusNodeSetMpin.requestFocus();
              }
            },
          ),

          SizedBox(height: Dimensions.h20),
          CommonPinCodeField(
            title: "REENTERMPIN".tr,
            pinCodeLength: 4,
            focusNode: controller.focusNodeSetMpin,
            onChanged: (v) {
              if (v.length == 4) {
                controller.onTapOfContinue();
              }
            },
            onCompleted: (val) {
              controller.confirmMpin.value = val;
              if (val.length == 4) {
                controller.onTapOfContinue();
              }
            },
          ),
          // _buildPinCodeField(
          //     context: context,
          //     title: "REENTERMPIN".tr,
          //     pinType: controller.confirmMpin,
          //     pinCodeLength: 4,
          //     focusNode: controller.focusNodeSetMpin,
          //     onChanged: (v) {
          //       if (v.length == 4) {
          //         controller.onTapOfContinue();
          //       }
          //     }),
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
        ],
      ),
    );
  }

  // _buildPinCodeField({
  //   required BuildContext context,
  //   required String title,
  //   required RxString pinType,
  //   required int pinCodeLength,
  //   FocusNode? focusNode,
  //   bool? autoFocus,
  //   required Function(String) onChanged,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         title,
  //         textAlign: TextAlign.center,
  //         style: CustomTextStyle.textRobotoSansMedium.copyWith(
  //           fontWeight: FontWeight.normal,
  //           fontSize: Dimensions.h15,
  //           letterSpacing: 1,
  //           color: AppColors.appbarColor,
  //         ),
  //       ),
  //       SizedBox(height: Dimensions.h10),
  //       // PinCodeFields(
  //       //   autofocus: autoFocus ?? false,
  //       //   length: pinCodeLength,
  //       //   obscureText: false,
  //       //   focusNode: focusNode,
  //       //   obscureCharacter: "",
  //       //   textStyle: CustomTextStyle.textRobotoSansMedium
  //       //       .copyWith(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 20),
  //       //   animationDuration: const Duration(milliseconds: 200),
  //       //   onComplete: (val) => pinType.value = val,
  //       //   keyboardType: TextInputType.number,
  //       //   animation: Animations.fade,
  //       //   activeBorderColor: AppColors.appbarColor,
  //       //   margin: const EdgeInsets.symmetric(horizontal: 20),
  //       //   onChange: (val) {
  //       //     pinType.value = val;
  //       //     onChanged(val);
  //       //   },
  //       //   enabled: true,
  //       //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //       //   responsive: true,
  //       // )
  //     ],
  //   );
  // }
}
