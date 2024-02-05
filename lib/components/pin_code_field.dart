import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/utils/constant.dart';

class CommonPinCodeField extends StatelessWidget {
  final String? title;
  final int? pinCodeLength;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;
  final bool? autoFocus;
  final FocusNode? focusNode;
  const CommonPinCodeField({
    super.key,
    this.title,
    this.pinCodeLength,
    this.onCompleted,
    this.onChanged,
    this.autoFocus,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.w18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "",
            textAlign: TextAlign.center,
            style: CustomTextStyle.textGothamBold.copyWith(
              fontWeight: FontWeight.normal,
              fontSize: Dimensions.sp15,
              letterSpacing: 1,
              color: AppColor.appbarColor,
            ),
          ),
          SizedBox(height: Dimensions.h10),
          PinCodeTextField(
            autoFocus: autoFocus ?? false,
            length: pinCodeLength ?? 0,
            appContext: context,
            obscureText: false,
            focusNode: focusNode,
            animationType: AnimationType.fade,
            keyboardType: TextInputType.number,
            enableActiveFill: true,
            cursorColor: AppColor.appbarColor,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            pinTheme: PinTheme(
              disabledColor: AppColor.transparent,
              activeFillColor: AppColor.transparent,
              inactiveFillColor: AppColor.transparent,
              selectedFillColor: AppColor.transparent,
              inactiveColor: AppColor.greyShade,
              activeColor: AppColor.greyShade,
              selectedColor: AppColor.appbarColor,
              errorBorderColor: AppColor.greyShade,
            ),
            textStyle: CustomTextStyle.textGothamBold.copyWith(color: AppColor.black, fontWeight: FontWeight.bold),
            animationDuration: const Duration(milliseconds: 200),
            onCompleted: onCompleted,
            onChanged: onChanged,
            beforeTextPaste: (text) => false,
          ),
        ],
      ),
    );
  }
}
