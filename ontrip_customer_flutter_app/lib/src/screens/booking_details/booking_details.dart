import '../../../../app_export.dart';

class BookingDetailsCtrl extends GetxController {
  final String bookingId = Get.arguments ?? "";

  Rxn<Booking> booking = Rxn<Booking>();
  RxBool isLoading = false.obs;
  RxInt selectedDay = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (bookingId.isNotEmpty) {
      fetchBookingDetails();
    }
  }

  void onDayChange(int index) {
    selectedDay.value = index;
    update();
  }

  Future<void> fetchBookingDetails() async {
    try {
      isLoading.value = true;
      final response = await ApiManager.instance.call(endPoint: "${BACKEND.bookingDetail}$bookingId", type: ApiType.get);

      if (response.status == 200 || response.status == 1) {
        final data = response.data;
        if (data is Map && data.containsKey('booking')) {
          booking.value = Booking.fromJson(data['booking']);
        } else {
          booking.value = Booking.fromJson(data);
        }
      } else {
        errorToast(response.message ?? "Failed to load details");
      }
    } catch (e, stack) {
      debugPrint("Parsing Error in fetchBookingDetails: $e");
      debugPrint("Stack Trace: $stack");
    } finally {
      isLoading.value = false;
    }
  }

  void callVendor(String? phone) {
    if (phone != null && phone.isNotEmpty) {
      AppUrl.call("tel:$phone", mobile: phone);
    } else {
      warningToast("Contact number not available");
    }
  }
}

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
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CustomLoadingIndicator());
        }

        final booking = controller.booking.value;
        if (booking == null) {
          return const Center(child: Text("No details found"));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(booking),
              _buildSupportCard(booking),
              _buildInclusions(booking),
              _buildExclusions(booking),
              _buildItinerarySection(booking),
              const SizedBox(height: 100),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(Booking booking) {
    final package = booking.package;
    final coverImage = package?.coverImage ?? "";

    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(color: Colors.grey.shade200),
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
    );
  }

  Widget _buildSupportCard(Booking booking) {
    final agencyName = booking.agencyCustomer?.name ?? "Support Team";

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("SUPPORT & ASSISTANCE", style: AppTextStyle.bold.copyWith(fontSize: 12, color: Constant.instance.primary, letterSpacing: 1.5)),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(color: Constant.instance.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16)),
                child: Center(
                  child: Text(agencyName[0].toUpperCase(), style: AppTextStyle.bold.copyWith(color: Constant.instance.primary, fontSize: 24)),
                ),
              ),
              const SizedBox(width: 16),
              Text(agencyName.toUpperCase(), style: AppTextStyle.bold.copyWith(fontSize: 10, color: Colors.grey.shade400, letterSpacing: 1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInclusions(Booking booking) {
    final inclusions = booking.package?.inclusions ?? [];
    if (inclusions.isEmpty) return const SizedBox.shrink();

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
    if (exclusions.isEmpty) return const SizedBox.shrink();

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
    if (itinerary.isEmpty) return const SizedBox.shrink();

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
}
