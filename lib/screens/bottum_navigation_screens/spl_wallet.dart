import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/components/common_appbar.dart';
import 'package:spllive/components/common_wallet_list.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/screens/More%20Details%20Screens/Withdrawal%20Page/withdrawal_page.dart';
import 'package:spllive/screens/fund_deposit_history.dart';
import 'package:spllive/screens/home_screen/add_fund.dart';
import 'package:spllive/screens/home_screen/controller/homepage_controller.dart';
import 'package:spllive/screens/new_ui/bottom_bar_screens/home_screens/add_bank_details.dart';
import 'package:spllive/screens/new_ui/bottom_bar_screens/home_screens/bank_changes_history.dart';
import 'package:spllive/screens/new_ui/bottom_bar_screens/home_screens/fund_withdrawal_history.dart';

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
      // mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => walletCon.selectedIndex.value == null
              ? GetBuilder<WalletController>(
                  builder: (con) => CommonAppBar(
                    walletBalance: con.walletBalance.value,
                    title: "WALLET".tr,
                    titleTextStyle: CustomTextStyle.textRobotoSansMedium.copyWith(
                      fontSize: Dimensions.h16,
                      color: AppColors.white,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
        Obx(
          () => walletCon.selectedIndex.value != null
              ? currentWidget(walletCon.selectedIndex.value)
              : Expanded(
                  child: Padding(
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
        return const AddBankDetails();
      case 3:
        return FundDipositHistory();
      case 4:
        return const FundWithdrawalHistory();
      case 5:
        return const BankChangeHistory();
    }
  }
}
