import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spllive/controller/home_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/screens/bottom_bar_screens/home_screens/normal_markets.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeCon = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    homeCon.getBannerData();
    homeCon.getDailyMarkets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        title: const Text("SPL"),
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
            Text(
              "1000".toString().length > 8 ? "1000".toString().split(".").toString() : "10",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyle.textRobotoSansMedium.copyWith(
                color: AppColors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          homeCon.notificationCount.value == null || homeCon.notificationCount.value == 0
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () {},
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
                      onTap: () {},
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
              () => CarouselSlider(
                items: homeCon.bannerData.map((element) {
                  return Builder(
                    builder: (context) {
                      return CachedNetworkImage(
                        imageUrl: element.banner ?? "",
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
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
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
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
                const SizedBox(width: 15),
                Expanded(
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
    );
  }
}
