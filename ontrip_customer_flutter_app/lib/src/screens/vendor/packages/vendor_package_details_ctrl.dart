import '../../../../app_export.dart';
import '../home/vendor_home_ctrl.dart';

class VendorPackageDetailsCtrl extends GetxController {
  final VendorPackage package = Get.arguments;
  RxInt selectedDay = 0.obs;

  void onDayChange(int index) {
    selectedDay.value = index;
    update();
  }
}
