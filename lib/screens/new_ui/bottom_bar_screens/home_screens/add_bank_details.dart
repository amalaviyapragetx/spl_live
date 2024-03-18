import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/components/simple_button_with_corner.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/common_textfield_border.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/screens/More%20Details%20Screens/My%20Account%20Page/controller/myaccount_page_controller.dart';
import 'package:spllive/screens/home_screen/controller/homepage_controller.dart';

class AddBankDetails extends StatefulWidget {
  const AddBankDetails({super.key});

  @override
  State<AddBankDetails> createState() => _AddBankDetailsState();
}

class _AddBankDetailsState extends State<AddBankDetails> {
  final homeCon = Get.put(HomePageController());
  final walletCon = Get.find<WalletController>();
  // var walletCon = Get.find<WalletController>();
  final controller = Get.put<MyAccountPageController>(MyAccountPageController());
  // final exitController = Get.put<DoubleTapExitController>(DoubleTapExitController());
  @override
  void initState() {
    controller.fetchStoredUserDetailsAndGetBankDetailsByUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        walletCon.selectedIndex.value = null;
        controller.bankNameController.clear();
        controller.accHolderNameController.clear();
        controller.accNoController.clear();
        controller.ifscCodeController.clear();
        return false;
      },
      child: Expanded(
        child: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                              walletCon.selectedIndex.value = null;
                              controller.bankNameController.clear();
                              controller.accHolderNameController.clear();
                              controller.accNoController.clear();
                              controller.ifscCodeController.clear();
                            },
                            child: Icon(Icons.arrow_back, color: AppColors.white),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.center,
                          "Add bank details",
                          style: CustomTextStyle.textRobotoSansMedium.copyWith(
                            color: AppColors.white,
                            fontSize: Dimensions.h17,
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimensions.h10),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => CommonTextFieldBorder(
                          con: controller.accNoController,
                          labelText: "Account No.",
                          keyBoardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          readOnly: !controller.isEditDetails.value,
                        ),
                      ),
                      Obx(
                        () => CommonTextFieldBorder(
                          con: controller.ifscCodeController,
                          labelText: "IFSC Code",
                          readOnly: !controller.isEditDetails.value,
                        ),
                      ),
                      Obx(
                        () => CommonTextFieldBorder(
                          con: controller.accHolderNameController,
                          labelText: "Account Holder Name",
                          readOnly: !controller.isEditDetails.value,
                        ),
                      ),
                      Obx(
                        () => CommonTextFieldBorder(
                          con: controller.bankNameController,
                          labelText: "Bank Name",
                          readOnly: !controller.isEditDetails.value,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Obx(
                        () => controller.isEditDetails.value
                            ? RoundedCornerButton(
                                text: "SUBMIT",
                                color: AppColors.appbarColor,
                                borderColor: AppColors.appbarColor,
                                fontSize: Dimensions.h13,
                                fontWeight: FontWeight.bold,
                                fontColor: AppColors.white,
                                letterSpacing: 1,
                                borderRadius: 5,
                                borderWidth: 0,
                                textStyle: CustomTextStyle.textPTsansMedium,
                                onTap: () => controller.callEditBankDetailsApi(),
                                height: 40,
                                width: 200,
                              )
                            : Container(),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => controller.isEditDetails.value != true
                            ? RoundedCornerButton(
                                text: "EDIT BANK DETAILS",
                                color: AppColors.wpColor1,
                                borderColor: AppColors.appbarColor,
                                fontSize: Dimensions.h13,
                                fontWeight: FontWeight.bold,
                                fontColor: AppColors.black,
                                letterSpacing: 1,
                                borderRadius: 5,
                                borderWidth: 0,
                                textStyle: CustomTextStyle.textPTsansMedium,
                                onTap: () => _showExitDialog(),
                                height: 40,
                                width: 200,
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    Get.dialog(
      barrierDismissible: false,
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: Get.width, minWidth: Get.width - 30),
        child: AlertDialog(
          insetPadding: EdgeInsets.symmetric(vertical: 10),
          contentPadding: const EdgeInsets.symmetric(horizontal: 55, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          content: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(ConstantImage.close, height: Dimensions.h60, width: Dimensions.w60),
                const SizedBox(height: 20),
                Text(
                  "Please Contact Admin to edit",
                  textAlign: TextAlign.center,
                  style: CustomTextStyle.textRobotoSansMedium.copyWith(
                    color: AppColors.appbarColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Bank details",
                  textAlign: TextAlign.center,
                  style: CustomTextStyle.textRobotoSansMedium.copyWith(
                    color: AppColors.appbarColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.appbarColor, borderRadius: BorderRadius.circular(8)),
                    height: Dimensions.h40,
                    width: Dimensions.w150,
                    child: Center(
                      child: Text(
                        'OK',
                        style: CustomTextStyle.textRobotoSansBold.copyWith(color: AppColors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
