import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spllive/controller/home_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/screens/home_pages/normal_market_screen.dart';
import 'package:spllive/screens/home_pages/starline_market_screen.dart';
import 'package:spllive/screens/home_screen/utils/home_screen_utils.dart';
import 'package:spllive/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final String? notificationCount;
  const HomeScreen({super.key, this.notificationCount});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeCon = Get.put<HomeController>(HomeController());
  @override
  void initState() {
    super.initState();
    homeCon.setBoolData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppUtils().appbar(
          walletText: homeCon.walletBalance.toString(),
          onTapTranction: () {},
          notifictionCount: widget.notificationCount ?? "",
          onTapNotifiaction: () => Get.toNamed(AppRouteNames.notificationPage),
          onTapTelegram: () => launch("https://t.me/satta_matka_kalyan_bazar_milan"),
          shareOntap: () => Share.share("http://spl.live"),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                const SizedBox(height: 10),
                HomeScreenUtils().banner(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.h10, vertical: Dimensions.h5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 0.1,
                          color: AppColors.grey,
                          blurRadius: 10,
                          offset: const Offset(2, 3),
                        )
                      ],
                      borderRadius: BorderRadius.circular(Dimensions.h5),
                      border: Border.all(color: AppColors.redColor, width: 1),
                    ),
                    child: Obx(
                      () => Column(
                        children: [
                          const SizedBox(height: 10),
                          HomeScreenUtils().iconsContainer(
                            iconColor1:
                                homeCon.widgetContainer.value == 0 ? AppColors.appbarColor : AppColors.iconColorMain,
                            iconColor2:
                                homeCon.widgetContainer.value == 1 ? AppColors.appbarColor : AppColors.iconColorMain,
                            iconColor3:
                                homeCon.widgetContainer.value == 2 ? AppColors.appbarColor : AppColors.iconColorMain,
                            onTap1: () {
                              homeCon.position = 0;
                              homeCon.widgetContainer.value = 0;
                              homeCon.isStarline.value = false;
                            },
                            onTap2: () {
                              homeCon.position = 1;
                              homeCon.isStarline.value = true;
                              // getDailyStarLineMarkets(DateFormat('yyyy-MM-dd').format(startEndDate),
                              //     DateFormat('yyyy-MM-dd').format(startEndDate));
                              // getMarketBidsByUserId(
                              //        lazyLoad: false,
                              //        endDate: DateFormat('yyyy-MM-dd').format(startEndDate),
                              //        startDate: DateFormat('yyyy-MM-dd').format(startEndDate));
                              homeCon.widgetContainer.value = 1;
                            },
                            onTap3: () {
                              homeCon.position = 2;
                              homeCon.widgetContainer.value = 2;
                              homeCon.isStarline.value = false;
                              launch("https://wa.me/+917769826748/?text=hi");
                            },
                          ),
                          const SizedBox(height: 10),
                          Obx(() {
                            return homeCon.isStarline.value
                                ? HomeScreenUtils().iconsContainer2(
                                    iconColor1: homeCon.widgetContainer.value == 3
                                        ? AppColors.appbarColor
                                        : AppColors.iconColorMain,
                                    iconColor2: homeCon.widgetContainer.value == 4
                                        ? AppColors.appbarColor
                                        : AppColors.iconColorMain,
                                    iconColor3: homeCon.widgetContainer.value == 5
                                        ? AppColors.appbarColor
                                        : AppColors.iconColorMain,
                                    onTap1: () {
                                      homeCon.position = 3;
                                      homeCon.widgetContainer.value = 3;
                                      // getMarketBidsByUserId(
                                      //   lazyLoad: false,
                                      //   endDate: DateFormat('yyyy-MM-dd').format(startEndDate),
                                      //   startDate: DateFormat('yyyy-MM-dd').format(
                                      //     startEndDate,
                                      //   ),
                                      // );
                                    },
                                    onTap2: () {
                                      homeCon.position = 4;
                                      homeCon.widgetContainer.value = 4;
                                      // getDailyStarLineMarkets(
                                      //   DateFormat('yyyy-MM-dd').format(startEndDate),
                                      //   DateFormat('yyyy-MM-dd').format(startEndDate),
                                      // );
                                    },
                                    onTap3: () {
                                      homeCon.position = 5;
                                      homeCon.widgetContainer.value = 5;

                                      // callGetStarLineChart();
                                    },
                                  )
                                : Container();
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(() => getDashBoardWidget(homeCon.widgetContainer.value, context)),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getDashBoardWidget(index, BuildContext context) {
    switch (index) {
      case 0:
        return const NormalMarketScreen();
      case 1:
        return StarlineMarketScreen();
      case 2:
        return Container();
      case 3:
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.h10), child: HomeScreenUtils().bidHistory(context));
      case 4:
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.h10), child: HomeScreenUtils().resultHistory(context));
      case 5:
        return Column(
          children: [
            SizedBox(height: Dimensions.h10),
            const Text("Starline Chart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: Dimensions.h5),
            // homeCon.starlineChartDateAndTime.isEmpty
            //     ? SizedBox(
            //         height: Get.height / 2.5,
            //         child: Center(
            //           child: Text(
            //             "There is no Data in Starlin Chart",
            //             style: CustomTextStyle.textRobotoSansMedium,
            //           ),
            //         ),
            //       )
            //     : SingleChildScrollView(
            //         scrollDirection: Axis.vertical,
            //         child: Row(
            //           children: [HomeScreenUtils().dateColumn(), Expanded(child: HomeScreenUtils().timeColumn())],
            //         ),
            //       ),
          ],
        );
      default:
        return HomeScreenUtils().gridColumn();
    }
  }
}
