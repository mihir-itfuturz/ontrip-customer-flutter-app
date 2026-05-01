import 'package:ontrip_customer_flutter_app/app_export.dart';

class AuthenticationController extends GetxService {
  Future<AuthenticationController> init() async => this;

  final RxMap<String, dynamic> userAuthData = <String, dynamic>{}.obs;

  final loginList = <dynamic>[].obs;

  Future<void> fetchProfile() async {
    try {
      final response = await ApiManager.call(
        endPoint: BACKEND.profileUpdate,
        type: ApiType.get,
      );

      if (response.status == 1 || response.status == 200) {
        if (response.data != null && response.data['customer'] != null) {
          userAuthData.assignAll(response.data['customer']);
        }
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }
  }
}
