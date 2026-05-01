import '../../../app_export.dart';
import 'pages/home/home.dart';
import '../history/history.dart';
import '../community/community.dart';
import '../settings/settings.dart';

class DashboardCtrl extends GetxController {
  AuthenticationController service = Get.find();

  final RxBool cardScanner = true.obs;
  final RxInt currentIndex = 0.obs;

  bool checkLock() {
    return false; // Temporarily disable lock to ensure everything is visible
  }

  @override
  void onInit() async {
    super.onInit();

    socketService.connectToServer();
  }

  void onTapForBottomNavBar(int index) {
    currentIndex.value = index;
    update();
  }

  Widget currentScreen() {
    switch (currentIndex.value) {
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
