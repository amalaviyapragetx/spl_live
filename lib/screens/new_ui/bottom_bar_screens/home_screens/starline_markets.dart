import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spllive/controller/home_controller.dart';
import 'package:spllive/controller/starline_market_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:url_launcher/url_launcher.dart';

class StarlineMarketList extends StatefulWidget {
  const StarlineMarketList({super.key});

  @override
  State<StarlineMarketList> createState() => _StarlineMarketListState();
}

class _StarlineMarketListState extends State<StarlineMarketList> {
  final homeCon = Get.find<HomeController>();
  final starlineCon = Get.find<StarlineMarketController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      return Container();
                      // return CachedNetworkImage(
                      //   imageUrl: element.banner ?? "",
                      //   placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      //   errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                      // );
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
              children: starlineCon.starlineButtonList
                  .map(
                    (e) => Expanded(
                      child: InkWell(
                        onTap: () {
                          for (var e in starlineCon.starlineButtonList) {
                            e.isSelected.value = false;
                          }
                          e.isSelected.value = true;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Container(
                            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                // color: e.isSelected.value ? AppColors.grey : AppColors.appbarColor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 0.8722222447395325,
                                    blurRadius: 6.97777795791626,
                                    offset: const Offset(0, 0),
                                    color: AppColors.black.withOpacity(0.25),
                                  )
                                ]),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(
                                  () => SvgPicture.asset(
                                    e.image ?? "",
                                    height: 30,
                                    color: e.isSelected.value ? AppColors.appbarColor : AppColors.black,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Obx(() => Text(
                                      e.name ?? "",
                                      style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                        color: e.isSelected.value ? AppColors.appbarColor : AppColors.black,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: InkWell(
            //         onTap: () => Get.to(() => StarlineMarketList()),
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(vertical: 10),
            //           decoration: BoxDecoration(
            //             color: AppColors.appbarColor,
            //             borderRadius: BorderRadius.circular(8),
            //           ),
            //           child: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               SvgPicture.asset(
            //                 ConstantImage.starLineIcon,
            //                 height: 30,
            //                 color: AppColors.white,
            //               ),
            //               const SizedBox(height: 5),
            //               Text(
            //                 "Bid History",
            //                 style: CustomTextStyle.textRobotoSansMedium.copyWith(
            //                   color: AppColors.white,
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 15),
            //     Expanded(
            //       child: InkWell(
            //         onTap: () => Get.to(() => AddFund()),
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(vertical: 10),
            //           decoration: BoxDecoration(
            //             color: AppColors.appbarColor,
            //             borderRadius: BorderRadius.circular(8),
            //           ),
            //           child: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               SvgPicture.asset(
            //                 ConstantImage.addFundIcon,
            //                 height: 30,
            //                 color: AppColors.white,
            //               ),
            //               const SizedBox(height: 5),
            //               Text(
            //                 "Result History",
            //                 style: CustomTextStyle.textRobotoSansMedium.copyWith(
            //                   color: AppColors.white,
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 15),
            //     Expanded(
            //       child: InkWell(
            //         onTap: () => Get.to(() => AddFund()),
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(vertical: 10),
            //           decoration: BoxDecoration(
            //             color: AppColors.appbarColor,
            //             borderRadius: BorderRadius.circular(8),
            //           ),
            //           child: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               SvgPicture.asset(
            //                 ConstantImage.addFundIcon,
            //                 height: 30,
            //                 color: AppColors.white,
            //               ),
            //               const SizedBox(height: 5),
            //               Text(
            //                 "Chart",
            //                 style: CustomTextStyle.textRobotoSansMedium.copyWith(
            //                   color: AppColors.white,
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
