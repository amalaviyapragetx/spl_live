import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/models/market_bid_history.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../../../api_services/api_service.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/get_feedback_by_id_api_response_model.dart';
import '../../../models/normal_market_bid_history_response_model.dart';

class MoreListController extends GetxController {
  UserDetailsModel userData = UserDetailsModel();
  RxList<ResultArr> marketHistoryList = <ResultArr>[].obs;
  RxList<MarketBidHistoryList> marketBidHistoryList = <MarketBidHistoryList>[].obs;
  RxBool isStarline = false.obs;
  int offset = 0;
  RxString walletBalance = "00".obs;
  double ratingValue = 0.00;
  RxBool isSharing = false.obs;
  DateTime startEndDate = DateTime.now();
  @override
  void onInit() {
    getUserData();
    walletBalance.refresh();
    getUserBalance();
    walletBalance.refresh();
    getMarketBidsByUserId(
        lazyLoad: false,
        endDate: DateFormat('yyyy-MM-dd').format(startEndDate),
        startDate: DateFormat('yyyy-MM-dd').format(startEndDate));
    super.onInit();
  }

  @override
  void dispose() {
    marketHistoryList.clear();
    // scrollController.removeListener(_scrollListner);
    // scrollController.dispose();
    super.dispose();
  }

  Future<void> getUserData() async {
    userData = UserDetailsModel.fromJson(GetStorage().read(ConstantsVariables.userData));
    // getMarketBidsByUserId(lazyLoad: false);
  }

  void callLogout() async {
    ApiService().logout().then((value) async {
      if (value['status']) {
        AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
        GetStorage().erase();
        Get.offAllNamed(AppRoutName.walcomeScreen);
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  void getUserBalance() {
    ApiService().getBalance().then((value) async {
      if (value['status']) {
        if (value['data'] != null) {
          var tempBalance = value['data']['Amount'] ?? 00;
          walletBalance.value = tempBalance.toString();
        }
      } else {
        AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
      }
    });
  }

  // Rate Controller
  var tempRatings = 0.00;
  String tempFeedBack = "";
  Future<void> getFeedbackAndRatingsById() async {
    ApiService().getFeedbackAndRatingsById(userId: userData.id).then(
      (value) async {
        if (value['status']) {
          var feedbackModel = GetFeedbackByIdApiResponseModel.fromJson(value);
          if (feedbackModel.data != null) {
            tempRatings =
                feedbackModel.data!.user!.appRating != null ? feedbackModel.data!.user!.appRating.toDouble() : 0.00;
            tempFeedBack = feedbackModel.data!.feedback.toString();
          } else {
            tempRatings = 0.00;
          }
        } else {
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        }
        if (tempRatings > 0.00) {
          AppUtils().showRateUsBoxDailog((rat) {
            addRating(rat);
          }, tempRatings);
        } else {
          AppUtils().showRateUsBoxDailog((rat) {
            addRating(rat);
          }, 0);
        }
      },
    );
  }

  Future<Map> createRatingBody(rating) async {
    final createFeedbackBody = {
      "userId": userData.id,
      "rating": rating,
    };
    return createFeedbackBody;
  }

  void addRating(ratingValue) async {
    ApiService().rateApp(await createRatingBody(ratingValue)).then((value) async {
      if (value['status']) {
        Get.back();
        AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  void toggleShare() {
    isSharing.value = !isSharing.value;
    if (isSharing.value) {
      Share.share("http://spl.live");
    }
  }

  void getMarketBidsByUserId({
    required bool lazyLoad,
    required String startDate,
    required String endDate,
  }) {
    ApiService()
        .getBidHistoryByUserId(
      userId: userData.id.toString(),
      startDate: startDate,
      endDate: endDate,
      limit: "5000",
      offset: offset.toString(),
      isStarline: false,
    )
        .then(
      (value) async {
        if (value['status']) {
          if (value['data'] != null) {
            NormalMarketBidHistoryResponseModel model = NormalMarketBidHistoryResponseModel.fromJson(value);
            lazyLoad
                ? marketBidHistoryList.addAll(model.data?.resultArr ?? <ResultArr>[])
                : marketBidHistoryList.value = model.data?.resultArr ?? <ResultArr>[];
          }
        } else {
          AppUtils.showErrorSnackBar(bodyText: value['message'] ?? "");
        }
      },
    );
  }
}
