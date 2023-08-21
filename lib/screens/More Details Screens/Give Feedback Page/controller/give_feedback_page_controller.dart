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

  @override
  void onInit() {
    super.onInit();
    getArguments();
  }

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

  getArguments() async {
    var data = await LocalStorage.read(ConstantsVariables.userData);
    userDetailsModel = UserDetailsModel.fromJson(data);
    print(userDetailsModel.toJson());
    getFeedbackAndRatingsById();
  }

  Future<Map> createFeedbackBody() async {
    final createFeedbackBody = {
      "userId": int.parse(userDetailsModel.id.toString()),
      "feedback": feedbackController.text,
      "rating": 0
    };
    debugPrint(createFeedbackBody.toString());
    return createFeedbackBody;
  }

  void getFeedbackAndRatingsById() async {
    ApiService()
        //.getFeedbackAndRatingsById(userId: int.parse(userId))
        .getFeedbackAndRatingsById(userId: userDetailsModel.id)
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
