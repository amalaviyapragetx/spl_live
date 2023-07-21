import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../helper_files/ui_utils.dart';

abstract class NetworkInfo {
  static Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      Get.closeAllSnackbars();
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      Get.closeAllSnackbars();
      return true;
    } else {
      if (connectivityResult == ConnectivityResult.none) {
        AppUtils.hideProgressDialog();
        AppUtils.showErrorSnackBar(bodyText: "No internet connection!");
        checkNetwork();
        return false;
      } else {
        return true;
      }
    }
  }
}
