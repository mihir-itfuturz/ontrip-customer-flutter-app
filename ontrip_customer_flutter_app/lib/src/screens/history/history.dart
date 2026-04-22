import '../../../app_export.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryCtrl>(
      init: HistoryCtrl(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(controller),
                const SizedBox(height: 16),
                _buildSearchAndStats(controller),
                const SizedBox(height: 10),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value && controller.bookings.isEmpty) {
                      return const Center(child: CustomLoadingIndicator());
                    }
                    if (controller.bookings.isEmpty) {
                      return const Center(child: NoDataComponent(text: "No journeys found"));
                    }
                    return RefreshIndicator(
                      onRefresh: controller.fetchHistory,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: controller.bookings.length,
                        itemBuilder: (context, index) {
                          return _buildBookingCard(controller.bookings[index], controller);
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

  Widget _buildHeader(HistoryCtrl controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your Journeys", style: AppTextStyle.bold.copyWith(fontSize: 28, color: const Color(0xFF0F172A), letterSpacing: -0.5)),
          const SizedBox(height: 4),
          Text("Relive your memories and plan for the next one.", style: AppTextStyle.medium.copyWith(fontSize: 14, color: const Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildSearchAndStats(HistoryCtrl controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Search by Booking ID, Destination",
                  hintStyle: AppTextStyle.medium.copyWith(color: Colors.grey.shade400, fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Obx(
            () => Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Constant.instance.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Constant.instance.primary.withValues(alpha: 0.1)),
              ),
              child: Center(
                child: Text(
                  "${controller.totalTrips.value} TOTAL TRIPS",
                  style: AppTextStyle.bold.copyWith(color: Constant.instance.primary, fontSize: 10, letterSpacing: 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking booking, HistoryCtrl controller) {
    final package = booking.package;
    final coverImage = package?.coverImage ?? "";
    final title = booking.whitelabelPackage?.customTitle ?? package?.title ?? "Trip Details";
    final destination = package?.destination ?? "Unknown Location";
    final bookingId = booking.bookingId ?? "N/A";
    final travelDate = booking.travelDate != null ? AppDateFormat.monthDayYear(booking.travelDate!) : "N/A Date";
    final status = booking.bookingStatus ?? "pending";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                child: SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: CustomNetworkImage(imageUrl: "${'https://ontrip.itfuturz.in/'}$coverImage"),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                  ),
                  child: Text(status.toUpperCase(), style: AppTextStyle.bold.copyWith(color: Colors.white, fontSize: 10)),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.airplane_ticket_outlined, size: 14, color: Constant.instance.primary),
                    const SizedBox(width: 6),
                    Text(bookingId, style: AppTextStyle.bold.copyWith(fontSize: 12, color: Constant.instance.primary, letterSpacing: 0.5)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppTextStyle.bold.copyWith(fontSize: 18, color: const Color(0xFF1E293B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoItem(Icons.calendar_today_outlined, travelDate),
                    const SizedBox(width: 16),
                    _buildInfoItem(Icons.location_on_outlined, destination),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => controller.navigateToDetails(booking.bookingId!),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("View Trip", style: AppTextStyle.bold.copyWith(fontSize: 14, color: const Color(0xFF475569))),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, size: 18, color: Color(0xFF64748B)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyle.medium.copyWith(fontSize: 13, color: const Color(0xFF64748B))),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF3B82F6); 
      case 'completed':
        return const Color(0xFF10B981); 
      case 'pending':
        return const Color(0xFFF59E0B); 
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }
}
