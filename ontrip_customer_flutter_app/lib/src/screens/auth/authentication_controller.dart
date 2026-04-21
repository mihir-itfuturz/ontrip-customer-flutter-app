import 'package:get/get.dart';

class AuthenticationController extends GetxService {
  Future<AuthenticationController> init() async => this;

  final RxMap<String, dynamic> userAuthData = <String, dynamic>{}.obs;

  final loginList = <dynamic>[].obs;
}
