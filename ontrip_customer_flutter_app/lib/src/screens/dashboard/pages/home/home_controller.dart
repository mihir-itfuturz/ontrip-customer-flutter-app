import 'dart:io';
import 'dart:async';
import '../../../../../app_export.dart';

class HomeController extends GetxController {
  bool isLoading = false;
  String token = "";

  final RxList<Booking> bookings = <Booking>[].obs;
  final RxInt carouselIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    try {
      isLoading = true;
      update();
      token = getStorage(AppSession.token) ?? "";
      await fetchBookings();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchBookings() async {
    try {
      final response = await ApiManager.instance.call(endPoint: BACKEND.bookings, type: ApiType.get);
      if (response.status == 200 || response.status == 1) {
        final bookingData = BookingResponseData.fromJson(response.data);
        bookings.assignAll(bookingData.bookings ?? []);
      }
    } catch (e) {
      debugPrint("Error fetching bookings: $e");
    }
  }
}
