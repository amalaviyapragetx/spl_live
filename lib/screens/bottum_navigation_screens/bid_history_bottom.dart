import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/common_appbar.dart';
import '../../components/common_wallet_list.dart';
import '../../controller/home_controller.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../../models/bid_history_model_new.dart';
import '../new_ui/bottom_bar_screens/starline market/market_history.dart';
import '../new_ui/bottom_bar_screens/starline market/starline_bid_history.dart';
import '../new_ui/bottom_bar_screens/starline market/starline_result_history.dart';

class BidHistoryBottom extends StatefulWidget {
  const BidHistoryBottom({super.key});

  @override
  State<BidHistoryBottom> createState() => _BidHistoryBottomState();
}

class _BidHistoryBottomState extends State<BidHistoryBottom> {
  final homeCon = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CommonAppBar(
            title: "Bid History",
            titleTextStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
              fontSize: Dimensions.h17,
              color: AppColors.white,
            ),
            leading: Container(),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: homeCon.filterDateList.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CommonWalletList(
                      title: homeCon.filterDateList[index].name,
                      image: homeCon.filterDateList[index].image,
                      onTap: () {
                        homeCon.selectedIndex.value = index;
                        if (index == 0) {
                          homeCon.date = null;
                          homeCon.dateInputForResultHistory.clear();
                          Get.to(() =>  BidHistoryNew());
                        } else if (index == 1) {
                          Get.to(() => const MarketHistory());
                        } else if (index == 2) {
                          Get.to(() => const StarlineBidHistory());
                        } else {
                          Get.to(() => const StarlineResultHistory());
                        }
                      },
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
