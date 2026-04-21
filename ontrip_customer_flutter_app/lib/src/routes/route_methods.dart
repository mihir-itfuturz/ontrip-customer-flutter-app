
import '../../app_export.dart';

class RouteMethods {
  static final List<GetPage> pages = [
    GetPage(name: RouteNames.splash, page: () => const SplashScreen(), binding: SplashBinder()),
    GetPage(name: RouteNames.signIn, page: () => const SignInScreen()),
    GetPage(name: RouteNames.verifyOTP, page: () => const VerifyOTPScreen(), binding: BindingsBuilder(() => Get.lazyPut(() => VerifyOTPCtrl()))),
    GetPage(name: RouteNames.dashboard, page: () => const DashboardScreen()),
    GetPage(name: RouteNames.settings, page: () => const SettingsScreen(), binding: BindingsBuilder(() => Get.lazyPut(() => SettingsCtrl()))),
    GetPage(name: RouteNames.editProfile, page: () => const EditProfileScreen(), binding: BindingsBuilder(() => Get.lazyPut(() => EditProfileCtrl()))),
    GetPage(name: RouteNames.bookingDetails, page: () => const BookingDetailsScreen(), binding: BindingsBuilder(() => Get.lazyPut(() => BookingDetailsCtrl()))),
  ];
}
