import 'package:ontrip_customer_flutter_app/src/screens/auth/authentication_controller.dart';
import 'package:ontrip_customer_flutter_app/src/screens/auth/sign_in/sign_in_ctrl.dart';
import 'package:ontrip_customer_flutter_app/src/screens/dashboard/dashboard_ctrl.dart';

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
  Get.put(DashboardCtrl(), permanent: true);
}
