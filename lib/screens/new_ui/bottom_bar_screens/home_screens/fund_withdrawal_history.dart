import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/common_utils.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/screens/More%20Details%20Screens/Check%20Withdrawal%20History/controller/check_withdrawal_history_controller.dart';

class FundWithdrawalHistory extends StatefulWidget {
  const FundWithdrawalHistory({super.key});

  @override
  State<FundWithdrawalHistory> createState() => _FundWithdrawalHistoryState();
}

class _FundWithdrawalHistoryState extends State<FundWithdrawalHistory> {
  final walletCon = Get.find<WalletController>();
  final controller = Get.put<CheckWithdrawalPageController>(CheckWithdrawalPageController());
  @override
  void initState() {
    super.initState();
    controller.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        walletCon.selectedIndex.value = null;
        return false;
      },
      child: Expanded(
        child: Material(
          child: Column(
            children: [
              Container(
                color: AppColors.appbarColor,
                padding: const EdgeInsets.all(10),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                              onTap: () => walletCon.selectedIndex.value = null,
                              child: Icon(Icons.arrow_back, color: AppColors.white)),
                          const SizedBox(width: 5),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      Text(
                        textAlign: TextAlign.center,
                        "Fund Withdrawal History",
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
              Obx(
                () => Expanded(
                  child: controller.withdrawalRequestList.isEmpty
                      ? Center(
                          child: Text(
                            "NOHISTORYAVAILABLEFORLAST7DAYS".tr,
                            style: CustomTextStyle.textPTsansMedium.copyWith(
                              fontSize: Dimensions.h13,
                              color: AppColors.black,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => const SizedBox(height: 20),
                              itemCount: controller.withdrawalRequestList.length,
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
                                                    "₹ ${controller.withdrawalRequestList[i].requestedAmount}",
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
                                                  "Request Id",
                                                  style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                    color: AppColors.textColor,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    controller.withdrawalRequestList[i].requestId ?? "",
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
                                                      text: "Remarks ",
                                                      style: CustomTextStyle.textRobotoSansMedium.copyWith(
                                                        fontSize: 15,
                                                        color: AppColors.black,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: controller.withdrawalRequestList[i].remarks ?? "",
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
                                              SvgPicture.asset(ConstantImage.clockSvg, height: 18),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  CommonUtils().convertUtcToIstFormatStringToDDMMYYYYHHMMA2(
                                                      controller.withdrawalRequestList[i].requestTime ?? ""),
                                                  style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: 15),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  controller.withdrawalRequestList[i].status?.toLowerCase() == "pending"
                                                      ? SvgPicture.asset(ConstantImage.sendWatchIcon, height: 15)
                                                      : controller.withdrawalRequestList[i].status?.toLowerCase() ==
                                                              "accepted"
                                                          ? Icon(Icons.check_circle, color: AppColors.green)
                                                          : Container(
                                                              padding: const EdgeInsets.all(2.0),
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
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    controller.withdrawalRequestList[i].status?.toLowerCase() ==
                                                            "accepted"
                                                        ? "Accepted"
                                                        : controller.withdrawalRequestList[i].status?.toLowerCase() ==
                                                                "rejected"
                                                            ? "Rejected"
                                                            : controller.withdrawalRequestList[i].status ?? "Pending",
                                                    style: CustomTextStyle.textRobotoSansBold.copyWith(
                                                      fontSize: 15,
                                                      color: controller.withdrawalRequestList[i].status
                                                                  ?.toLowerCase() ==
                                                              "pending"
                                                          ? AppColors.appbarColor
                                                          : controller.withdrawalRequestList[i].status?.toLowerCase() ==
                                                                  "accepted"
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
