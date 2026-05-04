import 'dart:async';
import 'dart:developer';

import '../../../../app_export.dart';

class VerifyOTPCtrl extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final List<TextEditingController> localOTPControllers = List.generate(4, (_) => TextEditingController());
  final isLoading = false.obs;
  final resendTimer = 30.obs;
  final canResend = false.obs;
  Timer? _timer;
  String phone = "";

  void updateOTPValue() {
    otpController.text = localOTPControllers.map((c) => c.text).join();
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      phone = Get.arguments['phone'] ?? "";
    }
    startResendTimer();
  }

  void startResendTimer() {
    canResend.value = false;
    resendTimer.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        canResend.value = true;
        _timer?.cancel();
      }
    });
  }

  Future<void> resendOTP() async {
    try {
      final Map<String, dynamic> sendJson = {"phone": phone};
      final response = await ApiManager.call(
        endPoint: BACKEND.sendOtp,
        body: sendJson,
      );
      if ((response.status == 1 || response.status == 200) &&
          response.success == true) {
        successToast("OTP Resent successfully");
        startResendTimer();
      } else {
        errorToast(response.message);
      }
    } catch (e) {
      errorToast(e.toString());
    }
  }

  Future<void> verifyOTP() async {
    if (otpController.text.length < 4) {
      warningToast("Please enter a valid OTP");
      return;
    }

    try {
      isLoading.value = true;
      String fcm = await notificationService.getToken() ?? "";
      log(fcm);
      final Map<String, dynamic> body = {
        "phone": phone,
        "otp": otpController.text.trim(),
        'fcmToken': fcm,
      };

      final response = await ApiManager.call(
        endPoint: BACKEND.signIn,
        body: body,
      );
      log('----------------------------------------response.data');
      log('=-=-=-=-=-= ${response.data}');
      if ((response.status == 1 || response.status == 200) &&
          response.success == true) {
        await processAfterSignIn(response.data!);
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
    if (responseData['tokens'] != null &&
        responseData['tokens']["token"] != null) {
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
    _timer?.cancel();
    otpController.dispose();
    for (var c in localOTPControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
