import 'package:ontrip_customer_flutter_app/src/screens/auth/authentication_controller.dart';

import '../../../app_export.dart';

class DashboardCtrl extends GetxController {
  AuthenticationController service = Get.find();

  final RxBool cardScanner = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  int currentIndex = 0;

  bool checkLock() {
    return false; // Temporarily disable lock to ensure everything is visible
  }

  void onTapForBottomNavBar(int index) {
    currentIndex = index;
    update();
  }

  Widget currentScreen() {
    switch (currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const HomeScreen();
      case 2:
        return const HomeScreen();
      case 3:
        return const HomeScreen();
      default:
        return const HomeScreen();
    }
  }
}
