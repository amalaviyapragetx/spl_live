import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/controller/home_controller.dart';
import 'package:spllive/controller/passbook_controller.dart';
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
  final passbookCon = Get.put<PassbookHistoryController>(PassbookHistoryController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        if (homeCon.pageWidget.value == 1 ||
            homeCon.pageWidget.value == 2 ||
            homeCon.pageWidget.value == 3 ||
            homeCon.pageWidget.value == 4) {
          print("OR VALUE: ${homeCon.pageWidget.value}");
          if (walletCon.selectedIndex.value != null) {
            walletCon.selectedIndex.value = null;
            print("OR VALUE: 1");
          } else {
            homeCon.pageWidget.value = 0;
            homeCon.currentIndex.value = 0;
            print("OR VALUE: 111");
          }
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);
        } else if (homeCon.pageWidget.value == 5) {
          homeCon.pageWidget.value = 4;
          homeCon.currentIndex.value = 4;
          print("OR VALUE: 122");
        } else {
          // await Get.dialog(
          //   barrierDismissible: false,
          //   ConstrainedBox(
          //     constraints: BoxConstraints(maxHeight: Get.width, minWidth: Get.width - 30),
          //     child: AlertDialog(
          //       insetPadding: EdgeInsets.all(10),
          //       contentPadding: const EdgeInsets.symmetric(horizontal: 55, vertical: 20),
          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          //       content: SizedBox(
          //         width: double.infinity,
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Text(
          //               'Exit App',
          //               style: CustomTextStyle.textRobotoSansMedium.copyWith(
          //                 color: AppColors.appbarColor,
          //                 fontWeight: FontWeight.w700,
          //                 fontSize: 20,
          //               ),
          //             ),
          //             Text(
          //               'Are you sure you want to exit the app?',
          //               textAlign: TextAlign.center,
          //               style: CustomTextStyle.textRobotoSansMedium.copyWith(
          //                 fontSize: Dimensions.h15,
          //               ),
          //             ),
          //             const SizedBox(height: 10),
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.end,
          //               children: [
          //                 InkWell(
          //                   onTap: () => Get.back(),
          //                   child: Center(
          //                     child: Text(
          //                       'Cancel',
          //                       style: CustomTextStyle.textRobotoSansBold.copyWith(
          //                         color: AppColors.appbarColor,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(width: 10),
          //                 InkWell(
          //                   onTap: () => Navigator.of(context).pop(false),
          //                   child: Center(
          //                     child: Text(
          //                       'Exit',
          //                       style: CustomTextStyle.textRobotoSansBold.copyWith(
          //                         color: AppColors.redColor,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          print("OR VALUE: 12222");
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => onExitAlert(context, onCancel: () {
              Navigator.of(context).pop(false);
            }, onExit: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }),
          );
        }
      },
      child: Scaffold(
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
            unselectedLabelStyle: CustomTextStyle.textPTsansMedium.copyWith(fontSize: 12),
            selectedLabelStyle: CustomTextStyle.textPTsansMedium.copyWith(fontSize: 12),
            onTap: (v) {
              homeCon.pageWidget.value = v;
              if (homeCon.pageWidget.value == 2) {
                walletCon.selectedIndex.value = null;
              }
              if (homeCon.pageWidget.value != 3) {
                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);
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
                icon: Container(
                  width: 20,
                  height: 15,
                  child: SvgPicture.asset(
                    ConstantImage.moreImage,
                    width: 15,
                    color: homeCon.pageWidget.value == 4 ? AppColors.appbarColor : AppColors.black,
                  ),
                ),
                label: "More",
              )
            ],
          ),
        ),
      ),
    );
  }

  onExitAlert(BuildContext context, {required Function() onExit, required Function() onCancel}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AlertDialog(
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
      ),
    );
  }
}
