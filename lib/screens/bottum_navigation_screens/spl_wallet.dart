import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Custom Controllers/wallet_controller.dart';
import '../../components/common_appbar.dart';
import '../../components/common_wallet_list.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../More Details Screens/Withdrawal Page/withdrawal_page.dart';
import '../fund_deposit_history.dart';
import '../home_screen/add_fund.dart';
import '../home_screen/controller/homepage_controller.dart';
import '../new_ui/bottom_bar_screens/home_screens/add_bank_details.dart';
import '../new_ui/bottom_bar_screens/home_screens/fund_withdrawal_history.dart';

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
      /* case 5:
        return const BankChangeHistory();*/
    }
  }
}
