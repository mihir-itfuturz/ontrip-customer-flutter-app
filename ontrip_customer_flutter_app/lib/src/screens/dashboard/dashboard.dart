import 'package:ontrip_customer_flutter_app/src/screens/dashboard/dashboard_ctrl.dart';

import '../../../app_export.dart';

class DashboardScreen extends GetView<DashboardCtrl> {
  const DashboardScreen({super.key});

  Future<bool> _onWillPop() async {
    return await Get.dialog<bool>(
          AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            backgroundColor: Colors.white,
            elevation: 32,
            shadowColor: Colors.black.withValues(alpha: 0.15),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.red.shade50, Colors.red.shade100], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(Icons.exit_to_app_rounded, color: Colors.red.shade500, size: 26),
                ),
                const SizedBox(width: 18),
                const Text(
                  'Exit App',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A), letterSpacing: -0.5),
                ),
              ],
            ),
            content: const Text(
              'Are you sure you want to exit the application?',
              style: TextStyle(fontSize: 16, color: Color(0xFF666666), height: 1.6, letterSpacing: 0.2),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF666666), fontWeight: FontWeight.w600, fontSize: 16, letterSpacing: 0.3),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back(result: true);
                  SystemNavigator.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade500,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 25),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text('Exit', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 0.3)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardCtrl>(
      init: DashboardCtrl(),
      builder: (ctrl) {
        return WillPopScope(
          onWillPop: () async {
            if (ctrl.currentIndex == 0) {
              return await _onWillPop();
            } else {
              ctrl.onTapForBottomNavBar(ctrl.currentIndex - 1);
              return false;
            }
          },
          child: Scaffold(
            extendBody: true,
            backgroundColor: const Color(0xFFF8FAFC),
            bottomNavigationBar: Obx(() {
              if (ctrl.cardScanner.value == false) {
                return SizedBox.shrink();
              }
              return Text('Dash Board');
              // CustomBottomNavBar(currentIndex: ctrl.currentIndex, onTabChange: ctrl.onTapForBottomNavBar);
            }),
            body: ctrl.currentScreen(),
          ),
        );
      },
    );
  }
}
