import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper_files/ui_utils.dart';
import '../home_screen/controller/homepage_controller.dart';
import 'controller/bottum_navigation_controller.dart';

class MoreOptions extends StatelessWidget {
  MoreOptions({super.key});
  var controller = Get.put(MoreListController());
  var homeController = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppUtils().simpleAppbar(
            appBarTitle: "",
            leadingWidht: Dimensions.w200,
            leading: Row(
              children: [
                SizedBox(width: Dimensions.w15),
                Text(
                  "MORE".tr,
                  style: CustomTextStyle.textRobotoSansMedium.copyWith(fontSize: Dimensions.h20),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
                child: InkWell(
                  onTap: () => controller.toggleShare(),
                  child: Container(
                    width: Dimensions.w20,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      Icons.share,
                      size: 13,
                      color: AppColors.appbarColor,
                    ),
                  ),
                ),
              ),
            ]),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(height: Dimensions.h15),
                listItems(
                    onTap: () => Get.toNamed(AppRouteNames.profilePage),
                    iconData: AppImage.profileIconSVG,
                    text: "MYPROFILE".tr),
                listItems(
                    onTap: () => Get.toNamed(AppRouteNames.myAccountPage),
                    iconData: AppImage.bakAccount,
                    text: "MYACCOUNT".tr),
                listItems(
                    onTap: () => Get.toNamed(AppRouteNames.gameRatePage),
                    iconData: AppImage.gameRate,
                    text: "GAMERATE".tr),
                listItems(
                    onTap: () => Get.toNamed(AppRouteNames.notificationDetailsPage),
                    iconData: AppImage.notifiacation,
                    text: "NOTIFICATIONS".tr),
                listItems(
                    onTap: () => launch("https://wa.me/+917769826748/?text=hi"),
                    iconData: AppImage.plusIcon,
                    text: "ADDFUND".tr),
                listItems(
                    onTap: () {
                      // homeController.pageWidget.value = 1;
                      // homeController.currentIndex.value = 1;
                    },
                    iconData: AppImage.clockIcon,
                    text: "BIDDINGHISTORY".tr),
                listItems(
                    onTap: () {
                      GetStorage().write(ConstantsVariables.withDrawal, true);
                      // homeController.pageWidget.value = 5;
                      // homeController.currentIndex.value = 5;
                    },
                    iconData: AppImage.withDrawalIcon,
                    text: "WITHDRAWAL_TXT1".tr),
                listItems(
                    onTap: () => Get.toNamed(AppRouteNames.feedBackPage),
                    iconData: AppImage.giveFeedbackIcon,
                    text: "GIVEFEEDBACK".tr),
                listItems(
                  onTap: () => controller.onTapOfRateUs(),
                  iconData: AppImage.rateusStartIcon,
                  text: "RATEUS".tr,
                ),
                listItems(
                  onTap: () => Get.toNamed(AppRouteNames.aboutPage),
                  iconData: AppImage.infoIcon,
                  text: "ABOUTUS".tr,
                ),
                listItems(
                  onTap: () => controller.callLogout(),
                  iconData: AppImage.signOutIcon,
                  text: "SIGNOUT".tr,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

Widget listItems({required Function() onTap, required String iconData, required String text}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        SizedBox(
          height: Dimensions.h30,
          child: Row(
            children: [
              SizedBox(
                width: Dimensions.w20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: SizedBox(
                  // color: Colors.amber,
                  height: Dimensions.h20,
                  width: Dimensions.w20,
                  child: SvgPicture.asset(
                    iconData,
                    color: AppColors.appbarColor,
                  ),
                ),
              ),
              SizedBox(
                width: Dimensions.w15,
              ),
              Text(text,
                  style:
                      CustomTextStyle.textPTsansMedium.copyWith(fontSize: Dimensions.h14, fontWeight: FontWeight.w500))
            ],
          ),
        ),
        Divider(
          color: AppColors.grey,
          endIndent: 10,
          indent: 50,
        )
      ],
    ),
  );
}
