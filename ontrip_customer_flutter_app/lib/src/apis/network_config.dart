import '../../app_export.dart';

enum RunEnvironment { local, live }

class AppNetworkConstants {
  static final _masterCtrl = Get.find<MasterController>();

  static Map<String, String> _env({required bool isLive}) {
    if (isLive) return _masterCtrl.liveEnvJson;
    return _masterCtrl.localEnvJson;
  }

  static Map<String, String> get _envJson => _env(isLive: true);

  static final apiBaseURL = _envJson['mobile_base_url']!;
  static final baseURL = _envJson['image_url']!;
}
