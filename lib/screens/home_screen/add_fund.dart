import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/components/simple_button_with_corner.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/screens/home_screen/controller/homepage_controller.dart';

import '../../helper_files/ui_utils.dart';

class AddFund extends StatefulWidget {
  final String? wallet;
  const AddFund({super.key, this.wallet});

  @override
  State<AddFund> createState() => _AddFundState();
}

class _AddFundState extends State<AddFund> with WidgetsBindingObserver {
  final homeCon = Get.put(HomePageController());
  final walletCon = Get.find<WalletController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    homeCon.getTickets();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        walletCon.getTransactionHistory(true);
        walletCon.getUserBalance();
        break;
      case AppLifecycleState.inactive:
        //  print("App is in an inactive state");
        break;
      case AppLifecycleState.paused:
        //    print("App is in the background");
        break;
      case AppLifecycleState.detached:
        //print("App is detached");
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (walletCon.selectedIndex.value != null) {
          walletCon.selectedIndex.value = null;
        } else {
          Get.back();
        }
        return false;
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppColors.appbarColor,
              padding: const EdgeInsets.all(10),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () {
                              if (walletCon.selectedIndex.value != null) {
                                walletCon.selectedIndex.value = null;
                              } else {
                                Get.back();
                              }
                            },
                            child: Icon(Icons.arrow_back, color: AppColors.white)),
                        const SizedBox(width: 5),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Text(
                      textAlign: TextAlign.center,
                      "Add Fund",
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
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: Dimensions.h100,
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 4,
                      color: AppColors.grey.withOpacity(0.5),
                      offset: const Offset(0, 0),
                    )
                  ],
                  borderRadius: BorderRadius.circular(Dimensions.r4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "WALLETBALANCE".tr,
                      style: CustomTextStyle.textRobotoSansBold.copyWith(fontSize: Dimensions.h22),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: Dimensions.w40,
                          width: Dimensions.w40,
                          child: SvgPicture.asset(
                            ConstantImage.walletAppbar,
                            color: AppColors.appbarColor,
                          ),
                        ),
                        SizedBox(
                          width: Dimensions.w10,
                        ),
                        Text(
                          walletCon.walletBalance.value ?? "",
                          style: CustomTextStyle.textRobotoSansMedium
                              .copyWith(fontSize: Dimensions.h28, color: AppColors.appbarColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                controller: homeCon.addFundCon,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                ],
                keyboardType: TextInputType.number,
                style: CustomTextStyle.textGothamMedium,
                cursorColor: AppColors.appbarColor,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "Enter Amount",
                  hintStyle: CustomTextStyle.textGothamMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.r10),
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.r10),
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.r10),
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(
                  homeCon.newTicketsList.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () {
                        homeCon.newTicketsList.forEach((element) => element.isSelected.value = false);
                        homeCon.addFundCon.text = homeCon.newTicketsList[index].name ?? "";
                        homeCon.newTicketsList[index].isSelected.value =
                            !homeCon.newTicketsList[index].isSelected.value;
                      },
                      child: Container(
                        height: 40,
                        width: Get.width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: homeCon.newTicketsList[index].isSelected.value
                              ? AppColors.appbarColor
                              : AppColors.greywhite.withOpacity(0.55),
                        ),
                        child: Center(
                          child: Text(
                            "₹ ${homeCon.newTicketsList[index].name}",
                            style: CustomTextStyle.textGothamMedium.copyWith(
                              fontSize: 16,
                              color: homeCon.newTicketsList[index].isSelected.value ? AppColors.white : AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundedCornerButton(
                text: "SUBMIT".tr,
                color: AppColors.appbarColor,
                borderColor: AppColors.appbarColor,
                fontSize: Dimensions.h15,
                fontWeight: FontWeight.w500,
                fontColor: AppColors.white,
                letterSpacing: 0,
                borderRadius: Dimensions.r5,
                borderWidth: 0,
                textStyle: CustomTextStyle.textGothamMedium,
                onTap: () async {
                  if (homeCon.addFundCon.text.isEmpty) {
                    AppUtils.showErrorSnackBar(bodyText: "Please enter amount");
                  } else {
                    if (homeCon.addFundCon.text.isNotEmpty) {
                      if (int.parse(homeCon.addFundCon.text) < 1) {
                        AppUtils.showErrorSnackBar(bodyText: "Please add minimum amount of ₹ 100");
                      } else {
                        walletCon.isCallDialog.value = true;
                        homeCon.addFund(amount: homeCon.addFundCon.text);
                      }
                    }
                  }
                },
                height: Dimensions.h35,
                width: Get.width / 2,
              ),
            ),
            SizedBox(height: Get.height * 0.08),
            Divider(endIndent: 20, indent: 20, color: AppColors.black),
            const SizedBox(height: 10),
            Text(
              "Pay using any UPI app",
              style: CustomTextStyle.textPTsansMedium.copyWith(
                fontSize: 16,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Image.asset(
                    ConstantImage.gPay,
                    height: 55,
                    width: 55,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Image.asset(
                    ConstantImage.paytm,
                    height: 55,
                    width: 55,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Image.asset(
                    ConstantImage.amazon,
                    height: 55,
                    width: 55,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Image.asset(
                    ConstantImage.phonepay,
                    height: 55,
                    width: 55,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Image.asset(
                    ConstantImage.icici_bank,
                    height: 55,
                    width: 55,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Image.asset(ConstantImage.bhim),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Image.asset(ConstantImage.upi),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
