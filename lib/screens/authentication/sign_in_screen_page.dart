import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/components/edit_text_field_with_icon.dart';
import 'package:spllive/components/password_field_with_icon.dart';
import 'package:spllive/components/simple_button_with_corner.dart';
import 'package:spllive/controller/auth_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/utils/constant.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final controller = Get.put<AuthController>(AuthController());
  @override
  void initState() {
    super.initState();
    GetStorage().write(ConstantsVariables.mPinTimeOut, true);
    controller.focusNodeSignIn = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.appbarColor),
        systemOverlayStyle: AppUtils.toolBarStyleDark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimensions.h20),
              SizedBox(height: Dimensions.h20),
              SizedBox(height: Dimensions.h20),
              SizedBox(
                height: Dimensions.h70,
                width: Dimensions.w150,
                child: Image.asset(
                  AppImage.splLogo,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: Dimensions.h20),
              Text(
                "WELCOMEBACK".tr,
                style: CustomTextStyle.textPTsansMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: Dimensions.h12,
                  letterSpacing: 1,
                  color: AppColors.black.withAlpha(200),
                ),
              ),
              Text(
                "SIGNIN".tr,
                style: CustomTextStyle.textRobotoSlabBold.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.h20,
                  letterSpacing: 1,
                  color: AppColors.appbarColor,
                ),
              ),
              SizedBox(height: Dimensions.h20),
              _buildSignInForm()
            ],
          ),
        ),
      ),
    );
  }

  _buildMobileNumberField() {
    return Row(
      children: [
        Expanded(
          child: RoundedCornerEditTextWithIcon(
            height: Dimensions.h40,
            controller: controller.mobileNumberController,
            keyboardType: TextInputType.phone,
            hintText: "ENTERMOBILENUMBER".tr,
            imagePath: AppImage.phoneSVG,
            autofocus: true,
            onChanged: (v) {
              if (v?.length == 10) {
                controller.focusNodeSignIn.nextFocus();
              }
            },
            hintTextStyle: CustomTextStyle.textRobotoSansLight.copyWith(
              color: AppColors.grey,
              fontSize: Dimensions.h14,
            ),
            textStyle: CustomTextStyle.textRobotoSansLight.copyWith(fontSize: Dimensions.h16),
            maxLines: 1,
            focusNode: controller.focusNodeSignIn,
            minLines: 1,
            isEnabled: true,
            maxLength: 10,
            formatter: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
      ],
    );
  }

  _buildSignInForm() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.h20),
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: _buildMobileNumberField()),
            SizedBox(height: Dimensions.h20),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: _buildPasswordField()),
            SizedBox(height: Dimensions.h20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.w15),
              child: RoundedCornerButton(
                text: "SIGNIN".tr,
                color: AppColors.appbarColor,
                borderColor: AppColors.appbarColor,
                fontSize: Dimensions.h12,
                fontWeight: FontWeight.w300,
                fontColor: AppColors.white,
                letterSpacing: 0,
                borderRadius: Dimensions.r25,
                borderWidth: 1,
                textStyle: CustomTextStyle.textRobotoSansLight,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.closeAllSnackbars();
                  if (controller.mobileNumberController.text.isEmpty) {
                    AppUtils.showErrorSnackBar(bodyText: "ENTERMOBILENUMBER".tr);
                  } else if (controller.mobileNumberController.text.length < 10) {
                    AppUtils.showErrorSnackBar(bodyText: "ENTERVALIDNUMBER".tr);
                  } else if (controller.passwordController.text.isEmpty) {
                    AppUtils.showErrorSnackBar(bodyText: "ENTERPASSWORD".tr);
                  } else {
                    controller.signIn();
                  }
                },
                height: Dimensions.h30,
                width: double.infinity,
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: orView()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.w15),
              child: RoundedCornerButton(
                text: "FORGOTPASS".tr,
                color: AppColors.white,
                borderColor: AppColors.appbarColor,
                fontSize: Dimensions.h12,
                fontWeight: FontWeight.w300,
                fontColor: AppColors.appbarColor,
                letterSpacing: 0,
                borderRadius: Dimensions.r25,
                borderWidth: 1,
                textStyle: CustomTextStyle.textRobotoSansLight,
                onTap: () => Get.toNamed(AppRouteNames.forgotPasswordPage),
                height: Dimensions.h30,
                width: double.infinity,
              ),
            ),
            // GestureDetector(
            //   onTap: () => Get.offAllNamed(AppRouteNames.signUnPage),
            //   child: Container(
            //     padding:
            //         const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            //     child: Text(
            //       "Don’t Have an Account? Register here.".tr,
            //       textAlign: TextAlign.center,
            //       style: CustomTextStyle.textRobotoSlabMedium.copyWith(
            //         fontSize: Dimensions.h12,
            //         letterSpacing: 1,
            //         height: 1.5,
            //         color: AppColors.black,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Row orView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: AppColors.greyShade.withOpacity(0.6),
            indent: Dimensions.w30,
            endIndent: Dimensions.w20,
            thickness: 2,
          ),
        ),
        Text(
          "OR",
          style: CustomTextStyle.textRobotoSlabMedium.copyWith(
              fontSize: Dimensions.h20, color: AppColors.greyShade.withOpacity(0.6), fontWeight: FontWeight.w300),
        ),
        Expanded(
          child: Divider(
            color: AppColors.greyShade.withOpacity(0.6),
            indent: Dimensions.w20,
            endIndent: Dimensions.w30,
            thickness: 2,
          ),
        ),
      ],
    );
  }

  _buildPasswordField() {
    return PasswordFieldWithIcon(
      //   focusNode: controller.focusNode2,
      height: Dimensions.h40,
      keyBoardType: TextInputType.visiblePassword,
      controller: controller.passwordController,
      hintText: "ENTERPASSWORDTEXT".tr,
      hidePassword: controller.visiblePassword.value,
      suffixIcon: InkWell(
        onTap: () => controller.visiblePassword.value = !controller.visiblePassword.value,
        child: Icon(
          Icons.visibility,
          size: Dimensions.h15,
          color: controller.visiblePassword.value ? AppColors.appbarColor : AppColors.grey,
        ),
      ),
      suffixIconColor: AppColors.appbarColor,
      imagePath: AppImage.lockSVG,
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: Text(
//               "LOGIN",
//               style: TextStyle(
//                   fontSize: 25,
//                   color: Color.fromARGB(255, 42, 90, 173),
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//           SizedBox(
//             height: 25,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 243, 240, 240),
//                     borderRadius: BorderRadius.circular(8.0)),
//                 child: DropdownButton<String>(
//                   icon: Icon(Icons.arrow_drop_down_outlined),
//                   elevation: 0,
//                   underline: Container(),
//                   dropdownColor: Color.fromARGB(255, 243, 240, 240),
//                   borderRadius: BorderRadius.circular(8.0),
//                   value: null,
//                   hint: Padding(
//                     padding: const EdgeInsets.fromLTRB(17, 0, 0, 0),
//                     child: Text(' +91'),
//                   ),
//                   onChanged: (value) {},
//                   items: [
//                     DropdownMenuItem<String>(
//                       value: 'Option 1',
//                       child: Text('Option 1'),
//                     ),
//                     DropdownMenuItem<String>(
//                       value: 'Option 2',
//                       child: Text('Option 2'),
//                     ),
//                     DropdownMenuItem<String>(
//                       value: 'Option 3',
//                       child: Text('Option 3'),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 50,
//                 width: 220,
//                 child: TextField(
//                   decoration: InputDecoration(
//                       fillColor: Color.fromARGB(255, 243, 240, 240),
//                       filled: true,
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                           borderSide: BorderSide.none),
//                       prefixIcon: Icon(
//                         Icons.phone,
//                         color:
//                             Color.fromARGB(255, 42, 90, 173).withOpacity(0.7),
//                       ),
//                       hintText: 'Enter Mobile Number',
//                       hintStyle: TextStyle(color: Colors.grey)),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 17,
//           ),
//           Container(
//             height: 55,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25),
//               child: TextField(
//                 decoration: InputDecoration(
//                     fillColor: Color.fromARGB(255, 243, 240, 240),
//                     filled: true,
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         borderSide: BorderSide.none),
//                     prefixIcon: Icon(
//                       Icons.lock,
//                       color: Color.fromARGB(255, 42, 90, 173).withOpacity(0.7),
//                     ),
//                     hintText: 'Enter Password',
//                     suffixIcon:
//                         Icon(Icons.remove_red_eye, color: Colors.blueGrey),
//                     hintStyle: TextStyle(color: Colors.grey)),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(225, 0, 0, 0),
//             child: Text(
//               "Forgot Password?",
//               style: TextStyle(
//                 color: Color.fromARGB(255, 42, 90, 173),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 17,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 35,
//             ),
//             child: InkWell(
//               onTap: () {},
//               child: Container(
//                 width: double.infinity,
//                 height: 45,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color.fromARGB(255, 42, 90, 173),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Login',
//                     style: TextStyle(
//                       fontSize: 17,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Text(
//             "Don't Have an Account? Register here.",
//             style: TextStyle(
//                 color: Color.fromARGB(255, 42, 90, 173), fontSize: 17),
//           ),
//         ],
//       ),
//     );
//   }
// }
