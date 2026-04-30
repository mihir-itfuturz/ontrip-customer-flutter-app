import 'dart:io';
import '../../../../../app_export.dart';
import '../../source/selfie_ui.dart';
import '../common/media_display_screen.dart';

class CommunityMediaScreen extends GetView<CommunityMediaCtrl> {
  const CommunityMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Obx(
        () => PopScope(
          canPop: !controller.selectionMode.value,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && controller.selectionMode.value) {
              controller.toggleSelectionMode(false);
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                controller.selectionMode.value ? "${controller.selectedMediaIds.length} selected" : "Community Gallery",
                style: const TextStyle(color: Color(0xFF1E293B), fontSize: 18, fontWeight: FontWeight.w600),
              ),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  if (controller.selectionMode.value) {
                    controller.toggleSelectionMode(false);
                    return;
                  }
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF1E293B)),
              ),
              actions: [_buildAppBarActions(context)],
              elevation: 0,
              backgroundColor: Colors.white,
              bottom: TabBar(
                onTap: (index) => controller.switchTab(index),
                labelColor: Constant.instance.primary,
                unselectedLabelColor: const Color(0xFF1E293B).withValues(alpha: 0.5),
                indicatorColor: Constant.instance.primary,
                tabs: const [
                  Tab(text: "All Photos"),
                  Tab(text: "My Photos"),
                ],
              ),
            ),
            body: TabBarView(children: [_buildAllPhotosTab(), _buildMyPhotosTab(context)]),
          ),
        ),
      ),
    );
  }

  Widget _buildAllPhotosTab() {
    return Obx(() {
      if (controller.isLoading.value && controller.images.isEmpty) {
        return const Center(child: CustomLoadingIndicator());
      }

      if (controller.images.isEmpty) {
        return Center(child: NoDataComponent(text: "No images found in this community"));
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
            controller.loadMore();
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: () => controller.fetchImages(refresh: true),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1),
            itemCount: controller.images.length + (controller.isLoading.value ? 3 : 0),
            itemBuilder: (context, index) {
              if (index >= controller.images.length) {
                return Container(
                  decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: CustomLoadingIndicator()),
                );
              }

              final image = controller.images[index];
              return Obx(() {
                final isSelected = controller.isSelected(image.id);
                final isSelectionMode = controller.selectionMode.value;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (isSelectionMode) {
                      controller.toggleMediaSelection(image);
                    } else {
                      _openMedia(image);
                    }
                  },
                  onLongPress: () {
                    controller.toggleSelectionMode(true);
                    controller.toggleMediaSelection(image);
                  },
                  child: _buildMediaTile(media: image, isSelected: isSelected, showSelectionUi: isSelectionMode, showOwnerTag: controller.isOwnMedia(image)),
                );
              });
            },
          ),
        ),
      );
    });
  }

  Widget _buildMyPhotosTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("My Photos", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                    Obx(() {
                      if (controller.faceStatus.value == FaceStatus.hasMatches) {
                        return const Text("Found your photos", style: TextStyle(fontSize: 16, color: Colors.black54));
                      }
                      return const Text("Find yourself in the collection", style: TextStyle(fontSize: 16, color: Colors.black54));
                    }),
                  ],
                ),
              ),
              _buildRefreshButton(context),
            ],
          ),
          const SizedBox(height: 24),
          Obx(() => _buildMyPhotosContent(context)),
        ],
      ),
    );
  }

  Widget _buildRefreshButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _showRefreshDialog(context),
      icon: const Icon(Icons.refresh, size: 20),
      label: const Text("Refresh", style: TextStyle(fontWeight: FontWeight.bold)),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1E293B),
        side: const BorderSide(color: Colors.black12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
      ),
    );
  }

  void _showRefreshDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Refresh Photos", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const SizedBox(height: 24),
                _buildRefreshOption(
                  icon: Icons.refresh_rounded,
                  title: "Use Existing Image",
                  subtitle: "Re-scan using your current selfie",
                  onTap: () {
                    Navigator.pop(context);
                    controller.checkFaceMatches();
                  },
                ),
                const SizedBox(height: 16),
                _buildRefreshOption(
                  icon: Icons.camera_alt_outlined,
                  title: "Take New Selfie",
                  subtitle: "Use a different photo for search",
                  onTap: () {
                    Navigator.pop(context);
                    _openSelfieUI(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRefreshOption({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(24)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
              ),
              child: Icon(icon, color: Constant.instance.primary, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyPhotosContent(BuildContext context) {
    if (controller.faceStatus.value == FaceStatus.loading) {
      return const Center(
        child: Padding(padding: EdgeInsets.all(32.0), child: CustomLoadingIndicator()),
      );
    }

    if (controller.faceStatus.value == FaceStatus.hasMatches && controller.matchedImages.isNotEmpty) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: controller.matchedImages.length,
        itemBuilder: (context, index) {
          final image = controller.matchedImages[index];
          return Obx(() {
            final isSelected = controller.isSelected(image.id);
            final isSelectionMode = controller.selectionMode.value;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (isSelectionMode) {
                  controller.toggleMediaSelection(image);
                } else {
                  _openMedia(image);
                }
              },
              onLongPress: () {
                controller.toggleSelectionMode(true);
                controller.toggleMediaSelection(image);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildMediaTile(media: image, isSelected: isSelected, showSelectionUi: isSelectionMode, showOwnerTag: controller.isOwnMedia(image)),
              ),
            );
          });
        },
      );
    }

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.black.withValues(alpha: 0.03), width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: Color(0xFFF8F9FA), shape: BoxShape.circle),
              child: const Icon(Icons.camera_alt_outlined, size: 48, color: Colors.black12),
            ),
            const SizedBox(height: 24),
            const Text("No Photos Found", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              "Take a selfie to find your photos from this collection automatically.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openSelfieUI(context),
                icon: const Icon(Icons.camera_alt),
                label: const Text("Take a Selfie", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.instance.primary, // Brand color
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSelfieUI(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelfieUI(distributorName: '', isProfile: false, communityId: controller.communityId),
      ),
    );

    if (result != null && result is File) {
      controller.findMyPhotos(selfie: result);
    } else {
      warningToast('Please capture a selfie to proceed');
    }
  }

  void _openMedia(CommunityImage media) {
    final url = controller.resolveMediaUrl(media);
    if (url == null) return;
    Get.to(() => MediaDisplayScreen(url: url, isVideo: controller.isVideoMedia(media)));
  }

  Widget _buildMediaTile({required CommunityImage media, required bool isSelected, required bool showSelectionUi, bool showOwnerTag = false}) {
    final resolved = controller.resolveMediaUrl(media);
    final isVideo = controller.isVideoMedia(media);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomNetworkImage(imageUrl: resolved, fit: BoxFit.cover),
            if (isVideo)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), shape: BoxShape.circle),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
                ),
              ),
            // if (isSelected)
            //   Positioned.fill(
            //     child: Container(
            //       color: Colors.black.withValues(alpha: 0.35),
            //       child: const Center(child: Icon(Icons.check_circle, color: Colors.white, size: 30)),
            //     ),
            //   ),
            if (showSelectionUi)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? Constant.instance.primary : Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? Constant.instance.primary : const Color(0xFFCBD5E1), width: 1.5),
                  ),
                  child: Icon(isSelected ? Icons.check : Icons.circle_outlined, size: 16, color: isSelected ? Colors.white : const Color(0xFF64748B)),
                ),
              ),
            if (showOwnerTag)
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Constant.instance.primary, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isVideo ? Icons.video_library_rounded : Icons.person_rounded, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        isVideo ? "My Video" : "My Photo",
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarActions(BuildContext context) {
    if (controller.selectionMode.value) {
      final selectableIds = _selectableMediaIds();
      final allSelected = selectableIds.isNotEmpty && controller.selectedMediaIds.length == selectableIds.length;
      return Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: selectableIds.isEmpty
                ? null
                : () {
                    if (allSelected) {
                      controller.selectedMediaIds.clear();
                    } else {
                      controller.selectedMediaIds.assignAll(selectableIds);
                    }
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Row(
                children: [
                  Icon(allSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, color: const Color(0xFF1E293B)),
                  const SizedBox(width: 4),
                  Text(allSelected ? "Unselect all" : "Select all", style: const TextStyle(color: Color(0xFF1E293B), fontSize: 13)),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: controller.selectedMediaIds.isEmpty ? null : () => controller.downloadSelectedMedia(),
            icon: const Icon(Icons.download_rounded, color: Color(0xFF1E293B)),
          ),
          IconButton(
            onPressed: controller.selectedMediaIds.isEmpty ? null : () => _confirmDeleteSelected(context),
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
          ),
        ],
      );
    }
    return IconButton(
      onPressed: () => controller.fetchImages(refresh: true),
      icon: const Icon(Icons.refresh, color: Color(0xFF1E293B)),
    );
  }

  List<String> _selectableMediaIds() {
    final ids = <String>{};
    for (final item in controller.images) {
      if ((item.id ?? '').isNotEmpty) ids.add(item.id!);
    }
    for (final item in controller.matchedImages) {
      if ((item.id ?? '').isNotEmpty) ids.add(item.id!);
    }
    return ids.toList();
  }

  void _confirmDeleteSelected(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete selected media?"),
        content: Text("This will remove ${controller.selectedMediaIds.length} item(s)."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await controller.deleteSelectedMedia();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
