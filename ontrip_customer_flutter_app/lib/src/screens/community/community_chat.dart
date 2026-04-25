import 'dart:io';

import '../../../../../app_export.dart';

class CommunityChatScreen extends StatelessWidget {
  const CommunityChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityChatCtrl>(
      init: CommunityChatCtrl(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: _buildAppBar(controller),
          body: Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value && controller.messages.isEmpty) {
                    return const Center(child: CustomLoadingIndicator());
                  }
                  if (controller.community.value == null) {
                    return const Center(child: NoDataComponent(text: "No community found for your current trip"));
                  }
                  if (controller.messages.isEmpty) {
                    return const Center(child: Text("Start the conversation!"));
                  }
                  return ListView.builder(
                    controller: controller.scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller.messages[index];
                      return _buildMessageBubble(message);
                    },
                  );
                }),
              ),
              _buildInputArea(controller),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(CommunityChatCtrl controller) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 100,

      leading: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF1E293B)),
          ),
          // const SizedBox(width: 5),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
            child: Obx(() {
              final img = controller.coverImage.value;
              return ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: img != null && img.isNotEmpty
                    ? CustomNetworkImage(imageUrl: "https://ontrip.itfuturz.in/$img", height: 45, width: 45, fit: BoxFit.cover)
                    : const Icon(Icons.forum_outlined, color: Color(0xFF4338CA), size: 24),
              );
            }),
          ),
        ],
      ),
      title: Obx(() {
        final title = controller.community.value?.package?.title ?? "Community";
        final participants = (controller.community.value?.agentMembers?.length ?? 0) + (controller.community.value?.customerMembers?.length ?? 0);
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyle.bold.copyWith(fontSize: 16, color: const Color(0xFF1E293B))),
                  Text("$participants participants", style: AppTextStyle.medium.copyWith(fontSize: 12, color: const Color(0xFF64748B))),
                ],
              ),
            ),
          ],
        );
      }),
      actions: [
        Obx(
          () => GestureDetector(
            onTap: () {
              if (controller.community.value != null) {
                controller.toggleNotificationPreference();
              } else {
                warningToast("Community not loaded yet");
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: controller.notificationEnabled.value
                    ? (Constant.instance.primary).withValues(alpha: 0.2)
                    : Constant.instance.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                controller.notificationEnabled.value ? Icons.notifications_active_outlined : Icons.notifications_off_outlined,
                color: controller.notificationEnabled.value ? Constant.instance.primary : Constant.instance.grey,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () {
            final community = controller.community.value;
            if (community != null) {
              Get.toNamed(RouteNames.groupMembers, arguments: community);
            } else {
              warningToast("Community not loaded yet");
            }
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: (Constant.instance.orange).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.group_outlined, color: Constant.instance.orange, size: 20),
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () {
            final community = controller.community.value;
            if (community != null) {
              Get.toNamed(RouteNames.communityMedia, arguments: community.id);
            } else {
              warningToast("Community not loaded yet");
            }
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: (Constant.instance.apple).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.image_outlined, color: Constant.instance.apple, size: 20),
          ),
        ),

        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildMessageBubble(CommunityMessage message) {
    final authCtrl = Get.find<AuthenticationController>();
    final isMe = message.sender is Map && message.sender["_id"] == authCtrl.userAuthData["_id"];
    final time = message.createdAt != null ? AppDateFormat.hhmma(message.createdAt!) : "";

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Text(message.senderName, style: AppTextStyle.bold.copyWith(fontSize: 11, color: const Color(0xFF64748B))),
            ),
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[_buildAvatar(message.senderName, isMe: false), const SizedBox(width: 8)],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFF4338CA) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                    boxShadow: isMe ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMessageContent(message, isMe),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style: AppTextStyle.medium.copyWith(fontSize: 10, color: isMe ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
              ),
              if (isMe) const SizedBox(width: 32), // Padding on right for self messages
              if (!isMe) const SizedBox(width: 32), // Padding on left for others
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String name, {required bool isMe}) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(color: isMe ? const Color(0xFF4338CA) : const Color(0xFFE2E8F0), shape: BoxShape.circle),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : "?",
          style: AppTextStyle.bold.copyWith(fontSize: 10, color: isMe ? Colors.white : const Color(0xFF64748B)),
        ),
      ),
    );
  }

  Widget _buildMessageContent(CommunityMessage message, bool isMe) {
    if (message.type == "image") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomNetworkImage(imageUrl: "https://ontrip.itfuturz.in/${message.imageUrl}", width: 200),
          ),
          if (message.content?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(message.content!, style: AppTextStyle.medium.copyWith(fontSize: 14, color: isMe ? Colors.white : const Color(0xFF1E293B))),
          ],
        ],
      );
    }
    return Text(message.content ?? "", style: AppTextStyle.medium.copyWith(fontSize: 14, color: isMe ? Colors.white : const Color(0xFF1E293B)));
  }

  Widget _buildInputArea(CommunityChatCtrl controller) {
    return Obx(() {
      final hasImages = controller.selectedImages.isNotEmpty;
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Image Preview Strip ──
              if (hasImages)
                SizedBox(
                  height: 88,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    itemCount: controller.selectedImages.length,
                    itemBuilder: (context, index) {
                      final file = controller.selectedImages[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(File(file.path), height: 72, width: 72, fit: BoxFit.cover),
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: () => controller.removeImage(index),
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                  child: const Icon(Icons.close, color: Colors.white, size: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              // ── Input Row ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: controller.pickImages,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: hasImages ? const Color(0xFF4338CA) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Icon(Icons.camera_alt_outlined, color: hasImages ? Colors.white : const Color(0xFF64748B), size: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: TextField(
                          controller: controller.messageController,
                          decoration: InputDecoration(
                            hintText: hasImages ? "Caption (optional)" : "Type a message...",
                            hintStyle: AppTextStyle.medium.copyWith(color: const Color(0xFF94A3B8), fontSize: 14),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: controller.isSending.value
                          ? null
                          : () {
                              if (controller.selectedImages.isNotEmpty) {
                                controller.sendImages();
                              } else {
                                controller.sendMessage();
                              }
                            },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(color: Color(0xFF4338CA), shape: BoxShape.circle),
                        child: controller.isSending.value
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
