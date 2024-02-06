import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/controller/home_controller.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/screens/home_screen/utils/home_screen_utils.dart';

import '../../components/bottumnavigation/bottumnavigation.dart';
import '../../helper_files/app_colors.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});
  @override
  Widget build(BuildContext context) {
    // var controller = Get.put(HomePageController());
    var walletController = Get.put(WalletController());
    final homeCon = Get.put(HomeController());
    return WillPopScope(
      onWillPop: () async {
        if (homeCon.pageWidget.value == 1 ||
            homeCon.pageWidget.value == 2 ||
            homeCon.pageWidget.value == 3 ||
            homeCon.pageWidget.value == 4) {
          homeCon.pageWidget.value = 0;
          homeCon.currentIndex.value = 0;
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);
          return false;
        } else if (homeCon.pageWidget.value == 5) {
          homeCon.pageWidget.value = 4;
          homeCon.currentIndex.value = 4;
          return false;
        } else {
          if (homeCon.widgetContainer.value != 0) {
            homeCon.widgetContainer.value = 0;
            return false;
          } else {
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
          }
        }
      },
      child: Stack(
        children: [
          Scaffold(
            bottomNavigationBar: Obx(
              () => MyNavigationBar(
                currentIndex: homeCon.currentIndex.value,
                onTapBidHistory: () {
                  homeCon.pageWidget.value = 1;
                  homeCon.currentIndex.value = 1;
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);
                  // controller.getUserBalance();
                },
                onTapHome: () {
                  homeCon.pageWidget.value = 0;
                  homeCon.currentIndex.value = 0;
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);
                  // controller.getUserBalance();
                },
                onTapMore: () {
                  homeCon.pageWidget.value = 4;
                  homeCon.currentIndex.value = 4;
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);
                  // controller.getUserBalance();
                },
                onTapWallet: () {
                  homeCon.pageWidget.value = 2;
                  homeCon.currentIndex.value = 2;
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);
                  walletController.walletBalance.refresh();
                  homeCon.getBannerData();
                  walletController.walletBalance.refresh();
                },
                onTapPassbook: () {
                  homeCon.pageWidget.value = 3;
                  homeCon.currentIndex.value = 3;
                },
              ),
            ),
            backgroundColor: AppColors.white,
            body: RefreshIndicator(
              onRefresh: () async {
                if (homeCon.pageWidget.value == 0 || homeCon.pageWidget.value == 2) {
                  // controller.handleRefresh();
                  homeCon.walletBalance.refresh();
                }
              },
              child: Obx(
                () => homeCon.getDashBoardPages(
                  homeCon.pageWidget.value,
                  context,
                  notificationCount: homeCon.getNotificationCount.value.toString(),
                ),
              ),
            ),
          ),
          Obx(
            () => homeCon.getNotificationCount.value > 0 ? HomeScreenUtils().notificationAbout(context) : Container(),
          )
        ],
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
}
