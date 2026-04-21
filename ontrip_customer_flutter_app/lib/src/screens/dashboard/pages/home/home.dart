import 'package:ontrip_customer_flutter_app/src/screens/dashboard/pages/home/home_controller.dart';
import 'package:ontrip_customer_flutter_app/src/helper/decoration.dart';
import '../../../../../app_export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
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
                        _buildMyBookingsCarousel(ctrl),
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

  Widget _buildMyBookingsCarousel(HomeController ctrl) {
    return SliverToBoxAdapter(
      child: Obx(() {
        if (ctrl.bookings.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("My Bookings", style: AppTextStyle.bold.copyWith(fontSize: 18, color: Colors.grey.shade900)),
                  TextButton(
                    onPressed: () {},
                    child: Text("View All", style: TextStyle(color: Constant.instance.primary)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 240,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.9),
                onPageChanged: (index) => ctrl.carouselIndex.value = index,
                itemCount: ctrl.bookings.length,
                itemBuilder: (context, index) {
                  return _buildBookingCard(ctrl.bookings[index]);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final package = booking.package;
    final coverImage = package?.coverImage ?? "";
    final title = booking.whitelabelPackage?.customTitle ?? package?.title ?? "Trip Details";
    final destination = package?.destination ?? "Unknown Location";

    return GestureDetector(
      onTap: () => Get.toNamed(RouteNames.bookingDetails, arguments: booking.bookingId),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(child: CustomNetworkImage(imageUrl: "${'https://ontrip.itfuturz.in/'}$coverImage")),
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.2), Colors.black.withValues(alpha: 0.8)],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bold.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: -0.2,
                        shadows: [Shadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10)],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLocationBadge(destination),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationBadge(String destination) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(destination.toUpperCase(), style: AppTextStyle.bold.copyWith(color: Colors.white, fontSize: 10, letterSpacing: 1.2)),
          const SizedBox(width: 12),
          _buildPaginationDots(),
        ],
      ),
    );
  }

  Widget _buildPaginationDots() {
    return GetBuilder<HomeController>(
      builder: (ctrl) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(ctrl.bookings.length, (index) {
            return Obx(() {
              final active = ctrl.carouselIndex.value == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 6),
                height: 6,
                width: active ? 20 : 6,
                decoration: BoxDecoration(color: active ? Colors.white : Colors.white.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(10)),
              );
            });
          }),
        );
      },
    );
  }

  Widget _buildModernHeader(HomeController ctrl) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Constant.instance.primary, Constant.instance.primary.withValues(alpha: 0.9), Constant.instance.primary.withValues(alpha: 0.7)],
          ),
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
          boxShadow: [BoxShadow(color: Constant.instance.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${getGreetingText()} ${getGreetingEmoji()}",
                      style: AppTextStyle.medium.copyWith(color: Colors.white.withValues(alpha: 0.9), fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text("Welcome to OnTrip", style: AppTextStyle.bold.copyWith(color: Colors.white, fontSize: 24, letterSpacing: -0.5)),
                  ],
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(RouteNames.settings),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                    child: const Icon(Icons.person_outline, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildStatCard(ctrl),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(HomeController ctrl) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Constant.instance.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(15)),
            child: Icon(Icons.rocket_launch_outlined, color: Constant.instance.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Trips", style: AppTextStyle.medium.copyWith(color: Colors.grey.shade600, fontSize: 14)),
                const SizedBox(height: 2),
                Text("${ctrl.bookings.length} Active Trips", style: AppTextStyle.bold.copyWith(color: Colors.grey.shade900, fontSize: 18)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
