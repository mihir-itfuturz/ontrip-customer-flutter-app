import '../../app_export.dart';

class SplashBinder implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashCtrl(), fenix: true);
  }
}
