import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../Custom Controllers/wallet_controller.dart';
import '../../../../api_services/api_service.dart';
import '../../../../helper_files/constant_variables.dart';
import '../../../../helper_files/ui_utils.dart';
import '../../../../models/bank_details_model.dart';
import '../../../../models/commun_models/user_details_model.dart';

class WithdrawalPageController extends GetxController {
  var userId = "";
  var walletbalance = Get.put(WalletController());
  @override
  void onInit() {
    fetchStoredUserDetailsAndGetBankDetailsByUserId();
    super.onInit();
  }

  Future<void> fetchStoredUserDetailsAndGetBankDetailsByUserId() async {
    final data = GetStorage().read(ConstantsVariables.userData);
    UserDetailsModel userData = UserDetailsModel.fromJson(data);
    userId = userData.id == null ? "" : userData.id.toString();
    if (userId.isNotEmpty) {
      callGetBankDetails();
      walletbalance.refresh();
    } else {
      AppUtils.showErrorSnackBar(bodyText: "SOMETHINGWENTWRONG".tr);
    }
  }

  void callGetBankDetails() async {
    ApiService().getBankDetails().then((value) async {
      if (value['status']) {
        BankDetailsResponseModel model = BankDetailsResponseModel.fromJson(value);
        if (model.message!.isNotEmpty) {
          AppUtils.showSuccessSnackBar(bodyText: model.message, headerText: "SUCCESSMESSAGE".tr);
        }
        // isEditDetails.value = model.data!.isEditPermission ?? false;
        // accountName.value = model.data!.accountHolderName ?? "";
        // bankName.value = model.data!.bankName ?? "";
        // accountNumber.value = model.data!.accountNumber ?? "";
        // ifcsCode.value = model.data!.iFSCCode ?? "";
        // bankNameController.text = model.data!.bankName ?? "Null From API";
        // accHolderNameController.text =
        //     model.data!.accountHolderName ?? "Null From API";
        // accNoController.text = model.data!.accountNumber ?? "Null From API";
        // ifscCodeController.text = model.data!.iFSCCode ?? "Null From API";
        // // gPayNumberController.text = model.data!.gpayNumber ?? "Null From API";
        // // paytmNumberController.text = model.data!.paytmNumber ?? "Null From API";
        // // bhimUpiController.text = model.data!.bhimUPI ?? "Null From API";
        // bankId = model.data!.id ?? 0;
      } else {
        // isEditDetails.value = true;
        AppUtils.showErrorSnackBar(
          bodyText: value['message'] ?? "",
        );
      }
    });
  }
}
