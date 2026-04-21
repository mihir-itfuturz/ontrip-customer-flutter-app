import 'package:ontrip_customer_flutter_app/src/screens/dashboard/pages/home/home_controller.dart';
import 'package:ontrip_customer_flutter_app/src/helper/decoration.dart';
import '../../../../../app_export.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  final HomeController homeCtrl = HomeController();

  late final AnimationController _fadeController, _slideController, _scaleController;
  late final Animation<double> _fadeAnimation;

  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
  }

  String getGreetingText() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  String getGreetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 6) return "🌙";
    if (hour < 12) return "☀️";
    if (hour < 17) return "🌤️";
    if (hour < 20) return "🌅";
    return "🌙";
  }

  void initState() {
    homeCtrl.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: decoration.colorScheme.primary.withValues(alpha: .04),
      body: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (ctrl) {
          return Stack(
            children: [
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: RefreshIndicator(
                    onRefresh: () async => await ctrl.initialize(),
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        _buildModernHeader(ctrl),
                        const SliverToBoxAdapter(child: SizedBox(height: 100)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildModernHeader(HomeController ctrl) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Constant.instance.primary, Constant.instance.primary.withValues(alpha: 0.8), Constant.instance.primary.withValues(alpha: 0.6)],
            ),
            borderRadius: decoration.singleBorderRadius([3, 4], 22.0),
          ),
        ),
      ),
    );
  }
}
