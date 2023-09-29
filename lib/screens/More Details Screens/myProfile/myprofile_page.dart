import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/routes/app_routes_name.dart';
import 'package:spllive/screens/More%20Details%20Screens/myProfile/controller/myprofile_page_controller.dart';
import 'package:spllive/screens/home_screen/controller/homepage_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  String gender = '';
  var controller = Get.put(MyProfilePageController());
  var homeController = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppUtils().simpleAppbar(appBarTitle: "Profile"),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.h15),
        child: Column(
          children: [
            SizedBox(
              height: Dimensions.h15,
            ),
            // Container(
            //   height: Dimensions.h100,
            //   width: size.width,
            //   decoration: BoxDecoration(
            //     color: AppColors.white,
            //     boxShadow: [
            //       BoxShadow(
            //         spreadRadius: 1,
            //         blurRadius: 4,
            //         color: AppColors.grey.withOpacity(0.5),
            //         offset: const Offset(0, 0),
            //       )
            //     ],
            //     borderRadius: BorderRadius.circular(Dimensions.r4),
            //   ),
            //   child: Row(
            //     children: [],
            //   ),
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Dimensions.h15,
                ),
                SizedBox(
                  height: Dimensions.h50,
                  width: Dimensions.w100,
                  child: Image.asset(
                    ConstantImage.splLogo,
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  // "\nJevin \n8780339513 \n8780339513",
                  "\n    User Name   :   ${homeController.userData.userName ?? ""}\n    Mobile No     :   ${homeController.userData.phoneNumber ?? ""} \n",
                  // style: TextStyle(fontSize: 17, color: AppColors.black),\
                  textAlign: TextAlign.start,
                  style: CustomTextStyle.textRobotoSansMedium.copyWith(
                    fontSize: Dimensions.h15,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            cardListwidget("CHANGEPASSWORD2".tr, onTap: () {
              Get.toNamed(AppRoutName.changePassPage);
            }),
            cardListwidget("CHANGEMOBILENUMBER".tr, onTap: () {
              Get.toNamed(AppRoutName.changeMpinPage);
            }),
            const SizedBox(
              height: 10,
            ),
            // Row(
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.only(left: Dimensions.w40),
            //       child: Text(
            //         "LOGINAS".tr,
            //         style: CustomTextStyle.textPTsansBold.copyWith(
            //           color: AppColors.black,
            //           fontSize: Dimensions.h20,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // RadioListTile(
            //   title: Text(
            //     'DIRECTLOGIN'.tr,
            //     style: CustomTextStyle.textPTsansMedium.copyWith(
            //       color: AppColors.black,
            //       fontSize: Dimensions.h15,
            //     ),
            //   ),
            //   value: false,
            //   activeColor: AppColors.appbarColor,
            //   groupValue: controller.value.value,
            //   onChanged: (value) {
            //     controller.toggleValue(value!);
            //   },
            //   controlAffinity: ListTileControlAffinity.trailing,
            // ),
            // Divider(
            //   color: AppColors.grey,
            //   thickness: 0.3,
            //   indent: 20,
            //   height: 0.1,
            //   endIndent: 15,
            // ),
            // RadioListTile(
            //   title: Text(
            //     'MOBILEPINLOGIN'.tr,
            //     style: CustomTextStyle.textPTsansMedium.copyWith(
            //       color: AppColors.black,
            //       fontSize: Dimensions.h15,
            //     ),
            //   ),
            //   value: true,
            //   activeColor: AppColors.appbarColor,
            //   groupValue: controller.value.value,
            //   onChanged: (value) {
            //     controller.toggleValue(value!);
            //   },
            //   controlAffinity: ListTileControlAffinity.trailing,
            // ),
            // Divider(
            //   color: AppColors.grey,
            //   thickness: 0.3,
            //   height: 0.1,
            //   indent: 20,
            //   endIndent: 15,
            // ),
          ],
        ),
      ),
    );
  }

  Card cardListwidget(String text, {required Function() onTap}) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: SizedBox(
        height: Dimensions.h50,
        child: ListTile(
          onTap: onTap,
          leading: Icon(Icons.lock_outline, color: AppColors.blueAccent),
          title: Text(
            text,
            // "Change Password",
            style: CustomTextStyle.textPTsansMedium.copyWith(
              color: AppColors.black,
              fontSize: Dimensions.h16,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
          ),
        ),
      ),
    );
  }
}
