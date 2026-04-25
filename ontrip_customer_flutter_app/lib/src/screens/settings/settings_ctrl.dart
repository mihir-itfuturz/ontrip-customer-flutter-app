import '../../../../app_export.dart';

class SettingsCtrl extends GetxController {
  final AuthenticationController authService = Get.find();
  var isNotificationEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    authService.fetchProfile();
    isNotificationEnabled.value = GetStorage().read(StringConstants.notificationEnabled) ?? true;
  }

  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
    GetStorage().write(StringConstants.notificationEnabled, value);
  }

  void navigateToEditProfile() {
    Get.toNamed(RouteNames.editProfile);
  }

  void logout() {
    openGetDialog(LogoutDialog());
  }

  void deleteAccount() {
    openGetDialog(DeleteAccountDialog());
  }

  void openTermsAndConditions() {
    // Open URL or Navigate
    AppUrl.urlLaunch(url: StringConstants.privacyPolicy);
  }

  void openPrivacyPolicy() {
    // Open URL or Navigate
    AppUrl.urlLaunch(url: StringConstants.privacyPolicy);
  }
}
