import 'dart:io';

import 'package:get/get.dart';
import 'package:spllive/models/commun_models/user_details_model.dart';

class MyProfilePageController extends GetxController {
  UserDetailsModel userDetailsModel = UserDetailsModel();
  RxBool value = true.obs;
  File? myimagepath;
  void navigateTo(context, routeString) {
    Get.toNamed(routeString);
  }

  void toggleValue(bool newValue) {
    value.value = newValue;
  }

  // imageSelection() async {
  //   try {
  //     final imagetemp = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (imagetemp == null) return;
  //     final imagelocation = File(imagetemp.path);
  //     myimagepath = imagelocation;
  //   } on PlatformException catch (e) {
  //     if (kDebugMode) {
  //       print("Failed to Select Image $e");
  //     }
  //   }
  // }
}
