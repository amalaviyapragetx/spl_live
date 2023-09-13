import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import '../../helper_files/app_colors.dart';
import '../../helper_files/constant_image.dart';
import '../../helper_files/dimentions.dart';
import 'controller/starline_game_modes_page_controller.dart';

// ignore: must_be_immutable
class StarLineGameModesPage extends StatelessWidget {
  StarLineGameModesPage({super.key});
  var walletController = Get.put(WalletController());
  final controller = Get.put(StarLineGameModesPageController());
  var verticalSpace = SizedBox(
    height: Dimensions.h10,
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // controller.getBidListData();
    return WillPopScope(
      onWillPop: () async {
        controller.onBackButton();
        return false;
      },
      child: Scaffold(
        appBar: AppUtils().simpleAppbar(
          appBarTitle: controller.marketData.value.time.toString(),
          leading: IconButton(
            onPressed: () => controller.onBackButton(),
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            InkWell(
              onTap: () {
                //  Get.offAndToNamed(AppRoutName.transactionPage);
              },
              child: Row(
                children: [
                  SizedBox(
                    height: Dimensions.h20,
                    width: Dimensions.w25,
                    child: SvgPicture.asset(
                      ConstantImage.walletAppbar,
                      color: AppColors.white,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Dimensions.r8,
                      bottom: Dimensions.r5,
                      left: Dimensions.r10,
                      right: Dimensions.r10,
                    ),
                    child: Obx(
                      () => Text(
                        walletController.walletBalance.toString(),
                        style: CustomTextStyle.textRobotoSansMedium.copyWith(
                          color: AppColors.white,
                          fontSize: Dimensions.h17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Obx(
          () => SizedBox(
            child: controller.gameModesList.isEmpty
                ? _buildCustomAboutBoxDialog()
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.w10, vertical: Dimensions.h5),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: cardWidget(controller, size),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void showCustomAboutBoxDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.3), // Transparent background
      barrierDismissible:
          false, // Prevent users from dismissing the dialog by tapping outside
      builder: (context) => _buildCustomAboutBoxDialog(),
    );
  }

  Widget _buildCustomAboutBoxDialog() {
    return Dialog(
      backgroundColor: AppColors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(width: Dimensions.w10),
            Text(
              "PLEASEWAIT".tr,
              style: CustomTextStyle.textPTsansBold
                  .copyWith(fontSize: Dimensions.h15),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardWidget(StarLineGameModesPageController controller, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.gameModesList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: Dimensions.h140,
            crossAxisSpacing: 5,
            mainAxisSpacing: 2),
        itemBuilder: (context, index) {
          return Padding(
            padding: index % 2 == 0
                ? const EdgeInsets.only(left: 25, top: 10, bottom: 5, right: 7)
                : const EdgeInsets.only(top: 10, bottom: 5, right: 25, left: 7),
            child: InkWell(
              onTap: () {
                controller.onTapOfGameModeTile(index);
              },
              child: Container(
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
                  borderRadius: BorderRadius.circular(Dimensions.r15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: Dimensions.w65,
                      width: Dimensions.w65,
                      decoration: BoxDecoration(
                        color: AppColors.wpColor1,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(17.0),
                        child: Image.network(
                          controller.gameModesList
                              .elementAt(index)
                              .image
                              .toString(),
                          height: Dimensions.h10,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.h17,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
                        width: size.width,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              controller.gameModesList.elementAt(index).name ??
                                  "",
                              style: CustomTextStyle.textRobotoSansBold
                                  .copyWith(fontSize: Dimensions.h14),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
