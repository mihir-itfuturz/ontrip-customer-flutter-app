
import '../../../app_export.dart';

class DashboardCtrl extends GetxController {
  AuthenticationController service = Get.find();

  final RxBool cardScanner = true.obs;

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
        return const HistoryScreen();
      case 2:
        return const CommunityScreen();
      case 3:
        return const SettingsScreen();
      default:
        return const HomeScreen();
    }
  }
}
