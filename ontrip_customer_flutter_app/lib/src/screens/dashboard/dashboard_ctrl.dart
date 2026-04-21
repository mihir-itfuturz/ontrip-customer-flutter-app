import 'package:ontrip_customer_flutter_app/src/screens/auth/authentication_controller.dart';

import '../../../app_export.dart';

class DashboardCtrl extends GetxController {
  AuthenticationController service = Get.find();
  BusinessCardModel? businessCardModel;
  final RxBool cardScanner = false.obs;

  @override
  void onInit() {
    Future.delayed(Duration.zero, () async {});
    super.onInit();
  }

  int currentIndex = 0;

  bool checkLock() {
    try {
      final subs = businessCardModel?.subscription ?? [];
      final activeProducts = subs.where((e) => e.isActive == true).map((e) => e.product).toSet();
      if (activeProducts.isNotEmpty && !activeProducts.contains("card-scanner")) {
        return true;
      } else if (activeProducts.isEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      errorToast("Failed to read environment");
    }
    return false;
  }

  void onTapForBottomNavBar(int index) {
    if (checkLock() == true && index != 0) {
      warningToast("This product is not assigned you contact administration!");
      return;
    }
    currentIndex = index;
    if (index == 2 && Get.isRegistered<DashboardCtrl>()) {}
    update();
  }

  Widget currentScreen() {
    switch (currentIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return HomeScreen();
      case 2:
        return HomeScreen();
      case 3:
        return HomeScreen();
      default:
    }
    return SizedBox.shrink();
  }
}
