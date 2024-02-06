import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spllive/api_services/api_service.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/market_bid_history.dart';
import 'package:spllive/utils/constant.dart';

class BidHistoryController extends GetxController {
  RxList<MarketBidHistoryList> marketBidHistoryList = <MarketBidHistoryList>[].obs;

  void marketBidsByUserId({required bool lazyLoad}) {
    ApiService().bidHistoryByUserId(userId: "${GetStorage().read(ConstantsVariables.id) ?? ""}").then(
      (value) async {
        if (value['status']) {
          if (value['data'] != null) {
            MarketBidHistory model = MarketBidHistory.fromJson(value['data']);

            lazyLoad
                ? marketBidHistoryList.addAll(model.rows ?? <MarketBidHistoryList>[])
                : marketBidHistoryList.value = model.rows ?? <MarketBidHistoryList>[];
          }
          marketBidHistoryList.refresh();
        } else {
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        }
      },
    );
  }
}
