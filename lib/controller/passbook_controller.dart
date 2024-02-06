import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/api_services/api_service.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/passbook_page_model.dart';
import 'package:spllive/utils/constant.dart';

class PassbookController extends GetxController {
  /// pass book
  final int itemLimit = 30;
  RxList<Rows> passBookModelData = <Rows>[].obs;
  RxInt passbookCount = 0.obs;
  RxInt offset = 0.obs;
  int calculateTotalPages() {
    var passbookValue = (passbookCount.value / itemLimit).ceil() - 1;
    var passbookValueZero = (passbookCount.value / itemLimit).ceil();
    if (passbookCount.value < 30) {
      return passbookValueZero;
    } else {
      return passbookValue;
    }
  }

  var num = 0;

  void nextPage() {
    if (offset.value < calculateTotalPages()) {
      ///  print("offset.value ${offset.value}");
      passBookModelData.clear();
      offset.value++;

      num = num + itemLimit;

      //  print("offset.value ${offset.value}");
      getPassBookData(lazyLoad: false, offset: num.toString());
      //  print("offset.value ${offset.value}");
      // passBookModelData.refresh();
      update();
    }
  }

  void prevPage() {
    if (offset.value > 0) {
      passBookModelData.clear();
      offset.value--;
      num = num - itemLimit;

      //print("offset.value ${offset.value}");
      getPassBookData(lazyLoad: false, offset: num.toString());
      // print("offset.value ${offset.value}");
      passBookModelData.refresh();
      update();
    }
  }

  void getPassBookData({required bool lazyLoad, required String offset}) {
    ApiService()
        .getPassBookData(
      userId: GetStorage().read(ConstantsVariables.id).toString(),
      isAll: true,
      limit: itemLimit.toString(),
      offset: offset.toString(),
    )
        .then((value) async {
      if (value['status']) {
        if (value['data'] != null) {
          PassbookModel model = PassbookModel.fromJson(value);
          passbookCount.value = int.parse(model.data!.count!.toString());
          passBookModelData.value = model.data?.rows ?? <Rows>[];
          passBookModelData.refresh();
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }
}
