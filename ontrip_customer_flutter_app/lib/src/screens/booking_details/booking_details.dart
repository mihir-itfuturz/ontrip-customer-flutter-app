import '../../../../app_export.dart';

class BookingDetailsScreen extends GetView<BookingDetailsCtrl> {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Trip Details", style: AppTextStyle.bold.copyWith(fontSize: 18)),
        centerTitle: true,
        leading: const CustomBackBtn(),
        actions: [
          _buildActionBtn(Icons.chat_bubble_outline, const Color(0xFF1E293B), () {
            final packageId = controller.booking.value?.package?.id;
            final coverImage = controller.booking.value?.package?.coverImage;
            if (packageId != null) {
              Get.toNamed(RouteNames.communityChat, arguments: {"packageId": packageId, "coverImage": coverImage});
            } else {
              warningToast("Community not available for this trip");
            }
          }),
          // const SizedBox(width: 8),
          // _buildActionBtn(Icons.local_activity_outlined, Constant.instance.primary, () {}),
          const SizedBox(width: 16),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CustomLoadingIndicator());
        }

        final booking = controller.booking.value;
        if (booking == null) {
          return const Center(child: Text("No details found"));
        }

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(booking),
              // _buildItinerarySection(booking),
              // _buildInclusions(booking),
              // _buildExclusions(booking),
              // _buildSupportCard(booking),
              Expanded(child: _buildTabSection(booking)),
            ],
          ),
        );
      }),
    );
  }
  // Add this method inside BookingDetailsScreen:

  Widget _buildTabSection(Booking booking) {
    final tabs = [
      {"label": "Itinerary", "icon": Icons.map_outlined},
      {"label": "Includes", "icon": Icons.check_circle_outline},
      {"label": "Excludes", "icon": Icons.cancel_outlined},
      {"label": "Support", "icon": Icons.headset_mic_outlined},
      {"label": "Feedback", "icon": Icons.star_outline},
    ];

    final contents = [
      _buildItinerarySection(booking),
      _buildInclusions(booking),
      _buildExclusions(booking),
      _buildSupportCard(booking),
      _buildReviewSection(booking, controller),
    ];

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final isSelected = controller.selectedTab.value == index;
                return GestureDetector(
                  onTap: () => controller.selectedTab.value = index,
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
          // IndexedStack(index: controller.selectedTab.value, children: contents),
          Expanded(
            child: SingleChildScrollView(
              child: IndexedStack(index: controller.selectedTab.value, children: contents),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, Color iconColor, VoidCallback onTap) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
      ),
    );
  }

  Widget _buildHeader(Booking booking) {
    final package = booking.package;
    final coverImage = package?.coverImage ?? "";

    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
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

  Widget _buildEmptyState(IconData icon, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(message, style: AppTextStyle.medium.copyWith(fontSize: 14, color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard(Booking booking) {
    final agencyCustomer = booking.agencyCustomer;
    final agencyName = agencyCustomer?.name ?? "Support Team";
    final agencyEmail = agencyCustomer?.email;
    final agencyPhone = agencyCustomer?.phone;
    final hasPhone = agencyPhone != null && agencyPhone.isNotEmpty;
    final hasEmail = agencyEmail != null && agencyEmail.isNotEmpty;
    if (agencyCustomer == null) return _buildEmptyState(Icons.headset_mic_outlined, "No support contact available");

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("SUPPORT & ASSISTANCE", style: AppTextStyle.bold.copyWith(fontSize: 11, color: Constant.instance.primary, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(color: Constant.instance.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
                child: Center(
                  child: Text(
                    agencyName.isNotEmpty ? agencyName[0].toUpperCase() : "S",
                    style: AppTextStyle.bold.copyWith(color: Constant.instance.primary, fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(agencyName, style: AppTextStyle.bold.copyWith(fontSize: 15, color: const Color(0xFF1E293B))),
                    const SizedBox(height: 2),
                    Text("Your Travel Agent", style: AppTextStyle.medium.copyWith(fontSize: 12, color: const Color(0xFF94A3B8))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 16),
          // Phone Row
          if (hasPhone)
            GestureDetector(
              onTap: () => AppUrl.call("tel:$agencyPhone", mobile: agencyPhone),
              child: Row(
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(color: const Color(0xFFEEFDF4), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.call_outlined, color: Color(0xFF16A34A), size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(agencyPhone, style: AppTextStyle.medium.copyWith(fontSize: 14, color: const Color(0xFF1E293B))),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 18),
                ],
              ),
            ),
          if (hasPhone && hasEmail) const SizedBox(height: 12),
          // Email Row
          if (hasEmail)
            GestureDetector(
              onTap: () => AppUrl.mail(email: agencyEmail, subject: "Trip Enquiry"),
              child: Row(
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.mail_outline, color: Color(0xFF3B82F6), size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(agencyEmail, style: AppTextStyle.medium.copyWith(fontSize: 14, color: const Color(0xFF1E293B))),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 18),
                ],
              ),
            ),
          if (!hasPhone && !hasEmail) Text("Contact details not available", style: AppTextStyle.medium.copyWith(fontSize: 13, color: const Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _buildInclusions(Booking booking) {
    final inclusions = booking.package?.inclusions ?? [];
    if (inclusions.isEmpty) return _buildEmptyState(Icons.check_circle_outline, "No inclusions listed for this package");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("PACKAGE INCLUSIONS", style: AppTextStyle.bold.copyWith(fontSize: 12, color: Colors.green, letterSpacing: 1.5)),
          const SizedBox(height: 20),
          ...inclusions.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(item, style: AppTextStyle.medium.copyWith(fontSize: 15, color: Colors.grey.shade700)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExclusions(Booking booking) {
    final exclusions = booking.package?.exclusions ?? [];
    if (exclusions.isEmpty) return _buildEmptyState(Icons.cancel_outlined, "No exclusions listed for this package");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("PACKAGE EXCLUSIONS", style: AppTextStyle.bold.copyWith(fontSize: 12, color: Colors.red, letterSpacing: 1.5)),
          const SizedBox(height: 20),
          ...exclusions.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  const Icon(Icons.cancel_outlined, color: Colors.red, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(item.toString(), style: AppTextStyle.medium.copyWith(fontSize: 15, color: Colors.grey.shade700)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItinerarySection(Booking booking) {
    final itinerary = booking.package?.itinerary ?? [];
    if (itinerary.isEmpty) return _buildEmptyState(Icons.map_outlined, "No itinerary available for this trip");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        // Day Selector
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: itinerary.length,
            itemBuilder: (context, index) {
              return Obx(() {
                final isSelected = controller.selectedDay.value == index;
                return GestureDetector(
                  onTap: () => controller.onDayChange(index),
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
        const SizedBox(height: 20),
        // Day Content
        Obx(() {
          final dayData = itinerary[controller.selectedDay.value];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
                  child: Column(
                    children: [
                      Text(
                        dayData.title ?? "Day ${dayData.day}",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.bold.copyWith(fontSize: 24, color: Colors.grey.shade900),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        dayData.description ?? "",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.medium.copyWith(fontSize: 14, color: Colors.grey.shade500, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...(dayData.experiences ?? []).map((exp) => _buildExperienceCard(exp)),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildExperienceCard(Experience exp) {
    final image = exp.images?.isNotEmpty == true ? exp.images![0] : "";
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (image.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              child: CustomNetworkImage(imageUrl: image.startsWith("http") ? image : "https://ontrip.itfuturz.in/$image", height: 180, width: double.infinity),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Text(
                            "${exp.startTime}${exp.endTime != null && exp.endTime!.isNotEmpty ? ' — ${exp.endTime}' : ''}",
                            style: AppTextStyle.bold.copyWith(fontSize: 12, color: Colors.grey.shade800),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        exp.category?.toUpperCase() ?? "ACTIVITY",
                        style: AppTextStyle.bold.copyWith(fontSize: 10, color: Colors.blueAccent, letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exp.name ?? "Event", style: AppTextStyle.bold.copyWith(fontSize: 20, color: Colors.grey.shade900)),
                          const SizedBox(height: 8),
                          Text(exp.description ?? "", style: AppTextStyle.medium.copyWith(fontSize: 13, color: Colors.grey.shade500, height: 1.4)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => controller.callVendor(exp.vendor?.phone),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                        ),
                        child: const Icon(Icons.call, color: Colors.blueGrey, size: 20),
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

  Widget _buildReviewSection(Booking booking, BookingDetailsCtrl ctrl) {
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

  Widget _buildManageUserReview(BookingDetailsCtrl ctrl) {
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

  Widget _buildReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(color: Constant.instance.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    review.customerName?.isNotEmpty == true ? review.customerName![0].toUpperCase() : "U",
                    style: AppTextStyle.bold.copyWith(color: Constant.instance.primary, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.customerName ?? "User", style: AppTextStyle.bold.copyWith(fontSize: 14, color: const Color(0xFF1E293B))),
                    Text(
                      AppDateFormat.notification3(review.createdAt ?? DateTime.now()),
                      // style: AppDateFormat.notification3(review.createdAt ?? DateTime.now()),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(index < (review.overallRating ?? 0) ? Icons.star : Icons.star_border, color: Colors.amber, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(review.comment ?? "", style: AppTextStyle.medium.copyWith(fontSize: 14, color: const Color(0xFF475569), height: 1.5)),
        ],
      ),
    );
  }

  void _showReviewDialog(BuildContext context) {
    controller.userRating.value = 0;
    controller.reviewCommentCtrl.clear();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Write a review", style: AppTextStyle.bold.copyWith(fontSize: 20, color: const Color(0xFF1E293B))),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
                const Divider(height: 32),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Text("How was your experience?", style: AppTextStyle.bold.copyWith(fontSize: 15, color: const Color(0xFF1E293B))),
                      const SizedBox(height: 16),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return GestureDetector(
                              onTap: () => controller.userRating.value = index + 1.0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  index < controller.userRating.value ? Icons.star : Icons.star_border,
                                  color: index < controller.userRating.value ? Colors.amber : Colors.grey.shade300,
                                  size: 32,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text("Comments (optional)", style: AppTextStyle.bold.copyWith(fontSize: 12, color: const Color(0xFF64748B))),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    controller: controller.reviewCommentCtrl,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Tell us more about your experience (max 500 words)...",
                      hintStyle: AppTextStyle.medium.copyWith(fontSize: 14, color: const Color(0xFF94A3B8)),
                      contentPadding: const EdgeInsets.all(16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: Text("Cancel", style: AppTextStyle.bold.copyWith(color: const Color(0xFF64748B))),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => controller.submitReview(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF312E81),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text("Submit", style: AppTextStyle.bold.copyWith(fontSize: 15, color: Constant.instance.white)),
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: ElevatedButton(
                    //     onPressed: () => controller.submitReview(),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: const Color(0xFF312E81),
                    //       foregroundColor: Colors.white,
                    //       padding: const EdgeInsets.symmetric(vertical: 16),
                    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    //       elevation: 0,
                    //     ),
                    //     child: Text("Submit", style: AppTextStyle.bold.copyWith(fontSize: 15)),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
