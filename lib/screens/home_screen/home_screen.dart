import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
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

    // var spaceBeetween = const SizedBox(height: 10);

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
          return await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => onExitAlert(context, onCancel: () {
                  Navigator.of(context).pop(false);
                }, onExit: () {
                  // Navigator.of(context).pop(true);
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                }),
              ) ??
              false;
        }
      },
      child: Scaffold(
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
            },
            onTapHome: () {
              controller.pageWidget.value = 0;
              controller.currentIndex.value = 0;
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.landscapeLeft
              ]);
            },
            onTapMore: () {
              controller.pageWidget.value = 4;
              controller.currentIndex.value = 4;
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.landscapeLeft
              ]);
            },
            onTapWallet: () {
              controller.pageWidget.value = 2;
              controller.currentIndex.value = 2;
              walletController.walletBalance.refresh();
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.landscapeLeft
              ]);
            },
            onTapPassbook: () {
              controller.getPassBookData(
                  lazyLoad: false, offset: controller.offset.value.toString());
              controller.pageWidget.value = 3;
              controller.currentIndex.value = 3;
            },
          ),
        ),
        backgroundColor: AppColors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            controller.handleRefresh();
          },
          child: Obx(
            () => controller.getDashBoardPages(
              controller.pageWidget.value,
              size,
              context,
              walletController.walletBalance.value.toString(),
            ),
          ),
        ),
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
