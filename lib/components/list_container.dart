import 'package:flutter/material.dart';

import '../helper_files/app_colors.dart';
import '../helper_files/dimentions.dart';

class ListContainer extends StatelessWidget {
  const ListContainer({
    super.key,
    required this.title,
    this.iconData,
    required this.color,
  });
  final String title;
  final IconData? iconData;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.h35,
      color: Colors.grey.withOpacity(0.1),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          iconData == null
              ? Container()
              : Icon(
                  iconData,
                  color: AppColors.appbarColor,
                ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
