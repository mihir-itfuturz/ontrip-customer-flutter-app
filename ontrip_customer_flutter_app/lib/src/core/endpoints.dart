class BACKEND {
  /// Auth
  static const sendOtp = 'auth/otp/customer';
  static const signIn = 'auth/login/customer';
  static const deleteAccount = 'mobile/delete-account';

  static const banners = 'mobile/banners';
  static const bookings = 'customer/bookings';
  static const String profileUpdate = 'customer/profile';
  static const String bookingDetail = 'customer/bookings/';
  static const String communityInfo = 'community/package/';
  static const String communityMessages = 'community/';
  static const String communityMessaging = '/traveler-messaging';
  static String communityNotificationPreference(String id) => 'community/$id/notification-preference';
  static String communityImages(String id) => 'community/$id/images';
  static String packageReviews(String id) => 'customer/packages/$id/reviews';
  static String bookingReview(String id) => 'customer/bookings/$id/review';
  static String communityBulkDeleteImages(String id) => 'community/$id/bulk-delete-images';
}
