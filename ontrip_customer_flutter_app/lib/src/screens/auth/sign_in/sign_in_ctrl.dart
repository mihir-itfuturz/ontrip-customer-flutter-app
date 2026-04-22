import 'dart:developer';
import '../../../../app_export.dart';

class SignInCtrl extends GetxController {
  final TextEditingController txtPhoneNumber = TextEditingController();
  final isLoadingForSignIn = false.obs;
  List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
  List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());
  bool isLoadingForLogout = false;

  void navigateToCreateAccount() => Get.toNamed(RouteNames.createAccount);

  String get otpCode => otpControllers.map((e) => e.text).join();

  Future signIn() async {
    try {
      isLoadingForSignIn.value = true;
      final inputValue = txtPhoneNumber.text.trim();
      if (inputValue.isEmpty) {
        warningToast("Mobile number is required");
        return;
      }
      String clean = inputValue.replaceAll(RegExp(r'[\s\-()]'), '');

      // ✅ Validate properly (Indian numbers)
      if (!RegExp(r'^(?:\+91)?[6-9]\d{9}$').hasMatch(clean)) {
        warningToast("Please enter a valid 10-digit mobile number");
        return;
      }
      String phone = clean.substring(clean.length - 10);
      String fcm = await notificationService.getToken() ?? "";
      log(fcm);
      final Map<String, dynamic> sendJson = {"phone": phone};

      final endpoint = BACKEND.sendOtp;
      final response = await ApiManager.instance.call(endPoint: endpoint, body: sendJson);
      if (response.status == 1 || response.status == 200) {
        successToast(response.message);
        Get.toNamed(RouteNames.verifyOTP, arguments: {"phone": phone});
      } else {
        errorToast(response.message);
      }
    } catch (e) {
      errorToast(e.toString());
    } finally {
      isLoadingForSignIn.value = false;
    }
  }

  Future<void> processAfterSignInOrSignUp(dynamic responseData) async {
    final tokens = responseData['tokens'];
    await writeStorage(AppSession.token, tokens["token"]);

    final token = responseData['token'];
    await writeStorage(AppSession.token, token);

    Get.find<MasterController>().onInit();
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().initialize();
    }
    pushNRemoveUntil(path: RouteNames.dashboard);
  }

  Future<bool> onLogout() async {
    isLoadingForLogout = true;
    update();
    await clearStorage();
    await Future.delayed(Duration(seconds: 2));
    final businessCardId = getStorage(AppSession.token);
    isLoadingForLogout = false;
    update();
    if (businessCardId == null || businessCardId.toString().isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> onDeleteAccount() async {
    try {
      isLoadingForLogout = true;
      update();
      final response = await ApiManager.instance.call(endPoint: BACKEND.deleteAccount);
      if (response.data != null && response.data == true) {
        backScreen();
        await clearStorage();
        await Get.deleteAll(force: true);
        preBinderControllers();
        pushNReplace(path: RouteNames.signIn);
        successToast('Account delete requested successfully');
      } else {
        errorToast("Failed to send account delete request");
      }
    } catch (e) {
      errorToast(e.toString());
    } finally {
      isLoadingForLogout = false;
      update();
    }
  }

  @override
  void onClose() {
    txtPhoneNumber.dispose();
    super.onClose();
  }
}
