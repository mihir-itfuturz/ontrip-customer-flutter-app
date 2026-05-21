import 'package:ontrip_customer_flutter_app/app_export.dart';

class AuthenticationController extends GetxService {
  Future<AuthenticationController> init() async => this;

  final RxMap<String, dynamic> userAuthData = <String, dynamic>{}.obs;

  final loginList = <dynamic>[].obs;

  bool get isVendor => getStorage(AppSession.userRole) == 'vendor';

  Future<void> fetchProfile() async {
    try {
      final endpoint = isVendor ? BACKEND.vendorProfile : BACKEND.profileUpdate;
      final response = await ApiManager.call(endPoint: endpoint, type: ApiType.get);

      if (response.status == 1 || response.status == 200) {
        if (response.data != null) {
          // Customer API returns data.customer; vendor API returns data.vendor
          final profileData = response.data['vendor'] ?? response.data['customer'];
          if (profileData != null) {
            userAuthData.assignAll(profileData);
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }
  }
}
