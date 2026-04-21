
import '../../app_export.dart';

class RouteMethods {
  static final List<GetPage> pages = [
    GetPage(name: RouteNames.splash, page: () => const SplashScreen(), binding: SplashBinder()),
    GetPage(name: RouteNames.signIn, page: () => const SignInScreen()),
    GetPage(name: RouteNames.dashboard, page: () => const DashboardScreen()),
  ];
}
