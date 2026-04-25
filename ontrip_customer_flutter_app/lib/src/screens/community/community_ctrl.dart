import '../../../../../app_export.dart';

class CommunityCtrl extends GetxController {
  final RxList<Booking> bookings = <Booking>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      final response = await ApiManager.instance.call(
        endPoint: BACKEND.bookings,
        type: ApiType.get,
      );

      if (response.status == 200 || response.status == 1) {
        final bookingData = BookingResponseData.fromJson(response.data);
        bookings.assignAll(bookingData.bookings ?? []);
      }
    } catch (e) {
      debugPrint("Error fetching bookings for community: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToChat(String? packageId, String? coverImage) {
    if (packageId != null) {
      Get.toNamed(RouteNames.communityChat, arguments: {
        "packageId": packageId,
        "coverImage": coverImage,
      });
    } else {
      warningToast("Booking details not complete");
    }
  }
}
