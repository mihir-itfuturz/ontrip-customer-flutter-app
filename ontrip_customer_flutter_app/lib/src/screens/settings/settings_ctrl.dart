import 'package:ontrip_customer_flutter_app/src/screens/auth/authentication_controller.dart';

import '../../../../app_export.dart';

class SettingsCtrl extends GetxController {
  final AuthenticationController authService = Get.find();

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
