import 'dart:io';
import 'dart:async';
import '../../../../../app_export.dart';

class HomeController extends GetxController {
  bool isLoading = false;

  String token = "";

  @override
  void onInit() {
    Future.delayed(Duration.zero, () async {
      if (await _hasInternetConnection()) {
        await initialize();
      }
    });
    super.onInit();
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> initialize() async {
    try {
      token = getStorage(AppSession.token) ?? "";
    } finally {}
  }
}
