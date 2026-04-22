import '../../../../../app_export.dart';

class CommunityMediaScreen extends GetView<CommunityMediaCtrl> {
  const CommunityMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Community Gallery",
          style: TextStyle(color: Color(0xFF1E293B), fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF1E293B)),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.fetchImages(refresh: true),
            icon: const Icon(Icons.refresh, color: Color(0xFF1E293B)),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Obx(() {
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
                return GestureDetector(
                  onTap: () {
                    // Navigate to full screen image view if needed
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomNetworkImage(imageUrl: "${AppNetworkConstants.baseURL}${image.imageUrl}", fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
