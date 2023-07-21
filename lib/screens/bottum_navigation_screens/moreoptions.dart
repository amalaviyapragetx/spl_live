import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/routes/app_routes_name.dart';
import '../../helper_files/constant_image.dart';
import '../../helper_files/ui_utils.dart';
import 'controller/bottum_navigation_controller.dart';

class MoreOptions extends StatelessWidget {
  const MoreOptions({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var controller = Get.put(MoreListController());
    // ignore: sized_box_for_whitespace
    return Column(
      children: [
        AppUtils().simpleAppbar(appBarTitle: "More", actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: InkWell(
              onTap: () {
                Share.share("http://spl.live");
              },
              child: Container(
                width: 25,
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: Icon(
                  Icons.share,
                  size: 15,
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
                SizedBox(
                  height: Dimensions.h15,
                ),
                listItems(
                    onTap: () => Get.toNamed(AppRoutName.profilePage),
                    iconData: ConstantImage.profileIconSVG,
                    text: "My Profile"),
                listItems(
                    onTap: () {
                      Get.toNamed(AppRoutName.myAccountPage);
                    },
                    iconData: ConstantImage.bakAccount,
                    text: "My Account"),
                listItems(
                    onTap: () {
                      Get.toNamed(AppRoutName.gameRatePage);
                    },
                    iconData: ConstantImage.gameRate,
                    text: "Game rate"),
                listItems(
                    onTap: () {
                      Get.toNamed(AppRoutName.notificationDetailsPage);
                    },
                    iconData: ConstantImage.notifiacation,
                    text: "Notifications"),
                listItems(
                    onTap: () {},
                    iconData: ConstantImage.playIcon,
                    text: "How to Play"),
                listItems(
                    onTap: () {},
                    iconData: ConstantImage.plusIcon,
                    text: "Add Fund"),
                listItems(
                    onTap: () {},
                    iconData: ConstantImage.clockIcon,
                    text: "Binding History"),
                listItems(
                    onTap: () {
                      Get.toNamed(AppRoutName.withdrawalpage);
                    },
                    iconData: ConstantImage.withDrawalIcon,
                    text: "WithDrawal"),
                listItems(
                    onTap: () {
                      Get.toNamed(AppRoutName.transactionPage);
                    },
                    iconData: ConstantImage.addFundIcon,
                    text: "Transaction History"),
                listItems(
                    onTap: () {
                      Get.toNamed(AppRoutName.feedBackPage);
                    },
                    iconData: ConstantImage.giveFeedbackIcon,
                    text: "Give Feedback"),
                listItems(
                  onTap: () {
                    controller.onTapOfRateUs();
                  },
                  iconData: ConstantImage.rateusStartIcon,
                  text: "Rate Us",
                ),
                listItems(
                  onTap: () {
                    Get.toNamed(AppRoutName.stalineTerms);
                  },
                  iconData: ConstantImage.addFundIcon,
                  text: "Starline Terms & Condition",
                ),
                listItems(
                  onTap: () {
                    Get.toNamed(AppRoutName.aboutPage);
                  },
                  iconData: ConstantImage.infoIcon,
                  text: "About Us",
                ),
                listItems(
                  onTap: () {
                    controller.callLogout();
                  },
                  iconData: ConstantImage.signOutIcon,
                  text: "Sign out",
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

Widget listItems(
    {required Function() onTap,
    required String iconData,
    required String text}) {
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
                  style: CustomTextStyle.textPTsansMedium.copyWith(
                      fontSize: Dimensions.h14, fontWeight: FontWeight.w500))
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
