import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spllive/components/simple_button_with_corner.dart';
import 'package:spllive/helper_files/app_colors.dart';
import 'package:spllive/helper_files/custom_text_style.dart';
import 'package:spllive/helper_files/dimentions.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/screens/home_screen/controller/homepage_controller.dart';

class AddFund extends StatefulWidget {
  AddFund({super.key});

  @override
  State<AddFund> createState() => _AddFundState();
}

class _AddFundState extends State<AddFund> {
  final homeCon = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        GetBuilder<HomePageController>(
          builder: (con) => Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(
              homeCon.tickets.length,
              (index) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    homeCon.tickets.forEach((element) => element["isSelected"] = false);
                    homeCon.addFundCon.text = homeCon.tickets[index]["text"];
                    homeCon.tickets[index]["isSelected"] = !homeCon.tickets[index]["isSelected"];
                    homeCon.update();
                  },
                  child: Container(
                    height: 40,
                    width: Get.width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: homeCon.tickets[index]["isSelected"]
                          ? AppColors.appbarColor
                          : AppColors.greywhite.withOpacity(0.55),
                    ),
                    child: Center(
                      child: Text(
                        "₹ ${homeCon.tickets[index]["text"]}",
                        style: CustomTextStyle.textGothamMedium.copyWith(
                          fontSize: 16,
                          color: homeCon.tickets[index]["isSelected"] ? AppColors.white : AppColors.black,
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
            onTap: () {
              // if (homeCon.addFundCon.text.isNotEmpty && int.parse(homeCon.addFundCon.text) >= 100) {
              if (homeCon.addFundCon.text.isNotEmpty) {
                homeCon.addFund(amount: homeCon.addFundCon.text);
                // } else if (int.parse(homeCon.addFundCon.text) < 100) {
                //   AppUtils.showErrorSnackBar(bodyText: "Please add minimum amount of ₹ 100");
              } else {
                AppUtils.showErrorSnackBar(bodyText: "Please enter amount");
              }
            },
            height: Dimensions.h35,
            width: Get.width / 2,
          ),
        ),
      ],
    );
  }
}
