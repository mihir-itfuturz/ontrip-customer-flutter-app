import 'dart:async';
import '../../../app_export.dart';

class HistoryCtrl extends GetxController {
  final RxList<Booking> bookings = <Booking>[].obs;
  final RxBool isLoading = false.obs;
  final TextEditingController searchController = TextEditingController();
  final RxInt totalTrips = 0.obs;
  
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchHistory(search: query);
    });
  }

  Future<void> fetchHistory({String search = ""}) async {
    try {
      isLoading.value = true;
      final response = await ApiManager.instance.call(
        endPoint: "${BACKEND.bookings}?page=1&limit=50&search=$search",
        type: ApiType.get,
      );

      if (response.status == 200 || response.status == 1) {
        final bookingData = BookingResponseData.fromJson(response.data);
        bookings.assignAll(bookingData.bookings ?? []);
        totalTrips.value = bookingData.pagination?.total ?? bookings.length;
      }
    } catch (e) {
      debugPrint("Error fetching history: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToDetails(String bookingId) {
    Get.toNamed(RouteNames.bookingDetails, arguments: bookingId);
  }
}
