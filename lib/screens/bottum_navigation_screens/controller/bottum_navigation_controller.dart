import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spllive/helper_files/ui_utils.dart';
import 'package:spllive/routes/app_routes_name.dart';

import '../../../api_services/api_service.dart';
import '../../../helper_files/constant_variables.dart';
import '../../../models/commun_models/user_details_model.dart';
import '../../../models/get_feedback_by_id_api_response_model.dart';
import '../../../models/normal_market_bid_history_response_model.dart';
import '../../Local Storage.dart';

class MoreListController extends GetxController {
  UserDetailsModel userData = UserDetailsModel();
  RxList<ResultArr> marketHistoryList = <ResultArr>[].obs;
  RxBool isStarline = false.obs;
  int offset = 0;
  RxString walletBalance = "00".obs;
  double ratingValue = 0.00;
  RxBool isSharing = false.obs;
  @override
  void onInit() {
    getUserData();
    walletBalance.refresh();
    getUserBalance();
    walletBalance.refresh();
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
    var data = await LocalStorage.read(ConstantsVariables.userData);
    userData = UserDetailsModel.fromJson(data);
    // getMarketBidsByUserId(lazyLoad: false);
  }

  void callLogout() async {
    ApiService().logout().then((value) async {
      if (value['status']) {
        AppUtils.showSuccessSnackBar(bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
        // var deviceToken = GetStorage().read(ConstantsVariables.fcmToken);
        // var locationData1 = GetStorage().read(ConstantsVariables.locationData);
        GetStorage().erase();
        // GetStorage().write(ConstantsVariables.fcmToken, deviceToken);
        // GetStorage().write(ConstantsVariables.locationData, locationData1);
        Get.offAllNamed(AppRoutName.walcomeScreen);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  void getMarketBidsByUserId({required bool lazyLoad}) {
    ApiService()
        .getBidHistoryByUserId(
            userId: userData.id.toString(),
            endDate: "2023-08-17",
            startDate: "2023-08-17",
            //  userId: "3",
            limit: "10",
            offset: offset.toString(),
            isStarline: isStarline.value)
        .then(
      (value) async {
        if (value['status']) {
          if (value['data'] != null) {
            NormalMarketBidHistoryResponseModel model = NormalMarketBidHistoryResponseModel.fromJson(value);
            lazyLoad
                ? marketHistoryList.addAll(model.data?.resultArr ?? <ResultArr>[])
                : marketHistoryList.value = model.data?.resultArr ?? <ResultArr>[];
          }
        } else {
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        }
      },
    );
  }

  void getUserBalance() {
    ApiService().getBalance().then((value) async {
      if (value['status']) {
        if (value['data'] != null) {
          var tempBalance = value['data']['Amount'] ?? 00;
          walletBalance.value = tempBalance.toString();
        }
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  // Rate Controller
  void onTapOfRateUs() async {
    await getFeedbackAndRatingsById();
  }

  Future<void> getFeedbackAndRatingsById() async {
    var tempRatings = 0.00;
    var tempFeedBack = "";
    ApiService()
        //.getFeedbackAndRatingsById(userId: 1)
        .getFeedbackAndRatingsById(userId: userData.id)
        .then(
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

  // void addFeedbackApi(ratingValue, feedBack) async {
  //   ApiService()
  //       .createFeedback(await createFeedbackBody(ratingValue, feedBack))
  //       .then((value) async {
  //     debugPrint("Create Feedback Api Response :- $value");
  //     if (value['status']) {
  //       Get.back();
  //       AppUtils.showSuccessSnackBar(
  //           bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
  //     } else {
  //       AppUtils.showErrorSnackBar(
  //         bodyText: value['message'] ?? "",
  //       );
  //     }
  //   });
  // }

  // Future<Map> createFeedbackBody(rating, String? feedBack) async {
  //   final createFeedbackBody = {
  //     "userId": userData.id,
  //     "feedback": feedBack,
  //     "rating": rating,
  //   };
  //   debugPrint(createFeedbackBody.toString());
  //   return createFeedbackBody;
  // }
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
}
