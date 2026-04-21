import '../../../app_export.dart';

class SplashCtrl extends GetxController {
  @override
  void onInit() {
    print("SplashCtrl: onInit called");
    onNavigate();
    super.onInit();
  }

  // final _controller = Get.find<MemberSelectionCtrl>();

  Future<void> onNavigate() async {
    print("SplashCtrl: onNavigate called");
    Future.delayed(const Duration(seconds: 3), () async {
      print("SplashCtrl: Timer finished, checking token");
      try {
        final token = getStorage(AppSession.token);
        print("SplashCtrl: Token retrieved: $token");
        if (token != null) {
          print("SplashCtrl: Navigating to dashboard");
          pushNRemoveUntil(path: RouteNames.dashboard);
          return;
        } else {
          print("SplashCtrl: Navigating to sign in");
          pushNRemoveUntil(path: RouteNames.signIn);
          return;
        }
      } catch (e) {
        print("SplashCtrl: Error in onNavigate: $e");
        pushNRemoveUntil(path: RouteNames.signIn);
      }
    });
  }
}
