import 'package:ontrip_customer_flutter_app/src/screens/dashboard/pages/home/home_controller.dart';
import '../../../../app_export.dart';

class VerifyOTPCtrl extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final isLoading = false.obs;
  String phone = "";

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      phone = Get.arguments['phone'] ?? "";
    }
  }

  Future<void> verifyOTP() async {
    if (otpController.text.length < 4) {
      warningToast("Please enter a valid OTP");
      return;
    }

    try {
      isLoading.value = true;
      final Map<String, dynamic> body = {"phone": phone, "otp": otpController.text.trim()};

      final response = await ApiManager.instance.call(endPoint: BACKEND.signIn, body: body);

      if (response.status == 1 || response.status == 200) {
        if (response.data != null) {
          await processAfterSignIn(response.data!);
        } else {
          errorToast("Authentication failed: No data received");
        }
      } else {
        errorToast(response.message);
      }
    } catch (e) {
      errorToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> processAfterSignIn(dynamic responseData) async {
    // Handling different token structures based on previous SignInCtrl logic
    String? token;
    if (responseData['tokens'] != null && responseData['tokens']["token"] != null) {
      token = responseData['tokens']["token"];
    } else if (responseData['token'] != null) {
      token = responseData['token'];
    }

    if (token != null) {
      await writeStorage(AppSession.token, token);
      Get.find<MasterController>().onInit();
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().initialize();
      }
      pushNRemoveUntil(path: RouteNames.dashboard);
    } else {
      errorToast("Token not found in response");
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
