import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
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
    return Expanded(
      child: SingleChildScrollView(
        child: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.arrow_back, color: AppColors.white)),
                          const SizedBox(width: 5),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Text(
                        textAlign: TextAlign.center,
                        "Fund withdrawal history",
                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                          color: AppColors.white,
                          fontSize: Dimensions.h17,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                  itemCount: 10,
                  // walletCon.fundTransactionList.length,
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
                                        "Amount: ₹20",
                                        // "₹ ${walletCon.fundTransactionList[i].amount} ",
                                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                          color: AppColors.appbarColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Withdrawal",
                                      style: CustomTextStyle.textRobotoSansMedium
                                          .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      "Payment Mode",
                                      style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                        color: AppColors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        ": UPI/Google pay",
                                        // ":  ${walletCon.fundTransactionList[i].paymentMode}",
                                        style: CustomTextStyle.textRobotoSansMedium
                                            .copyWith(color: AppColors.black, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "Order Id ",
                                          style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                            fontSize: 15,
                                            color: AppColors.grey,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: ""
                                                  "               : 89878459565484984",
                                              // text: "${walletCon.fundTransactionList[i].orderId}",
                                              style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.w400,
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
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset(ConstantImage.clockSvg, height: 15),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      // CommonUtils().convertUtcToIstFormatStringToDDMMYYYYHHMMA2(
                                      //     // walletCon.fundTransactionList[i].createdAt ??
                                      //     "123"),

                                      "18-08-2023 08:04 AM",
                                      style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: 15),
                                    ),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     walletCon.fundTransactionList[i].status == "Pending"
                                  //         ? SvgPicture.asset(ConstantImage.sendWatchIcon, height: 15)
                                  //         : walletCon.fundTransactionList[i].status == "Ok"
                                  //             ? Icon(Icons.check_circle, color: AppColors.green)
                                  //             : Container(
                                  //                 padding: EdgeInsets.all(2.0),
                                  //                 decoration: BoxDecoration(
                                  //                   color: AppColors.redColor,
                                  //                   shape: BoxShape.circle,
                                  //                 ),
                                  //                 child: Center(
                                  //                   child: Icon(
                                  //                     Icons.close,
                                  //                     color: AppColors.grey,
                                  //                     size: 15,
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //     // SvgPicture.asset(ConstantImage.clockSvg, height: 15),
                                  //     const SizedBox(width: 5),
                                  //     Text(
                                  //       walletCon.fundTransactionList[i].status == "Ok"
                                  //           ? "Success"
                                  //           : walletCon.fundTransactionList[i].status == "F"
                                  //               ? "Failed"
                                  //               : walletCon.fundTransactionList[i].status ?? "",
                                  //       style: CustomTextStyle.textRobotoSansBold.copyWith(
                                  //         fontSize: 15,
                                  //         color: walletCon.fundTransactionList[i].status == "Pending"
                                  //             ? AppColors.appbarColor
                                  //             : walletCon.fundTransactionList[i].status == "Ok"
                                  //                 ? AppColors.green
                                  //                 : AppColors.redColor,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
