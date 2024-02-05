import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spllive/controller/auth_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/utils/constant.dart';

import '../../components/edit_text_field_with_icon.dart';
import '../../components/password_field_with_icon.dart';
import '../../components/simple_button_with_corner.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';

class UserDetailsPage extends StatelessWidget {
  UserDetailsPage({Key? key}) : super(key: key);

  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => onExitAlert(context, onCancel: () {
                Navigator.of(context).pop(false);
              }, onExit: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }),
            ) ??
            false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: Dimensions.h15, right: Dimensions.h15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Dimensions.h15),
                  SizedBox(height: Dimensions.h15),
                  SizedBox(height: Dimensions.h15),
                  SizedBox(height: Dimensions.h15),
                  SizedBox(height: Dimensions.h15),
                  SizedBox(height: Dimensions.h15),
                  SizedBox(height: Dimensions.h15),
                  Center(
                    child: SizedBox(
                      height: Dimensions.h70,
                      width: Dimensions.w150,
                      child: Image.asset(
                        AppImage.splLogo,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.h15),
                  Text(
                    "SIGN UP".tr,
                    style: CustomTextStyle.textRobotoSlabBold.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.h25,
                      letterSpacing: 1,
                      color: AppColors.appbarColor,
                    ),
                  ),
                  SizedBox(height: Dimensions.h15),
                  _buildNormalField(
                    hintText: "Enter Full Name".tr,
                    textController: controller.fullNameRes,
                    maxLength: 100,
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    formatter: [FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$'))],
                    //focusNode: controller.fullNameFocusNode,
                  ),
                  SizedBox(height: Dimensions.h15),
                  _buildNormalField(
                    hintText: "Enter User Name".tr,
                    textController: controller.userNameRes,
                    maxLength: 100,
                    keyboardType: TextInputType.text,
                    formatter: [FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9\s]+$'))],
                    //  focusNode: controller.userNameFocusNode,
                  ),
                  SizedBox(height: Dimensions.h15),
                  _buildPasswordField(
                    hintText: "Enter Password".tr,
                    textController: controller.passwordRes,
                    visibility: controller.pVisibility,
                  ),
                  SizedBox(height: Dimensions.h15),
                  _buildPasswordField(
                    hintText: "Enter Confirm Password".tr,
                    textController: controller.confirmPasswordRes,
                    visibility: controller.cpVisibility,
                  ),
                  SizedBox(height: Dimensions.h15),
                  _buildSignUpButtonRow(),
                  SizedBox(height: Dimensions.h15),
                  _buildCreateAccount(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AlertDialog onExitAlert(BuildContext context, {required Function() onExit, required Function() onCancel}) {
    return AlertDialog(
      title: Text(
        'Exit App',
        style: CustomTextStyle.textRobotoSansBold,
      ),
      content: Text('Are you sure you want to exit the app?', style: CustomTextStyle.textRobotoSansMedium),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: CustomTextStyle.textRobotoSansBold.copyWith(
              color: AppColors.appbarColor,
            ),
          ),
        ),
        TextButton(
          onPressed: onExit,
          child: Text(
            'Exit',
            style: CustomTextStyle.textRobotoSansBold.copyWith(
              color: AppColors.redColor,
            ),
          ),
        ),
      ],
    );
  }

  _buildNormalField({
    required String hintText,
    required TextEditingController textController,
    required int maxLength,
    required TextInputType keyboardType,
    List<TextInputFormatter>? formatter,
    bool? autofocus,
    FocusNode? focusNode,
  }) {
    return RoundedCornerEditTextWithIcon(
      height: Dimensions.h40,
      controller: textController,
      keyboardType: keyboardType,
      hintText: hintText,
      imagePath: AppImage.profileIconSVG,
      maxLines: 1,
      minLines: 1,
      isEnabled: true,
      maxLength: maxLength,
      formatter: formatter,
      focusNode: focusNode,
      autofocus: autofocus ?? false,
      hintTextStyle: CustomTextStyle.textRobotoSansLight.copyWith(
        color: AppColors.grey,
        fontSize: Dimensions.h14,
        // fontWeight: FontWeight.w500,
      ),
    );
  }

  _buildPasswordField({
    required String hintText,
    required TextEditingController textController,
    required RxBool visibility,
    FocusNode? focusNode,
    Function(String)? onChanged,
  }) {
    return Obx(() {
      return PasswordFieldWithIcon(
        focusNode: focusNode,
        onChanged: onChanged,
        height: Dimensions.h40,
        keyBoardType: TextInputType.visiblePassword,
        controller: textController,
        hintText: hintText,
        hidePassword: visibility.value,
        suffixIcon: InkWell(
          onTap: () => visibility.value = !visibility.value,
          child: Icon(
            Icons.visibility,
            size: Dimensions.h15,
            color: visibility.value ? AppColors.grey : AppColors.appbarColor,
          ),
        ),
        suffixIconColor: AppColors.appbarColor,
        imagePath: AppImage.lockSVG,
      );
    });
  }

  _buildSignUpButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RoundedCornerButton(
          height: Dimensions.h30,
          width: Dimensions.w300,
          letterSpacing: 1,
          color: AppColors.appbarColor,
          fontSize: Dimensions.h12,
          fontWeight: FontWeight.w500,
          // text: "SIGNUP".tr,
          text: "Register",
          textStyle: CustomTextStyle.textRobotoSansMedium,
          borderRadius: Dimensions.h25,
          borderColor: AppColors.appbarColor,
          borderWidth: 2,
          fontColor: AppColors.white,
          onTap: () => controller.onTapOfRegister(),
        ),
      ],
    );
  }

  _buildCreateAccount() {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.h15),
      child: GestureDetector(
        onTap: () => Get.offAllNamed(AppRouteNames.signInPage),
        child: Center(
          child: Text(
            "ACCOUNTLOGIN".tr,
            // "${"HAVEANACCOUNT".tr}? ${"LOGIN".tr} ${"HERE".tr}.",
            style: CustomTextStyle.textRobotoSansLight.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: Dimensions.h14,
              letterSpacing: 1,
              color: AppColors.appbarColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }
}
