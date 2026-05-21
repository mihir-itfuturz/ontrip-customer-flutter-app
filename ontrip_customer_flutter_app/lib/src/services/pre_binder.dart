import 'package:ontrip_customer_flutter_app/src/screens/auth/sign_in/sign_in_ctrl.dart';
import 'package:ontrip_customer_flutter_app/src/screens/vendor/home/vendor_home_ctrl.dart';

import '../../app_export.dart';

class PreBinder extends Bindings {
  @override
  void dependencies() => preBinderControllers();
}

void preBinderControllers() {
  Get.put(SplashCtrl());
  Get.put(MasterController(), permanent: true);
  Get.put(AuthenticationController(), permanent: true);
  Get.put(SignInCtrl(), permanent: true);
  // VendorHomeCtrl must be registered before DashboardCtrl so it's available
  // when DashboardCtrl.currentScreen() builds VendorHomeScreen on hot restart.
  Get.put(VendorHomeCtrl(), permanent: true);
  Get.put(DashboardCtrl(), permanent: true);
  Get.put(HomeController(), permanent: true);
  Get.put(CommunityCtrl(), permanent: true);
  Get.put(HistoryCtrl(), permanent: true);
  Get.put(SettingsCtrl(), permanent: true);
}
