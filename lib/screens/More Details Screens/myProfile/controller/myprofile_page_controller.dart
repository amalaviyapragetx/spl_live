import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../models/commun_models/user_details_model.dart';

class MyProfilePageController extends GetxController {
  Rx<UserDetailsModel> userDetailsModel = UserDetailsModel().obs;
  RxBool value = true.obs;
  File? myimagepath;

  void navigateTo(context, routeString) {
    Get.toNamed(routeString);
  }

  // @override
  // void onInit() {
  //   //fetchSavedData();
  //   super.onInit();
  // }

  void toggleValue(bool newValue) {
    value.value = newValue;
  }

  // Future<void> fetchSavedData() async {
  //   var userData = GetStorage().read(ConstantsVariables.userData);
  //   userDetailsModel = UserDetailsModel.fromJson(userData);
  //   print("Get User Data ***********************${userDetailsModel.toJson()}");
  // }

  imageSelection() async {
    try {
      final imagetemp = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagetemp == null) return;
      final imagelocation = File(imagetemp.path);
      myimagepath = imagelocation;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to Select Image $e");
      }
    }
  }
}
