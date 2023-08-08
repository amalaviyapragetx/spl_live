import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spllive/helper_files/ui_utils.dart';

import '../../helper_files/app_colors.dart';

import '../../helper_files/common_utils.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import '../home_screen/controller/homepage_controller.dart';
import 'controller/bottum_navigation_controller.dart';

class PassBook extends StatelessWidget {
  PassBook({super.key});
  var verticalSpace = SizedBox(
    width: Dimensions.w3,
  );
  var homeController = Get.put(HomePageController());
  var controller = Get.put(MoreListController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Column(
        children: [
          AppUtils().simpleAppbar(
            appBarTitle: "",
            leadingWidht: 900,
            leading: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: Dimensions.w15),
                  Text(
                    "Passbook",
                    style: CustomTextStyle.textRobotoSansMedium
                        .copyWith(fontSize: Dimensions.h20),
                  ),
                  const Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () {
                      if (homeController.pageWidget.value == 3 &&
                          homeController.currentIndex.value == 3) {
                        if (MediaQuery.of(context).orientation ==
                            Orientation.portrait) {
                          SystemChrome.setPreferredOrientations(
                              [DeviceOrientation.landscapeLeft]);
                        } else {
                          SystemChrome.setPreferredOrientations(
                              [DeviceOrientation.portraitUp]);
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.h8),
                      child: Icon(
                        Icons.flip,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: size.height - 210,
                child: Expanded(
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.zero,
                                height: Dimensions.h35,
                                width: Dimensions.h200,
                                decoration:
                                    BoxDecoration(color: AppColors.wpColor1),
                                child: const Center(
                                    child: Text("Transaction Date")),
                              ),
                              SizedBox(
                                width: Dimensions.w2,
                              ),
                              Container(
                                padding: EdgeInsets.zero,
                                height: Dimensions.h35,
                                width: Dimensions.h200,
                                decoration:
                                    BoxDecoration(color: AppColors.wpColor1),
                                child: const Center(child: Text("Perticulars")),
                              ),
                              SizedBox(
                                width: Dimensions.w2,
                              ),
                              Container(
                                padding: EdgeInsets.zero,
                                height: Dimensions.h35,
                                width: Dimensions.h200,
                                decoration:
                                    BoxDecoration(color: AppColors.wpColor1),
                                child: const Center(
                                    child: Text("Previous Amount")),
                              ),

                              SizedBox(
                                width: Dimensions.w2,
                              ),
                              Container(
                                padding: EdgeInsets.zero,
                                height: Dimensions.h35,
                                width: Dimensions.h200,
                                decoration:
                                    BoxDecoration(color: AppColors.wpColor1),
                                child: const Center(
                                    child: Text("Transaction Amount")),
                              ),

                              // SizedBox(
                              //   width: Dimensions.w2,
                              // ),
                              // Amount(text: "Current Amount"),
                            ],
                          ),
                          Container(
                            height: 510,
                            //  color: AppColors.appbarColor,
                            width: 1000,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount:
                                  homeController.passBookModelData.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var data = homeController.passBookModelData
                                    .elementAt(index);
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Container(
                                            padding: EdgeInsets.zero,
                                            height: Dimensions.h40,
                                            width: Dimensions.w210,
                                            decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 2,
                                                    spreadRadius: 0.2,
                                                    offset: Offset(0, 2),
                                                    color: AppColors.grey,
                                                  )
                                                ]),
                                            child: Center(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                CommonUtils()
                                                    .formatStringToDDMMYYYYHHMMA(
                                                  data.createdAt.toString(),
                                                ),
                                              ),
                                            )),
                                          ),
                                        ),
                                        SizedBox(
                                          width: Dimensions.w2,
                                        ),
                                        Amount(
                                            text:
                                                "${data.transactionType} (${data.marketOpenTime} : ${data.modeName} : ${data.bidType}) : ${data.id}"),
                                        SizedBox(
                                          width: Dimensions.w2,
                                        ),
                                        Amount(
                                            text:
                                                data.previousAmount.toString()),
                                        SizedBox(
                                          width: Dimensions.w2,
                                        ),
                                        Amount(
                                          text: data.balance.toString(),
                                        ),
                                        // SizedBox(
                                        //   width: Dimensions.w2,
                                        // ),
                                        // Amount(text: "Current Amount"),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  BottomPage(text: "PREVIOUS"),
                  verticalSpace,
                  BottomPage(text: "(1/0)"),
                  verticalSpace,
                  BottomPage(text: "NEXT"),
                ],
              ),
            ),
          )
          // const Expanded(child: SizedBox()),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Padding(
          //     padding: EdgeInsets.all(Dimensions.h5),
          //     child: Row(
          //       children: [],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class BottomPage extends StatelessWidget {
  BottomPage({super.key, required this.text});
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.h35,
      width: Dimensions.w120 - 4,
      decoration: BoxDecoration(
          color: AppColors.wpColor1,
          borderRadius: BorderRadius.circular(Dimensions.r5)),
      child: Center(
        child: Text(
          text,
          style: CustomTextStyle.textRobotoSansLight.copyWith(
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}

//  ignore: must_be_immutable
class Amount extends StatelessWidget {
  Amount({super.key, required this.text});
  String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Container(
        height: Dimensions.h40,
        width: Dimensions.w210,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                spreadRadius: 0.2,
                offset: Offset(0, 2),
                color: AppColors.grey,
              )
            ]),
        child: Center(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                text,
                style: CustomTextStyle.textRobotoSansLight
                    .copyWith(color: AppColors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
