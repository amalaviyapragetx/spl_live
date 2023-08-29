import 'package:get/get.dart';

import '../../../helper_files/constant_variables.dart';
import '../../Local Storage.dart';

class WelcomeScreenController extends GetxController {
  @override
  void onInit() async {
    await LocalStorage.write(ConstantsVariables.timeOut, false);
    super.onInit();
  }
}
