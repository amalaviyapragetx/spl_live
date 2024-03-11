import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/controller/home_controller.dart';
import 'package:spllive/controller/starline_market_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  final homeCon = Get.put<HomeController>(HomeController());
  final walletCon = Get.put<WalletController>(WalletController());
  final starlineCon = Get.put<StarlineMarketController>(StarlineMarketController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => homeCon.getDashBoardPages(homeCon.pageWidget.value ?? 0)),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: AppColors.bottomBarColor,
          showUnselectedLabels: true,
          unselectedItemColor: AppColors.black,
          elevation: 5,
          type: BottomNavigationBarType.fixed,
          currentIndex: homeCon.pageWidget.value,
          selectedItemColor: AppColors.appbarColor,
          selectedLabelStyle: CustomTextStyle.textPTsansMedium.copyWith(fontSize: 12),
          onTap: (v) {
            homeCon.pageWidget.value = v;
            if (homeCon.pageWidget.value == 2) {
              walletCon.selectedIndex.value = null;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                ConstantImage.homeIcon,
                height: 15,
                color: homeCon.pageWidget.value == 0 ? AppColors.appbarColor : AppColors.black,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                ConstantImage.bidHistoryListIcon,
                height: 15,
                color: homeCon.pageWidget.value == 1 ? AppColors.appbarColor : AppColors.black,
              ),
              label: "Bid History",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                ConstantImage.walletAppbar,
                height: 15,
                color: homeCon.pageWidget.value == 2 ? AppColors.appbarColor : AppColors.black,
              ),
              label: "Wallet",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                ConstantImage.passBookIcon,
                height: 15,
                color: homeCon.pageWidget.value == 3 ? AppColors.appbarColor : AppColors.black,
              ),
              label: "Passbook",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                ConstantImage.moreIcon,
                height: 15,
                color: homeCon.pageWidget.value == 4 ? AppColors.appbarColor : AppColors.black,
              ),
              label: "More",
            )
          ],
        ),
      ),
    );
  }
}
