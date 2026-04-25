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
          return SafeArea(
            bottom: true,
            top: false,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: RefreshIndicator(
                onRefresh: () async => await ctrl.initialize(),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    _buildAppBar(ctrl),
                    // _buildMyBookingsCarousel(ctrl),
                    _buildSelectedBookingDetails(ctrl),
                    // const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedBookingDetails(HomeController ctrl) {
    return SliverToBoxAdapter(
      child: Obx(() {
        final booking = ctrl.selectedBooking.value;
        if (booking == null) return const SizedBox.shrink();

        return Column(children: [_buildTripHeader(booking), _buildTripTabSection(booking, ctrl)]);
      }),
    );
  }

  Widget _buildTripHeader(Booking booking) {
    final package = booking.package;
    final coverImage = package?.coverImage ?? "";

    return Container(
      width: double.infinity,
      height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(32)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            Positioned.fill(child: CustomNetworkImage(imageUrl: "https://ontrip.itfuturz.in/$coverImage")),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Constant.instance.primary, borderRadius: BorderRadius.circular(6)),
                    child: Text(booking.bookingStatus?.toUpperCase() ?? "BOOKED", style: AppTextStyle.bold.copyWith(color: Colors.white, fontSize: 10)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    booking.whitelabelPackage?.customTitle ?? package?.title ?? "Trip Details",
                    style: AppTextStyle.bold.copyWith(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 14),
                      const SizedBox(width: 8),
                      Text(package?.destination ?? "Exploring", style: AppTextStyle.medium.copyWith(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripTabSection(Booking booking, HomeController ctrl) {
    final tabs = [
      {"label": "Itinerary", "icon": Icons.map_outlined},
      {"label": "Includes", "icon": Icons.check_circle_outline},
      {"label": "Excludes", "icon": Icons.cancel_outlined},
      {"label": "Support", "icon": Icons.headset_mic_outlined},
      {"label": "Feedback", "icon": Icons.star_outline},
    ];

    final contents = [
      _buildTripItinerary(booking, ctrl),
      _buildTripInclusions(booking),
      _buildTripExclusions(booking),
      _buildTripSupport(booking),
      _buildTripReviews(booking, ctrl),
    ];

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final isSelected = ctrl.selectedTab.value == index;
                return GestureDetector(
                  onTap: () => ctrl.selectedTab.value = index,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: isSelected ? Constant.instance.primary : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected ? Constant.instance.primary.withValues(alpha: 0.28) : Colors.black.withValues(alpha: 0.04),
                          blurRadius: isSelected ? 12 : 8,
                          offset: Offset(0, isSelected ? 4 : 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(tabs[index]["icon"] as IconData, size: 15, color: isSelected ? Colors.white : Colors.grey.shade500),
                        const SizedBox(width: 6),
                        Text(
                          tabs[index]["label"] as String,
                          style: AppTextStyle.bold.copyWith(fontSize: 13, color: isSelected ? Colors.white : Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          IndexedStack(index: ctrl.selectedTab.value, children: contents),
          // const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTripItinerary(Booking booking, HomeController ctrl) {
    final itinerary = booking.package?.itinerary ?? [];
    if (itinerary.isEmpty) return _buildTripEmptyState(Icons.map_outlined, "No itinerary available");

    return Column(
      children: [
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: itinerary.length,
            itemBuilder: (context, index) {
              return Obx(() {
                final isSelected = ctrl.selectedDay.value == index;
                return GestureDetector(
                  onTap: () => ctrl.onDayChange(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? Constant.instance.primary : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 5)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "DAY",
                          style: AppTextStyle.bold.copyWith(fontSize: 10, color: isSelected ? Colors.white.withValues(alpha: 0.7) : Colors.grey.shade400),
                        ),
                        Text("${index + 1}", style: AppTextStyle.bold.copyWith(fontSize: 18, color: isSelected ? Colors.white : Colors.grey.shade800)),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
        Obx(() {
          final dayData = itinerary[ctrl.selectedDay.value];
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                  child: Column(
                    children: [
                      Text(dayData.title ?? "Day ${dayData.day}", style: AppTextStyle.bold.copyWith(fontSize: 20)),
                      const SizedBox(height: 8),
                      Text(
                        dayData.description ?? "",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.medium.copyWith(fontSize: 14, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...(dayData.experiences ?? []).map((exp) => _buildTripExperience(exp, ctrl)),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTripExperience(Experience exp, HomeController ctrl) {
    final image = exp.images?.isNotEmpty == true ? exp.images![0] : "";
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          if (image.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: CustomNetworkImage(imageUrl: image.startsWith("http") ? image : "https://ontrip.itfuturz.in/$image", height: 160, width: double.infinity),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(exp.category?.toUpperCase() ?? "ACTIVITY", style: AppTextStyle.bold.copyWith(fontSize: 10, color: Constant.instance.primary)),
                    Text("${exp.startTime} - ${exp.endTime ?? ""}", style: AppTextStyle.medium.copyWith(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exp.name ?? "", style: AppTextStyle.bold.copyWith(fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(exp.description ?? "", style: AppTextStyle.medium.copyWith(fontSize: 13, color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (exp.vendor?.phone?.isNotEmpty == true)
                      GestureDetector(
                        onTap: () => ctrl.callVendor(exp.vendor?.phone),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Constant.instance.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                          child: Icon(Icons.call, color: Constant.instance.primary, size: 18),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripInclusions(Booking booking) {
    final inclusions = booking.package?.inclusions ?? [];
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("INCLUSIONS", style: AppTextStyle.bold.copyWith(color: Colors.green)),
          const SizedBox(height: 16),
          ...inclusions.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripExclusions(Booking booking) {
    final exclusions = booking.package?.exclusions ?? [];
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("EXCLUSIONS", style: AppTextStyle.bold.copyWith(color: Colors.red)),
          const SizedBox(height: 16),
          ...exclusions.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.cancel, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item.toString())),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripSupport(Booking booking) {
    final agency = booking.agencyCustomer;
    if (agency == null) return _buildTripEmptyState(Icons.headset_mic, "No support contact");
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Constant.instance.primary.withValues(alpha: 0.1), child: Text(agency.name?[0] ?? "S")),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(agency.name ?? "Support"),
                  Text("Travel Agent", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (agency.phone?.isNotEmpty == true)
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(agency.phone!),
              onTap: () => AppUrl.call("tel:${agency.phone}", mobile: agency.phone!),
            ),
          if (agency.email?.isNotEmpty == true)
            ListTile(
              leading: Icon(Icons.email),
              title: Text(agency.email!),
              onTap: () => AppUrl.mail(email: agency.email!, subject: "Trip Enquiry"),
            ),
        ],
      ),
    );
  }

  Widget _buildTripReviews(Booking booking, HomeController ctrl) {
    return Obx(() {
      final reviews = ctrl.reviewResponse.value?.reviews ?? [];
      final avgPackage = ctrl.reviewResponse.value?.avgPackageRating ?? "0.0";
      final avgOverall = ctrl.reviewResponse.value?.avgOverallRating ?? "0.0";
      final total = ctrl.reviewResponse.value?.total ?? 0;

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("YOUR EXPERIENCE", style: AppTextStyle.bold.copyWith(fontSize: 14, color: Colors.grey.shade400, letterSpacing: 1.2)),
            const SizedBox(height: 16),
            _buildManageUserReview(ctrl),
            const SizedBox(height: 32),
            Text("GUEST FEEDBACK", style: AppTextStyle.bold.copyWith(fontSize: 14, color: Colors.grey.shade400, letterSpacing: 1.2)),
            const SizedBox(height: 16),
            if (reviews.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Constant.instance.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Constant.instance.primary.withValues(alpha: 0.1)),
                ),
                child: Row(
                  children: [
                    _buildRatingSummaryItem("Package", avgPackage),
                    Container(height: 40, width: 1, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 20)),
                    _buildRatingSummaryItem("Overall", avgOverall),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("$total", style: AppTextStyle.bold.copyWith(fontSize: 18, color: Constant.instance.primary)),
                        Text("Reviews", style: AppTextStyle.medium.copyWith(fontSize: 12, color: Colors.grey.shade500)),
                      ],
                    ),
                  ],
                ),
              ),
            if (reviews.isEmpty) _buildTripEmptyState(Icons.star_outline, "No reviews yet") else ...reviews.map((r) => _buildTripReviewCard(r)),
          ],
        ),
      );
    });
  }

  Widget _buildManageUserReview(HomeController ctrl) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ctrl.userReview.value == null ? "How was your trip?" : "Your Review", style: AppTextStyle.bold.copyWith(fontSize: 16)),
              if (ctrl.userReview.value != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text("SUBMITTED", style: AppTextStyle.bold.copyWith(color: Colors.green, fontSize: 10)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => ctrl.userReview.value == null ? ctrl.userRating.value = index + 1.0 : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(Icons.star_rounded, size: 36, color: index < ctrl.userRating.value ? Colors.amber : Colors.grey.shade300),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: ctrl.reviewCommentCtrl,
            maxLines: 3,
            readOnly: ctrl.userReview.value != null,
            decoration: InputDecoration(
              hintText: "Share your experience with others...",
              hintStyle: AppTextStyle.medium.copyWith(fontSize: 14, color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.grey.shade300,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          if (ctrl.userReview.value == null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: ctrl.isReviewLoading.value ? null : () => ctrl.submitReview(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.instance.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: ctrl.isReviewLoading.value
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(ctrl.userReview.value == null ? "Submit Review" : "Update Review", style: AppTextStyle.bold.copyWith(fontSize: 16)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingSummaryItem(String label, String rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.medium.copyWith(fontSize: 12, color: Colors.grey.shade500)),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(rating, style: AppTextStyle.bold.copyWith(fontSize: 20)),
            const SizedBox(width: 4),
            const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildTripReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: Constant.instance.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(review.customerName?[0].toUpperCase() ?? "U", style: AppTextStyle.bold.copyWith(color: Constant.instance.primary, fontSize: 16)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.customerName ?? "Guest User", style: AppTextStyle.bold.copyWith(fontSize: 15)),
                    if (review.createdAt != null)
                      Text(AppDateFormat.monthDayYear(review.createdAt!), style: AppTextStyle.medium.copyWith(fontSize: 11, color: Colors.grey.shade400)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "${(review.packageRating ?? review.overallRating ?? 0.0).toInt()}",
                      style: AppTextStyle.bold.copyWith(fontSize: 13, color: Colors.amber.shade800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (review.comment?.isNotEmpty == true) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16)),
              child: Text(review.comment!, style: AppTextStyle.medium.copyWith(fontSize: 13, color: Colors.grey.shade700, height: 1.5)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTripEmptyState(IconData icon, String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(msg, style: TextStyle(color: Colors.grey)),
          ],
        ),
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
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text("On-Going Trips", style: AppTextStyle.bold.copyWith(fontSize: 18, color: const Color(0xFF1E293B))),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.85),
                onPageChanged: (index) => ctrl.carouselIndex.value = index,
                itemCount: ctrl.bookings.length,
                itemBuilder: (context, index) {
                  return _buildBookingCard(ctrl.bookings[index], ctrl);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBookingCard(Booking booking, HomeController ctrl) {
    final package = booking.package;
    final coverImage = package?.coverImage ?? "";
    final title = booking.whitelabelPackage?.customTitle ?? package?.title ?? "Trip Details";
    final destination = package?.destination ?? "Unknown Location";

    return GestureDetector(
      onTap: () {
        ctrl.setBooking(booking);
        Get.toNamed(RouteNames.bookingDetails, arguments: booking.bookingId);
      },
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.bold.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        letterSpacing: -0.2,
                        shadows: [Shadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10)],
                      ),
                    ),
                    const SizedBox(height: 12),
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

  // Widget _buildModernHeader(HomeController ctrl) {
  //   return SliverToBoxAdapter(
  //     child: Container(
  //       width: double.infinity,
  //       padding: const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 30),
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //           colors: [Constant.instance.primary, Constant.instance.primary.withValues(alpha: 0.9), Constant.instance.primary.withValues(alpha: 0.7)],
  //         ),
  //         borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
  //         boxShadow: [BoxShadow(color: Constant.instance.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     "${getGreetingText()} ${getGreetingEmoji()}",
  //                     style: AppTextStyle.medium.copyWith(color: Colors.white.withValues(alpha: 0.9), fontSize: 16),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text("Welcome to OnTrip", style: AppTextStyle.bold.copyWith(color: Colors.white, fontSize: 24, letterSpacing: -0.5)),
  //                 ],
  //               ),
  //               GestureDetector(
  //                 onTap: () => Get.toNamed(RouteNames.settings),
  //                 child: Container(
  //                   padding: const EdgeInsets.all(10),
  //                   decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
  //                   child: const Icon(Icons.person_outline, color: Colors.white),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 30),
  //           _buildStatCard(ctrl),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildAppBar(HomeController ctrl) {
    return SliverToBoxAdapter(
      child: Obx(() {
        final authCtrl = Get.find<AuthenticationController>();
        final name = authCtrl.userAuthData['name'] ?? "User";

        return Container(
          width: double.infinity,
          // padding: const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Constant.instance.primary, Constant.instance.primary.withValues(alpha: 0.9), Constant.instance.primary.withValues(alpha: 0.7)],
            ),
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
            boxShadow: [BoxShadow(color: Constant.instance.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          padding: const EdgeInsets.fromLTRB(24, 50, 24, 30),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Constant.instance.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Constant.instance.primary, width: 2),
                ),
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Text(name.substring(0, 1).toUpperCase(), style: AppTextStyle.bold.copyWith(color: Constant.instance.primary, fontSize: 35)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$name’s Trips", style: AppTextStyle.bold.copyWith(color: Constant.instance.white, fontSize: 18)),
                    Text(
                      AppDateFormat.monthDayYear(DateTime.now()),
                      style: AppTextStyle.medium.copyWith(color: Constant.instance.white.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Icons.notifications_none_rounded, color: Constant.instance.white, size: 28),
              // ),
            ],
          ),
        );
      }),
    );
  }
}
