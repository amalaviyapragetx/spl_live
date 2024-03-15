import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/controller/home_controller.dart';
import 'package:spllive/controller/starline_market_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/routes/app_routes_name.dart';
import 'package:spllive/screens/home_screen/add_fund.dart';
import 'package:spllive/screens/new_ui/bottom_bar_screens/home_screens/normal_markets.dart';
import 'package:spllive/screens/new_ui/bottom_bar_screens/starline%20market/starline_markets.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeCon = Get.find<HomeController>();
  final starlineCon = Get.find<StarlineMarketController>();
  final walletCon = Get.find<WalletController>();
  @override
  void initState() {
    super.initState();
    walletCon.getUserBalance();
    homeCon.getBannerData();
    homeCon.getDailyMarkets();
    homeCon.getNotificationCount();
    homeCon.getNotificationsData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.appbarColor,
            title: Text("SPL", style: TextStyle(color: AppColors.white)),
            centerTitle: true,
            leadingWidth: Get.width * 0.4,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: Dimensions.w5),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: SizedBox(
                    width: Dimensions.w40,
                    child: SvgPicture.asset(
                      ConstantImage.walletAppbar,
                      color: AppColors.white,
                    ),
                  ),
                ),
                Obx(
                  () => Text(
                    walletCon.walletBalance.toString().length > 8
                        ? walletCon.walletBalance.toString().split(".").toString()
                        : walletCon.walletBalance.toString(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyle.textRobotoSansMedium.copyWith(
                      color: AppColors.white,
                      fontSize: Dimensions.h16,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              homeCon.notificationCount.value == null || homeCon.notificationCount.value == 0
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () => Get.toNamed(AppRoutName.notificationPage),
                        child: Icon(
                          Icons.notifications_active,
                          color: AppColors.white,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 12, top: 17, bottom: 17),
                      child: Badge(
                        smallSize: Dimensions.h9,
                        child: InkWell(
                          onTap: () => Get.toNamed(AppRoutName.notificationPage),
                          child: Icon(
                            Icons.notifications_active,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: InkWell(
                  onTap: () => launch("https://t.me/satta_matka_kalyan_bazar_milan"),
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                    child: Transform.rotate(
                      angle: 180 * 3.14 / 48,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 3),
                        child: Icon(
                          Icons.send,
                          size: 11,
                          color: AppColors.appbarColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
                child: InkWell(
                  onTap: () => Share.share("https://spl.live"),
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.share,
                        size: 11,
                        color: AppColors.appbarColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.h7),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Obx(
                  () => homeCon.bannerData.isNotEmpty
                      ? CarouselSlider(
                          items: homeCon.bannerData.map((element) {
                            return Builder(
                              builder: (context) {
                                return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.h7),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(element.banner ?? ""),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ));
                              },
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: Dimensions.h90,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 15 / 4,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration: const Duration(milliseconds: 600),
                            viewportFraction: 1,
                          ),
                        )
                      : SizedBox(
                          height: 100,
                          child: Center(
                            child: Icon(
                              Icons.error_outline,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.to(() => StarlineDailyMarketData()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.appbarColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                ConstantImage.starLineIcon,
                                height: 30,
                                color: AppColors.white,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "SPL STARLINE",
                                style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                  color: AppColors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.to(() => AddFund()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.appbarColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                ConstantImage.addFundIcon,
                                height: 30,
                                color: AppColors.white,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "ADD FUND",
                                style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                  color: AppColors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: NormalMarketsList(normalMarketList: homeCon.normalMarketList),
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(
          () => homeCon.getNotificationCount.value > 0
              ? Stack(
                  children: [
                    Material(
                      color: AppColors.black.withOpacity(0.4),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: Dimensions.h95, bottom: 60.0),
                        child: Container(
                          color: AppColors.white,
                          width: double.infinity,
                          child: Obx(
                            () => ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: homeCon.notificationData.length,
                              itemBuilder: (context, index) {
                                return notificationWidget(
                                  notificationHeader: homeCon.notificationData[index].title ?? "",
                                  notificationSubTitle: homeCon.notificationData[index].description ?? "",
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: AppColors.transparent,
                      child: Padding(
                        padding: EdgeInsets.only(top: Dimensions.h87, bottom: 8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              homeCon.resetNotificationCount();
                              homeCon.getNotificationCount.refresh();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(Dimensions.r10),
                              ),
                              child: Icon(Icons.close, color: AppColors.redColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        )
      ],
    );
  }

  Widget notificationWidget({String? notificationHeader, String? notificationSubTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              color: AppColors.grey.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.h8),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimensions.h5),
              Text(
                notificationHeader ?? "",
                style: CustomTextStyle.textRobotoSansBold.copyWith(
                  color: AppColors.black,
                  fontSize: Dimensions.h14,
                ),
              ),
              SizedBox(height: Dimensions.h5),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  child: Text(
                    notificationSubTitle ?? "",
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
