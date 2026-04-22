import 'dart:developer';

import '../../../app_export.dart';

class SplashCtrl extends GetxController {
  @override
  void onInit() {
    log("SplashCtrl: onInit called");
    onNavigate();
    super.onInit();
  }

  // final _controller = Get.find<MemberSelectionCtrl>();

  Future<void> onNavigate() async {
    log ("SplashCtrl: onNavigate called");
    Future.delayed(const Duration(seconds: 3), () async {
      log("SplashCtrl: Timer finished, checking token");
      try {
        final token = getStorage(AppSession.token);
        log("SplashCtrl: Token retrieved: $token");
        if (token != null) {
          log("SplashCtrl: Navigating to dashboard");
          pushNRemoveUntil(path: RouteNames.dashboard);
          return;
        } else {
          log("SplashCtrl: Navigating to sign in");
          pushNRemoveUntil(path: RouteNames.signIn);
          return;
        }
      } catch (e) {
        log("SplashCtrl: Error in onNavigate: $e");
        pushNRemoveUntil(path: RouteNames.signIn);
      }
    });
  }
}
