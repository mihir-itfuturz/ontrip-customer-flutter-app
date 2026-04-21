import 'package:ontrip_customer_flutter_app/src/screens/dashboard/pages/home/home_controller.dart';

import '../../../../app_export.dart';

class SignInCtrl extends GetxController {
  final TextEditingController txtEmailId = TextEditingController(), edtPassword = TextEditingController();
  final isPasswordHidden = true.obs, isLoadingForSignIn = false.obs;
  final selectedRole = 'member'.obs;
  bool isLoadingForLogout = false;

  void navigateToCreateAccount() => Get.toNamed(RouteNames.createAccount);

  Future signIn() async {
    try {
      isLoadingForSignIn.value = true;
      final inputValue = txtEmailId.text.trim();
      String clean = inputValue.replaceAll(RegExp(r'[\s\-()]'), '');
      // String fcm = await notificationService.getToken() ?? "";
      final Map<String, dynamic> sendJson = {"password": edtPassword.text.trim(), "fcm": 'fcm'};
      if (RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(inputValue)) {
        sendJson["emailId"] = inputValue;
      } else if (RegExp(r'^(?:\+91)?[6-9]\d{9}$').hasMatch(clean)) {
        String phone = clean.substring(clean.length - 10);
        sendJson["mobile"] = phone;
      }
      if (selectedRole.value == 'admin') {
        if (sendJson["emailId"] == null || sendJson["emailId"] == "") {
          if (sendJson["mobile"] == null || sendJson["mobile"] == "") {
            warningToast("Email-ID & Mobile number is required...!");
            return;
          }
        }
      } else {
        if (sendJson["emailId"] == null || sendJson["emailId"] == "") {
          warningToast("Email-ID is is required...!");
          return;
        }
      }
      final endpoint = BACKEND.signIn;
      final response = await ApiManager.instance.call(endPoint: endpoint, body: sendJson);
      if (response.data != null) {
        if (selectedRole.value != 'admin' && response.data["token"] != null && response.data["token"] != "") {
          await writeStorage(AppSession.token, response.data["token"]);
        }
        await processAfterSignInOrSignUp(response.data!);
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
    String role = responseData['user']?["role"] ?? "";
    if (selectedRole.value == 'admin' || role == "admin") {
      if (role == "admin") {
        responseData['tokens'] = {"token": responseData["taskUserToken"], "teamMemberToken": responseData["token"]};
      }
      final tokens = responseData['tokens'];
      await writeStorage(AppSession.token, tokens["token"]);
    } else {
      final token = responseData['token'];
      await writeStorage(AppSession.token, token);

      Get.find<MasterController>().onInit();
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().initialize();
      }
      pushNRemoveUntil(path: RouteNames.dashboard);
    }
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
    txtEmailId.dispose();
    edtPassword.dispose();
    super.onClose();
  }
}
