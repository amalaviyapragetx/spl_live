import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/components/common_wallet_list.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/screens/More%20Details%20Screens/Withdrawal%20Page/withdrawal_page.dart';
import 'package:spllive/screens/fund_withdrawal_history.dart';
import 'package:spllive/screens/home_screen/add_fund.dart';
import 'package:spllive/screens/home_screen/controller/homepage_controller.dart';

class SPLWallet extends StatefulWidget {
  const SPLWallet({super.key});

  @override
  State<SPLWallet> createState() => _SPLWalletState();
}

class _SPLWalletState extends State<SPLWallet> {
  final homeCon = Get.put(HomePageController());
  var walletCon = Get.find<WalletController>();
  @override
  void initState() {
    super.initState();
    walletCon.getUserBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.appbarColor,
          padding: const EdgeInsets.all(15.0),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      ConstantImage.walletAppbar,
                      height: 18,
                      width: 20,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        walletCon.walletBalance.value,
                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                          fontSize: Dimensions.h16,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Text(
                    textAlign: TextAlign.center,
                    "WALLET".tr,
                    style: CustomTextStyle.textRobotoSansMedium.copyWith(
                      color: AppColors.white,
                      fontSize: Dimensions.h20,
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
        Obx(
          () => walletCon.selectedIndex.value != null
              ? currentWidget(walletCon.selectedIndex.value)
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: walletCon.filterDateList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => CommonWalletList(
                      title: walletCon.filterDateList[index].name,
                      image: walletCon.filterDateList[index].image,
                      onTap: () {
                        // if (walletCon.filterDateList[index].name == "Withdrawal Fund") {
                        //   homeCon.pageWidget.value = 5;
                        //   homeCon.currentIndex.value = 5;
                        // } else {
                        walletCon.selectedIndex.value = index;
                        // }
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  currentWidget(index) {
    switch (index) {
      case 0:
        return const AddFund();
      case 1:
        return WithdrawalPage();
      case 2:
        return const FundWithdrawalHistory();
    }
  }
}
