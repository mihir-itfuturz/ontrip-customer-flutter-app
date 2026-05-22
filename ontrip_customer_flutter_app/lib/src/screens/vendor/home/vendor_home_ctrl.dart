import 'dart:developer';
import '../../../../app_export.dart';

class VendorPackage {
  final String id;
  final String title;
  final String destination;
  final String coverImage;
  final List<String> images;
  final int totalDays;
  final double basePrice;
  final String currency;
  final int maxCapacity;
  final String? startDate;
  final String? endDate;
  final String status;
  final bool isActive;
  final List<Itinerary>? itinerary;
  final List<String>? inclusions;
  final List<dynamic>? exclusions;
  final List<Booking>? bookings;

  VendorPackage({
    required this.id,
    required this.title,
    required this.destination,
    required this.coverImage,
    required this.images,
    required this.totalDays,
    required this.basePrice,
    required this.currency,
    required this.maxCapacity,
    this.startDate,
    this.endDate,
    required this.status,
    required this.isActive,
    this.itinerary,
    this.inclusions,
    this.exclusions,
    this.bookings,
    // this.vendorId,
  });

  factory VendorPackage.fromJson(Map<String, dynamic> json) {
    return VendorPackage(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      destination: json['destination'] ?? '',
      coverImage: json['coverImage'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      totalDays: json['totalDays'] ?? 1,
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'INR',
      maxCapacity: json['maxCapacity'] ?? 0,
      startDate: json['startDate'],
      endDate: json['endDate'],
      status: json['status'] ?? '',
      isActive: json['isActive'] ?? false,
      itinerary: json['itinerary'] != null
          ? List<Itinerary>.from((json['itinerary'] as List).map((x) => Itinerary.fromJson(Map<String, dynamic>.from(x as Map))))
          : null,
      inclusions: json['inclusions'] != null ? List<String>.from(json['inclusions']) : null,
      exclusions: json['exclusions'] != null ? List<dynamic>.from(json['exclusions']) : null,
      bookings: (json['bookings'] as List<dynamic>?)?.map((x) => x is Map<String, dynamic> ? Booking.fromJson(x) : Booking(id: x?.toString() ?? '')).toList(),
    );
  }
}

class VendorHomeCtrl extends GetxController {
  final RxList<VendorPackage> packages = <VendorPackage>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final token = getStorage(AppSession.token);
    if (token != null && token.toString().isNotEmpty) {
      Get.find<AuthenticationController>().fetchProfile();
      fetchPackages();
    }
  }

  Future<void> fetchPackages() async {
    try {
      isLoading.value = true;
      final response = await ApiManager.call(endPoint: BACKEND.vendorPackages, type: ApiType.get);
      log('Vendor packages status: ${response.status}, success: ${response.success}');
      log('Vendor packages data: ${response.data}');
      if ((response.status == 1 || response.status == 200) && response.success == true) {
        final data = response.data;
        if (data == null) {
          debugPrint('Vendor packages: data is null');
          return;
        }
        final list = data['packages'] as List<dynamic>? ?? [];
        packages.assignAll(list.map((e) => VendorPackage.fromJson(e)).toList());
        log('Vendor packages loaded: ${packages.length}');
      } else {
        debugPrint('Vendor packages fetch failed: ${response.message}');
      }
    } catch (e, st) {
      debugPrint('Error fetching vendor packages: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }
}
