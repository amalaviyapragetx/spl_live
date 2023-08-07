import 'package:flutter/material.dart';
import 'package:spllive/helper_files/ui_utils.dart';

import '../../helper_files/custom_text_style.dart';
import '../../helper_files/dimentions.dart';

class PassBook extends StatelessWidget {
  const PassBook({super.key});

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
            leadingWidht: Dimensions.w200,
            leading: Container(
              child: Row(
                children: [
                  SizedBox(width: Dimensions.w15),
                  Text(
                    "Passbook",
                    style: CustomTextStyle.textRobotoSansMedium
                        .copyWith(fontSize: Dimensions.h20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
