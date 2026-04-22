import '../../../../../app_export.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityCtrl>(
      init: CommunityCtrl(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CustomLoadingIndicator());
                    }
                    if (controller.bookings.isEmpty) {
                      return Center(child: NoDataComponent(text: "No active trips found"));
                    }
                    return RefreshIndicator(
                      onRefresh: controller.fetchBookings,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: controller.bookings.length,
                        itemBuilder: (context, index) {
                          return _buildBookingTile(controller.bookings[index], controller);
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Community",
            style: AppTextStyle.bold.copyWith(fontSize: 28, color: const Color(0xFF0F172A), letterSpacing: -0.5),
          ),
          const SizedBox(height: 4),
          Text(
            "Connect with fellow travelers and experts.",
            style: AppTextStyle.medium.copyWith(fontSize: 14, color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingTile(Booking booking, CommunityCtrl controller) {
    final package = booking.package;
    final title = booking.whitelabelPackage?.customTitle ?? package?.title ?? "Trip Details";
    final destination = package?.destination ?? "Unknown Location";
    final coverImage = package?.coverImage ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F0FF).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4338CA).withValues(alpha: 0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.navigateToChat(package?.id),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CustomNetworkImage(
                    imageUrl: "${'https://ontrip.itfuturz.in/'}$coverImage",
                    height: 52,
                    width: 52,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.bold.copyWith(fontSize: 15, color: const Color(0xFF2D2C74)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        destination,
                        style: AppTextStyle.medium.copyWith(fontSize: 13, color: const Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
