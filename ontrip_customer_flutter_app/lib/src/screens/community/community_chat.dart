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
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Container(
          decoration: BoxDecoration(color: const Color(0xFF4338CA), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.forum_outlined, color: Colors.white, size: 24),
        ),
      ),
      title: Obx(() {
        final title = controller.community.value?.package?.title ?? "Community";
        final participants = (controller.community.value?.agentMembers?.length ?? 0) + (controller.community.value?.customerMembers?.length ?? 0);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyle.bold.copyWith(fontSize: 16, color: const Color(0xFF1E293B))),
            Text("$participants participants", style: AppTextStyle.medium.copyWith(fontSize: 12, color: const Color(0xFF64748B))),
          ],
        );
      }),
      actions: [
        IconButton(
          onPressed: () {
            final community = controller.community.value;
            if (community != null) {
              Get.toNamed(RouteNames.groupMembers, arguments: community);
            } else {
              warningToast("Community not loaded yet");
            }
          },
          icon: const Icon(Icons.group_outlined, color: Color(0xFF64748B)),
        ),
        IconButton(
          onPressed: () {
            final community = controller.community.value;
            if (community != null) {
              Get.toNamed(RouteNames.communityMedia, arguments: community.id);
            } else {
              warningToast("Community not loaded yet");
            }
          },
          icon: const Icon(Icons.image_outlined, color: Color(0xFF64748B)),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildMessageBubble(CommunityMessage message) {
    final authCtrl = Get.find<AuthenticationController>();
    final isMe = message.sender is Map && message.sender["_id"] == authCtrl.userAuthData["_id"];
    final time = message.createdAt != null ? "${message.createdAt!.hour}:${message.createdAt!.minute.toString().padLeft(2, '0')}" : "";

    if (isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(message.senderName, style: AppTextStyle.bold.copyWith(fontSize: 12, color: const Color(0xFF1E293B))),
                const SizedBox(width: 4),
                Text("• Traveler", style: AppTextStyle.medium.copyWith(fontSize: 10, color: const Color(0xFF94A3B8))),
                const SizedBox(width: 8),
                _buildAvatar(message.senderName, isMe: true),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF4338CA),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: _buildMessageContent(message, true),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.done_all, size: 14, color: Color(0xFF94A3B8)),
                const SizedBox(width: 4),
                Text(time, style: AppTextStyle.medium.copyWith(fontSize: 10, color: const Color(0xFF94A3B8))),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildAvatar(message.senderName, isMe: false),
                const SizedBox(width: 8),
                Text(message.senderName, style: AppTextStyle.bold.copyWith(fontSize: 12, color: const Color(0xFF1E293B))),
                const SizedBox(width: 4),
                Text("• ${message.senderType?.toLowerCase() ?? 'admin'}", style: AppTextStyle.medium.copyWith(fontSize: 10, color: const Color(0xFF94A3B8))),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: _buildMessageContent(message, false),
            ),
            const SizedBox(height: 4),
            Text(time, style: AppTextStyle.medium.copyWith(fontSize: 10, color: const Color(0xFF94A3B8))),
          ],
        ),
      );
    }
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
