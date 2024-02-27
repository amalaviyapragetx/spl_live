import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/common_utils.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';

class FundWithdrawalHistory extends StatefulWidget {
  const FundWithdrawalHistory({super.key});

  @override
  State<FundWithdrawalHistory> createState() => _FundWithdrawalHistoryState();
}

class _FundWithdrawalHistoryState extends State<FundWithdrawalHistory> {
  var walletCon = Get.find<WalletController>();
  @override
  void initState() {
    super.initState();
    walletCon.getTransactionHistory(false);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Expanded(
        child: walletCon.fundTransactionList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                  itemCount: walletCon.fundTransactionList.length,
                  itemBuilder: (context, i) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.black),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 0.8722222447395325,
                            blurRadius: 6.97777795791626,
                            offset: const Offset(0, 0),
                            color: AppColors.black.withOpacity(0.25),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "₹ ${walletCon.fundTransactionList[i].amount}",
                                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                          color: AppColors.appbarColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Deposit",
                                      style: CustomTextStyle.textRobotoSansMedium.copyWith(fontSize: 15),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Payment Mode",
                                      style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                        color: AppColors.grey,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        ":  ${walletCon.fundTransactionList[i].paymentMode}",
                                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "Order Id : ",
                                          style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                            fontSize: 15,
                                            color: AppColors.grey,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "${walletCon.fundTransactionList[i].orderId}",
                                              style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                color: AppColors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.greyShade.withOpacity(0.4),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(Dimensions.r8),
                                bottomRight: Radius.circular(Dimensions.r8),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset(ConstantImage.clockSvg, height: 15),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      CommonUtils().convertUtcToIstFormatStringToDDMMYYYYHHMMA2(
                                          walletCon.fundTransactionList[i].createdAt ?? ""),
                                      style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: 15),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      walletCon.fundTransactionList[i].status == "Pending"
                                          ? SvgPicture.asset(ConstantImage.sendWatchIcon, height: 15)
                                          : walletCon.fundTransactionList[i].status == "Ok"
                                              ? Icon(Icons.check_circle, color: AppColors.green)
                                              : Container(
                                                  padding: EdgeInsets.all(2.0),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.redColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.close,
                                                      color: AppColors.grey,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ),
                                      // SvgPicture.asset(ConstantImage.clockSvg, height: 15),
                                      const SizedBox(width: 5),
                                      Text(
                                        walletCon.fundTransactionList[i].status == "Ok"
                                            ? "Success"
                                            : walletCon.fundTransactionList[i].status == "F"
                                                ? "Failed"
                                                : walletCon.fundTransactionList[i].status ?? "",
                                        style: CustomTextStyle.textRobotoSansBold.copyWith(
                                          fontSize: 15,
                                          color: walletCon.fundTransactionList[i].status == "Pending"
                                              ? AppColors.appbarColor
                                              : walletCon.fundTransactionList[i].status == "Ok"
                                                  ? AppColors.green
                                                  : AppColors.redColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            : const Center(child: Text("There is No Transactions")),
      ),
    );
  }
}
