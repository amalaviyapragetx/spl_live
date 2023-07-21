import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:spllive/helper_files/ui_utils.dart';

import '../../../../api_services/api_service.dart';
import '../../../../helper_files/constant_variables.dart';
import '../../../../models/commun_models/user_details_model.dart';
import '../../../../models/get_feedback_by_id_api_response_model.dart';
import '../../../Local Storage.dart';

class GiveFeedbackPageController extends GetxController {
  final feedbackController = TextEditingController();
  var feedbackModel = GetFeedbackByIdApiResponseModel().obs;
  UserDetailsModel userDetailsModel = UserDetailsModel();
  var userId = "1";
  @override
  void onInit() {
    super.onInit();
    getFeedbackAndRatingsById();
  }

  @override
  void onClose() {}

  @override
  void onReady() {}

  void addFeedbackApi() async {
    ApiService().createFeedback(await createFeedbackBody()).then((value) async {
      debugPrint("Create Feedback Api Response :- $value");
      if (value['status']) {
        Get.back();
        AppUtils.showSuccessSnackBar(
            bodyText: value['message'] ?? "", headerText: "SUCCESSMESSAGE".tr);
      } else {
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }

  Future<Map> createFeedbackBody() async {
    final createFeedbackBody = {
      "userId": int.parse(userId),
      "feedback": feedbackController.text,
      "rating": 0
    };
    debugPrint(createFeedbackBody.toString());
    return createFeedbackBody;
  }

  void getFeedbackAndRatingsById() async {
    var data = await LocalStorage.read(ConstantsVariables.userData);
    // UserDetailsModel userData = UserDetailsModel.fromJson(data);
    // userId = userData.id == null ? "" : userData.id.toString();
    ApiService()
        .getFeedbackAndRatingsById(userId: int.parse(userId))
        //  .getFeedbackAndRatingsById(userId: userDetailsModel.id)
        .then(
      (value) async {
        debugPrint("Get StarLine Daily Markets Api Response :- $value");
        if (value['status']) {
          feedbackModel.value = GetFeedbackByIdApiResponseModel.fromJson(value);
          feedbackController.text = feedbackModel.value.data!.feedback ?? "";
        } else {
          AppUtils.showErrorSnackBar(
            bodyText: value['message'] ?? "",
          );
        }
      },
    );
  }
}
