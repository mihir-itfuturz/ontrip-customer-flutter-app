import 'dart:async';

import 'package:dio/dio.dart' as dio;
import '../../../../../app_export.dart';

class CommunityChatCtrl extends GetxController {
  final Rxn<Community> community = Rxn<Community>();
  final RxList<CommunityMessage> messages = <CommunityMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxList<XFile> selectedImages = <XFile>[].obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  Timer? _messageTimer;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    initCommunity();
  }

  @override
  void onClose() {
    _messageTimer?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> initCommunity() async {
    try {
      isLoading.value = true;

      String? packageId = Get.arguments;

      if (packageId == null) {
        // Fallback: Get the latest booking to find the packageId
        final homeCtrl = Get.find<HomeController>();
        if (homeCtrl.bookings.isEmpty) {
          await homeCtrl.fetchBookings();
        }
        if (homeCtrl.bookings.isNotEmpty) {
          packageId = homeCtrl.bookings.first.package?.id;
        }
      }
      if (packageId != null) {
        await fetchCommunityInfo(packageId);
        if (community.value != null) {
          await fetchMessages();
          // Start polling for new messages every 5 seconds

          fetchMessages(showLoading: false);
        }
      }
    } catch (e) {
      debugPrint("Error initializing community: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> initCommunity() async {
  //   try {
  //     isLoading.value = true;

  //     String? packageId = Get.arguments;

  //     if (packageId == null) {
  //       // Fallback: Get the latest booking to find the packageId
  //       final homeCtrl = Get.find<HomeController>();
  //       if (homeCtrl.bookings.isEmpty) {
  //         await homeCtrl.fetchBookings();
  //       }
  //       if (homeCtrl.bookings.isNotEmpty) {
  //         packageId = homeCtrl.bookings.first.package?.id;
  //       }
  //     }

  //     if (packageId != null) {
  //       await fetchCommunityInfo(packageId);
  //         if (community.value != null) {
  //           await fetchMessages();
  //           // Start polling for new messages every 5 seconds
  //           _messageTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
  //             fetchMessages(showLoading: false);
  //           });
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("Error initializing community: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }

  Future<void> fetchCommunityInfo(String packageId) async {
    try {
      final response = await ApiManager.instance.call(endPoint: "${BACKEND.communityInfo}$packageId", type: ApiType.get);

      if (response.status == 200 || response.status == 1) {
        final communityData = CommunityResponse.fromJson(response.data);
        community.value = communityData.community;
      }
    } catch (e) {
      debugPrint("Error fetching community info: $e");
    }
  }

  Future<void> fetchMessages({bool showLoading = true}) async {
    if (community.value == null) return;

    try {
      if (showLoading) isLoading.value = true;
      final response = await ApiManager.instance.call(
        endPoint: "${BACKEND.communityMessages}${community.value!.id}/messages?limit=50&page=1",
        type: ApiType.get,
      );

      if (response.status == 200 || response.status == 1) {
        final messagesData = MessagesResponse.fromJson(response.data);
        final newMessages = messagesData.messages ?? [];

        // Reverse to show latest at bottom if using a regular ListView
        // But if using a reversed ListView, keep as is
        if (newMessages.length != messages.length) {
          messages.assignAll(newMessages);
          _scrollToBottom();
        }
      }
    } catch (e) {
      debugPrint("Error fetching messages: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final content = messageController.text.trim();
    if (content.isEmpty || community.value == null) return;

    try {
      isSending.value = true;
      messageController.clear();

      final response = await ApiManager.instance.call(
        endPoint: "${BACKEND.communityMessages}${community.value!.id}/messages",
        type: ApiType.post,
        body: {"content": content},
      );

      if (response.status == 200 || response.status == 1) {
        await fetchMessages(showLoading: false);
      } else {
        errorToast(response.message);
      }
    } catch (e) {
      debugPrint("Error sending message: $e");
      errorToast("Something went wrong");
    } finally {
      isSending.value = false;
    }
  }

  Future<void> pickImages() async {
    final List<XFile> picked = await _picker.pickMultiImage(imageQuality: 80);
    if (picked.isEmpty) return;
    selectedImages.addAll(picked);
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  Future<void> sendImages() async {
    if (selectedImages.isEmpty || community.value == null) return;
    final caption = messageController.text.trim();
    try {
      isSending.value = true;
      messageController.clear();

      for (final xfile in List<XFile>.from(selectedImages)) {
        final formData = dio.FormData.fromMap({
          'image': await dio.MultipartFile.fromFile(xfile.path, filename: xfile.name),
          if (caption.isNotEmpty) 'caption': caption,
        });

        final response = await ApiManager.instance.call(
          endPoint: "${BACKEND.communityMessages}${community.value!.id}/messages/image",
          type: ApiType.post,
          body: formData,
        );

        if (response.status != 200 && response.status != 1) {
          errorToast(response.message );
        }
      }

      selectedImages.clear();
      await fetchMessages(showLoading: false);
    } catch (e) {
      debugPrint("Error sending images: $e");
      errorToast("Failed to send image");
    } finally {
      isSending.value = false;
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          0, // If reversed, 0 is the latest
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }
}
