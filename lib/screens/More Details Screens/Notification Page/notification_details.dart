import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helper_files/app_colors.dart';
import '../../../helper_files/custom_text_style.dart';
import '../../../helper_files/dimentions.dart';
import '../../../helper_files/ui_utils.dart';
import 'controller/notification_details_controller.dart';

class NotificationDetailsPage extends StatelessWidget {
  NotificationDetailsPage({super.key});
  var controller = Get.put(NotificationDetailsPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppUtils().simpleAppbar(appBarTitle: "NOTIFICATIONS".tr),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "SPLNOTIFICATION".tr,
            //   style: CustomTextStyle.textPTsansMedium.copyWith(
            //     color: AppColors.black,
            //     fontSize: Dimensions.h15,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // SizedBox(
            //   height: Dimensions.h20,
            // ),
            Container(
              height: Dimensions.h50,
              width: double.infinity,
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "MARKETNOTIFICATION".tr,
                      style: CustomTextStyle.textRobotoSansMedium.copyWith(
                        color: AppColors.black,
                        fontSize: Dimensions.h15,
                      ),
                    ),
                    Obx(
                      () => Switch.adaptive(
                        activeColor: AppColors.appbarColor,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: controller.marketNotificationFromLocal.value,
                        onChanged: (value) {
                          controller.marketNotificationFromLocal.value = value;

                          controller.addRating();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.h8,
            ),
            Container(
              height: Dimensions.h50,
              width: double.infinity,
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "STARLINENOTIFICATION".tr,
                      style: CustomTextStyle.textRobotoSansMedium.copyWith(
                        color: AppColors.black,
                        fontSize: Dimensions.h15,
                      ),
                    ),
                    Obx(
                      () => Switch.adaptive(
                        activeColor: AppColors.appbarColor,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: controller.starlineNotificationFromLocal.value,
                        onChanged: (value) {
                          controller.starlineNotificationFromLocal.value =
                              value;

                          controller.addRating();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
