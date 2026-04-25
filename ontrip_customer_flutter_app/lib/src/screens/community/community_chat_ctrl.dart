import 'dart:async';
import 'dart:developer';

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
  final RxnString coverImage = RxnString();
  final RxBool notificationEnabled = true.obs;
  var communityId;

  Timer? _messageTimer;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() async {
    super.onInit();
    await initCommunity();
    await listenForNewMessages();
    await connectToCommunity();
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

      final dynamic args = Get.arguments;
      String? packageId;

      if (args is Map) {
        packageId = args["packageId"];
        coverImage.value = args["coverImage"];
      } else if (args is String) {
        packageId = args;
      }

      if (packageId == null) {
        // Fallback: Get the latest booking to find the packageId
        final homeCtrl = Get.find<HomeController>();
        if (homeCtrl.bookings.isEmpty) {
          await homeCtrl.fetchBookings();
        }
        if (homeCtrl.bookings.isNotEmpty) {
          final firstBooking = homeCtrl.bookings.first;
          packageId = firstBooking.package?.id;
          coverImage.value = firstBooking.package?.coverImage;
        }
      }
      if (packageId != null) {
        await fetchCommunityInfo(packageId);
        if (community.value != null) {
          await fetchNotificationPreference();
          await fetchMessages();
          // Start polling for new messages every 5 seconds
        }
      }
    } catch (e) {
      debugPrint("Error initializing community: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> listenForNewMessages() async {
    socketService.onNewMessage.listen((data) {
      log('--------------------socket data-------------------------');
      log(data.toString());

      // Handle both wrapped and unwrapped data
      final messageJson = data["data"] ?? data;

      try {
        final newMessage = CommunityMessage.fromJson(messageJson);

        // Ensure message belongs to current community
        if (newMessage.community == community.value?.id) {
          // Check for deduplication
          final alreadyExists = messages.any((msg) => msg.id == newMessage.id);

          if (!alreadyExists) {
            // Insert at 0 because we use reverse: true in ListView
            messages.insert(0, newMessage);
            _scrollToBottom();
          }
        }
      } catch (e) {
        debugPrint("Error parsing socket message: $e");
      }
    });
  }

  Future<void> connectToCommunity() async {
    socketService.emitEvent(communityId);
    // socketService.e((data) {
    //   data = data["data"];
    //   log('--------------------socket data-------------------------');
    //   log(data.toString());
    //   // if (data['orderId'] == order!.id) {
    //   //   int index = messages.indexWhere((e) => e.id == data["_id"]);
    //   //   if (index == -1) {
    //   //     messages.add(_ChatMessage(id: data["_id"], text: data['message'], isMe: false));
    //   //     log(messages.toJson().toString());
    //   //   }
    //   // }
    // });
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
      communityId = community.value!.id;
      final response = await ApiManager.instance.call(
        endPoint: "${BACKEND.communityMessages}${community.value!.id}/messages?limit=50&page=1",
        type: ApiType.get,
      );

      if (response.status == 200 || response.status == 1) {
        final messagesData = MessagesResponse.fromJson(response.data);
        var newMsgs = messagesData.messages ?? [];

        // For a WhatsApp-like experience (reverse: true), we need the newest message at index 0
        // If the API returns chronological order (oldest first), we reverse it
        if (newMsgs.isNotEmpty && newMsgs.length > 1) {
          final firstTime = newMsgs.first.createdAt;
          final lastTime = newMsgs.last.createdAt;
          if (firstTime != null && lastTime != null && firstTime.isBefore(lastTime)) {
            newMsgs = newMsgs.reversed.toList();
          }
        }

        if (newMsgs.length != messages.length) {
          messages.assignAll(newMsgs);
          _scrollToBottom();
        }
      }
    } catch (e) {
      debugPrint("Error fetching messages: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> fetchNotificationPreference() async {
    if (community.value == null) return;
    try {
      final response = await ApiManager.instance.call(endPoint: BACKEND.communityNotificationPreference(community.value!.id!), type: ApiType.get);

      if (response.status == 200 || response.status == 1) {
        notificationEnabled.value = response.data["notificationsEnabled"] ?? true;
      }
    } catch (e) {
      debugPrint("Error fetching notification preference: $e");
    }
  }

  Future<void> toggleNotificationPreference() async {
    if (community.value == null) return;
    try {
      final newValue = !notificationEnabled.value;
      final response = await ApiManager.instance.call(
        endPoint: BACKEND.communityNotificationPreference(community.value!.id!),
        type: ApiType.patch,
        body: {"enabled": newValue},
      );

      if (response.status == 200 || response.status == 1) {
        notificationEnabled.value = newValue;
        successToast("Notifications ${newValue ? 'enabled' : 'disabled'}");
      } else {
        errorToast("Failed to update notification preference");
      }
    } catch (e) {
      debugPrint("Error toggling notification preference: $e");
      errorToast("Something went wrong");
    }
  }

  Future<void> sendMessage() async {
    final content = messageController.text.trim();
    if (content.isEmpty || community.value == null) return;

    try {
      isSending.value = true;
      communityId = community.value!.id;
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
      communityId = community.value!.id;
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
          errorToast(response.message);
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
          0, // With reverse: true, 0 is the bottom (latest message)
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }
}
