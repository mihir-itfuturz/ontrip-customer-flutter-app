import '../../../app_export.dart';

class BookingDetailsCtrl extends GetxController {
  final String bookingId = Get.arguments ?? "";

  Rxn<Booking> booking = Rxn<Booking>();
  RxBool isLoading = false.obs;
  RxInt selectedDay = 0.obs;
  RxInt selectedTab = 0.obs;

  // Review State
  Rxn<ReviewResponse> reviewResponse = Rxn<ReviewResponse>();
  Rxn<Review> userReview = Rxn<Review>();
  RxBool isReviewsLoading = false.obs;
  RxDouble userRating = 0.0.obs;
  final TextEditingController reviewCommentCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (bookingId.isNotEmpty) {
      fetchBookingDetails();
      fetchUserBookingReview();
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
        // After fetching booking, fetch reviews for the package
        if (booking.value?.package?.id != null) {
          fetchPackageReviews(booking.value!.package!.id!);
        }
      } else {
        errorToast(response.message);
      }
    } catch (e, stack) {
      debugPrint("Parsing Error in fetchBookingDetails: $e");
      debugPrint("Stack Trace: $stack");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPackageReviews(String packageId) async {
    try {
      isReviewsLoading.value = true;
      final response = await ApiManager.instance.call(
        endPoint: BACKEND.packageReviews(packageId),
        type: ApiType.get,
      );

      if (response.status == 200 || response.status == 1) {
        reviewResponse.value = ReviewResponse.fromJson(response.data);
      }
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
    } finally {
      isReviewsLoading.value = false;
    }
  }

  Future<void> fetchUserBookingReview() async {
    try {
      final response = await ApiManager.instance.call(
        endPoint: BACKEND.bookingReview(bookingId),
        type: ApiType.get,
      );

      if (response.status == 200 || response.status == 1) {
        if (response.data["review"] != null) {
          userReview.value = Review.fromJson(response.data["review"]);
          // Populate existing rating/comment if needed
          userRating.value = userReview.value?.rating ?? 0.0;
          reviewCommentCtrl.text = userReview.value?.comment ?? "";
        }
      }
    } catch (e) {
      debugPrint("Error fetching user booking review: $e");
    }
  }

  Future<void> submitReview() async {
    if (userRating.value == 0) {
      warningToast("Please select a rating");
      return;
    }

    try {
      isLoading.value = true;
      final response = await ApiManager.instance.call(
        endPoint: BACKEND.bookingReview(bookingId),
        type: ApiType.post,
        body: {
          "packageRating": userRating.value,
          "overallRating": userRating.value,
          "comment": reviewCommentCtrl.text.trim(),
        },
      );

      if (response.status == 200 || response.status == 1) {
        successToast("Review submitted successfully");
        Get.back(); // Close dialog
        fetchUserBookingReview(); // Refresh user review status
        if (booking.value?.package?.id != null) {
          fetchPackageReviews(booking.value!.package!.id!);
        }
      } else {
        errorToast(response.message);
      }
    } catch (e) {
      debugPrint("Error submitting review: $e");
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
