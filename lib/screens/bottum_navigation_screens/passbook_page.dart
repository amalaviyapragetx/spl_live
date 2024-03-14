import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spllive/Custom%20Controllers/wallet_controller.dart';
import 'package:spllive/controller/home_controller.dart';
import 'package:spllive/controller/passbook_controller.dart';
import 'package:spllive/helper_files/constant_image.dart';
import 'package:spllive/helper_files/ui_utils.dart';

import '../../helper_files/app_colors.dart';
import '../../helper_files/common_utils.dart';
import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';
import 'controller/bottum_navigation_controller.dart';

class PassBook extends StatefulWidget {
  PassBook({super.key});

  @override
  State<PassBook> createState() => _PassBookState();
}

class _PassBookState extends State<PassBook> {
  final homeController = Get.find<HomeController>();
  final controller = Get.put(MoreListController());
  final walletCon = Get.find<WalletController>();
  final passBookCon = Get.find<PassbookHistoryController>();

  @override
  void initState() {
    super.initState();
    passBookCon.getPassBookData(lazyLoad: false, offset: "0");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppUtils().simpleAppbar(
          appBarTitle: "",
          leadingWidht: 900,
          leading: SizedBox(
            child: Row(
              children: [
                SizedBox(width: Dimensions.w15),
                SvgPicture.asset(
                  ConstantImage.walletAppbar,
                  height: 25,
                  width: 30,
                  color: AppColors.white,
                ),
                SizedBox(width: Dimensions.w5),
                GetBuilder<WalletController>(
                  builder: (con) => Text(
                    con.walletBalance.value,
                    style: CustomTextStyle.textRobotoSansMedium.copyWith(
                      fontSize: Dimensions.h16,
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.w10),
                Center(
                  child: Text(
                    "Passbook",
                    style: CustomTextStyle.textRobotoSansMedium.copyWith(
                      fontSize: Dimensions.h20,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                SizedBox(width: Dimensions.w80),
                GestureDetector(
                  onTap: () {
                    if (homeController.pageWidget.value == 3) {
                      if (MediaQuery.of(context).orientation == Orientation.portrait) {
                        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                      } else {
                        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                      }
                    } else {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);
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
        Obx(
          () => passBookCon.passBookModelData.isNotEmpty
              ? Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: table(),
                    ),
                  ),
                )
              : Expanded(
                  child: Center(
                    child: Text(
                      "There is no data",
                      style: TextStyle(color: AppColors.black),
                    ),
                  ),
                ),
        ),
        Obx(
          () => passBookCon.passBookModelData.isNotEmpty
              ? Row(
                  children: [
                    pageWidget(
                      "previous",
                      onTap: () => passBookCon.prevPage(),
                    ),
                    pageWidget(
                      "(${passBookCon.offset} / ${passBookCon.calculateTotalPages().toString()})",
                    ),
                    pageWidget(
                      "NEXT",
                      onTap: () => passBookCon.nextPage(),
                    ),
                  ],
                )
              : Container(),
        )
      ],
    );
  }

  Expanded pageWidget(String text, {Function()? onTap}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: Dimensions.h35,
            decoration: BoxDecoration(
              color: AppColors.wpColor1,
            ),
            child: Center(
              child: Text(
                text.toUpperCase(),
                style: CustomTextStyle.textRobotoSansMedium.copyWith(
                  color: AppColors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  table() {
    print(passBookCon.passBookModelData.toJson());

    return Obx(
      () => passBookCon.passBookModelData.isNotEmpty
          ? DataTable(
              headingRowHeight: Dimensions.h45,
              dataRowHeight: Dimensions.h35,
              horizontalMargin: 0,
              decoration: BoxDecoration(color: AppColors.white),
              // columnSpacing: 30,
              columns: [
                dataColumns(
                  text: "Transaction Date",
                  width: Dimensions.w170,
                ),
                dataColumns(
                  text: "Particulers",
                  width: 420,
                ),
                dataColumns(
                  text: "Previous Amount",
                  width: Dimensions.w150,
                ),
                dataColumns(text: "Transaction Amount", width: Dimensions.w150),
                dataColumns(text: "Current Amount", width: Dimensions.w150),
              ],
              columnSpacing: 1,

              rows: List.generate(
                passBookCon.passBookModelData.length,
                (index) {
                  var data = passBookCon.passBookModelData.elementAt(index);

                  return DataRow(cells: [
                    dataCells(
                      width: Dimensions.w170,
                      textColor: AppColors.black,
                      text: CommonUtils().convertUtcToIstFormatStringToDDMMYYYYHHMMA(
                        data.createdAt.toString(),
                      ),
                    ),
                    dataCells(
                        width: 420,
                        textColor: AppColors.black,
                        text: data.transactionType != "Bid"
                            ? "${data.remarks}"
                            : data.marketName == null
                                ? "${data.transactionType ?? ""} (STARLINE : ${CommonUtils().formatStringToHHMMA(data.marketTime ?? "")} : ${data.modeName ?? ""} ) : ${data.bidNo} "
                                : "${data.transactionType ?? ""} ( ${data.marketName ?? ""} :  ${data.modeName ?? ""} : ${data.bidType ?? ""} ) : ${data.bidNo ?? ""}"),
                    dataCells(
                      width: Dimensions.w150,
                      textColor: AppColors.black,
                      text: data.previousAmount.toString(),
                    ),
                    dataCells(
                        width: Dimensions.w150,
                        textColor: data.credit == "" || data.credit == "null" || data.credit == null
                            ? AppColors.redColor
                            : AppColors.green,
                        text: data.credit == "" || data.credit == null
                            ? "-${data.debit.toString()}"
                            : "+${data.credit.toString()}"),
                    dataCells(
                      width: Dimensions.w150,
                      textColor: AppColors.black,
                      text: data.balance.toString(),
                    ),
                  ]);
                },
              ).toList(),
              showBottomBorder: true,
            )
          : Container(),
    );
  }

  DataColumn dataColumns({required String text, required double width}) {
    return DataColumn(
      label: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: Dimensions.h45,
          width: width,
          decoration: BoxDecoration(
            color: AppColors.wpColor1,
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                spreadRadius: 0.2,
                offset: const Offset(0, 2),
                color: AppColors.grey,
              )
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: CustomTextStyle.textRobotoSansMedium,
            ),
          ),
        ),
      ),
      numeric: true,
    );
  }

  DataCell dataCells({required String text, required Color textColor, required double width}) {
    return DataCell(
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: Dimensions.h30,
          width: width,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                spreadRadius: 0.2,
                offset: const Offset(0, 2),
                color: AppColors.grey,
              )
            ],
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: CustomTextStyle.textRobotoSansMedium.copyWith(color: textColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
