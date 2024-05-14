import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/controller/home_controller.dart';
import 'package:spllive/controller/starline_market_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/constant_variables.dart';
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
    GetStorage().write(ConstantsVariables.timeOut, true);
    walletCon.getUserBalance();
    homeCon.getBannerData();
    homeCon.getDailyMarkets();
    homeCon.getNotificationCountData();
    homeCon.getNotificationsData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        homeCon.getBannerData();
        homeCon.getDailyMarkets();
        homeCon.getNotificationCountData();
        homeCon.getNotificationsData();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: AppColors.appbarColor,
          title: Text("SPL",
              style: CustomTextStyle.textRamblaMedium
                  .copyWith(color: Colors.white, fontSize: Dimensions.h20, fontWeight: FontWeight.w700)),
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
                  style: CustomTextStyle.textRobotoMedium.copyWith(
                    color: AppColors.white,
                    fontSize: Dimensions.h16,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Obx(
              () => homeCon.notificationCount.value == null || homeCon.notificationCount.value == 0
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () => Get.toNamed(AppRoutName.notificationPage),
                        child: Icon(
                          Icons.notifications_active,
                          color: AppColors.white,
                          size: 21,
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
                            size: 21,
                          ),
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 17),
              child: InkWell(
                onTap: () => launch("https://t.me/satta_matka_kalyan_bazar_milan"),
                child: Container(
                  height: 23,
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
                  height: 23,
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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                      child: Image(
                                        image: NetworkImage(element.banner ?? ""),
                                        errorBuilder: (context, error, stackTrace) => Center(
                                          child: Icon(
                                            Icons.error_outline,
                                            color: AppColors.appbarColor,
                                            size: 35,
                                          ),
                                        ),
                                      ),
                                      // child: Container(
                                      //   decoration: BoxDecoration(
                                      //     image: DecorationImage(
                                      //       image: NetworkImage(element.banner ?? ""),
                                      //       fit: BoxFit.cover,
                                      //     ),
                                      //   ),
                                      // ),
                                    );
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    ConstantImage.starLineIcon,
                                    height: 30,
                                    color: AppColors.white,
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    "SPL STARLINE",
                                    style: CustomTextStyle.textRobotoMedium
                                        .copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => Get.to(() => AddFund()),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.appbarColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    ConstantImage.addFundIcon,
                                    height: 30,
                                    color: AppColors.white,
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    "ADD FUND",
                                    style: CustomTextStyle.textRobotoMedium
                                        .copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    // const SizedBox(height: 10),
                    NormalMarketsList(normalMarketList: homeCon.normalMarketList),
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
                                  shrinkWrap: true,
                                  itemCount: homeCon.notificationData.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: notificationWidget(
                                        notificationHeader: homeCon.notificationData[index].title ?? "",
                                        notificationSubTitle: homeCon.notificationData[index].description ?? "",
                                      ),
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
        ),
      ),
    );
  }

  Widget notificationWidget({String? notificationHeader, String? notificationSubTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              color: AppColors.grey.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                gradient: LinearGradient(
                  colors: [AppColors.wpColor1, AppColors.wpColor2],
                ),
              ),
              child: Center(
                child: Text(
                  notificationHeader ?? "",
                  style: CustomTextStyle.textRobotoSansBold.copyWith(
                    color: AppColors.white,
                    fontSize: Dimensions.h14,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.h5),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dear Players,",
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Dimensions.h5),
                  Text(
                    notificationSubTitle ?? "",
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h13,
                    ),
                  ),
                  SizedBox(height: Dimensions.h5),
                  Text(
                    "Regards",
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h13,
                    ),
                  ),
                  Text(
                    "SPL ADMIN",
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.textRobotoSansLight.copyWith(
                      color: AppColors.black,
                      fontSize: Dimensions.h13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
