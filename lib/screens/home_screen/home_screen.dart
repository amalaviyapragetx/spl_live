import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/screens/home_screen/utils/home_screen_utils.dart';
import '../../components/bottumnavigation/bottumnavigation.dart';
import 'controller/homepage_controller.dart';
import '../../helper_files/app_colors.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var controller = Get.put(HomePageController());
    var walletController = Get.put(WalletController());
    // print("${controller.getNotifiactionCount.value.toString()}");
    return WillPopScope(
      onWillPop: () async {
        if (controller.pageWidget.value == 1 ||
            controller.pageWidget.value == 2 ||
            controller.pageWidget.value == 3 ||
            controller.pageWidget.value == 4) {
          controller.pageWidget.value = 0;
          controller.currentIndex.value = 0;
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);
          return false;
        } else if (controller.pageWidget.value == 5) {
          controller.pageWidget.value = 4;
          controller.currentIndex.value = 4;
          return false;
        } else {
          if (controller.widgetContainer.value != 0) {
            controller.widgetContainer.value = 0;
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
                currentIndex: controller.currentIndex.value,
                onTapBidHistory: () {
                  controller.pageWidget.value = 1;
                  controller.currentIndex.value = 1;
                  controller.marketBidsByUserId(lazyLoad: false);
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.landscapeLeft
                  ]);
                  // controller.getUserBalance();
                },
                onTapHome: () {
                  controller.pageWidget.value = 0;
                  controller.currentIndex.value = 0;
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.landscapeLeft
                  ]);
                  // controller.getUserBalance();
                },
                onTapMore: () {
                  controller.pageWidget.value = 4;
                  controller.currentIndex.value = 4;
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.landscapeLeft
                  ]);
                  // controller.getUserBalance();
                },
                onTapWallet: () {
                  controller.pageWidget.value = 2;
                  controller.currentIndex.value = 2;
                  walletController.walletBalance.refresh();
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.landscapeLeft
                  ]);
                  controller.getUserBalance();
                },
                onTapPassbook: () {
                  controller.getPassBookData(
                      lazyLoad: false,
                      offset: controller.offset.value.toString());
                  controller.pageWidget.value = 3;
                  controller.currentIndex.value = 3;
                },
              ),
            ),
            backgroundColor: AppColors.white,
            body: RefreshIndicator(
              onRefresh: () async {
                if (controller.pageWidget.value == 0 ||
                    controller.pageWidget.value == 2) {
                  controller.handleRefresh();
                  walletController.walletBalance.refresh();
                }
              },
              child: Obx(
                () => controller.getDashBoardPages(
                  controller.pageWidget.value,
                  size,
                  context,
                  notifictionCount:
                      controller.getNotifiactionCount.value.toString(),
                ),
              ),
            ),
          ),
          Obx(
            () => controller.getNotifiactionCount.value > 0
                ? HomeScreenUtils().notificationAbout(
                    context,
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  AlertDialog onExitAlert(BuildContext context,
      {required Function() onExit, required Function() onCancel}) {
    return AlertDialog(
      title: Text(
        'Exit App',
        style: CustomTextStyle.textRobotoSansBold,
      ),
      content: Text('Are you sure you want to exit the app?',
          style: CustomTextStyle.textRobotoSansMedium),
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
