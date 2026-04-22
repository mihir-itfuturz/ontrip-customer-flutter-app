import '../../../../../app_export.dart';

class CommunityMediaCtrl extends GetxController {
  final RxList<CommunityImage> images = <CommunityImage>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  
  late String communityId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is String) {
      communityId = args;
    } else {
      communityId = "";
    }
    
    if (communityId.isNotEmpty) {
      fetchImages();
    }
  }

  Future<void> fetchImages({bool refresh = false}) async {
    if (communityId.isEmpty) return;

    if (refresh) {
      currentPage.value = 1;
    }
    
    try {
      isLoading.value = true;
      final response = await ApiManager.instance.call(
        endPoint: "${BACKEND.communityImages(communityId)}?page=${currentPage.value}&limit=12",
        type: ApiType.get,
      );

      if (response.status == 200 || response.status == 1) {
        final mediaData = CommunityMediaResponse.fromJson(response.data);
        if (mediaData.images != null) {
          if (refresh) {
            images.assignAll(mediaData.images!);
          } else {
            images.addAll(mediaData.images!);
          }
        }
        if (mediaData.pagination != null) {
          totalPages.value = mediaData.pagination!.totalPages ?? 1;
        }
      }
    } catch (e) {
      debugPrint("Error fetching community images: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void loadMore() {
    if (currentPage.value < totalPages.value && !isLoading.value) {
      currentPage.value++;
      fetchImages();
    }
  }
}
