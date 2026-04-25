import 'dart:io';
import '../../../../../app_export.dart';

class CommunityMediaCtrl extends GetxController {
  final RxList<CommunityImage> images = <CommunityImage>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  
  // Tab control
  final RxInt selectedTabIndex = 0.obs;

  // Face Matching State
  final Rx<FaceStatus> faceStatus = FaceStatus.initial.obs;
  final RxList<CommunityImage> matchedImages = <CommunityImage>[].obs;
  
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

  void switchTab(int index) {
    selectedTabIndex.value = index;
    if (index == 1 && faceStatus.value == FaceStatus.initial) {
      checkFaceMatches();
    }
  }

  Future<void> checkFaceMatches() async {
    // This is typically called API checking if faces are already matched.
    // If not, we set it to initial or noMatches so User can capture new selfie.
    try {
      faceStatus.value = FaceStatus.loading;
      // Mock API call or integrate real API if available
      await Future.delayed(const Duration(seconds: 1));
      
      // Since we don't have the real endpoint, let's mock it to 'noMatches' by default
      // to allow users to trigger the SelfieUI.
      // If there was an endpoint:
      // final res = await ApiManager.instance.call(endPoint: '...', type: ApiType.get);
      
      faceStatus.value = FaceStatus.noMatches;
    } catch (e) {
      faceStatus.value = FaceStatus.error;
    }
  }

  Future<void> findMyPhotos({required File selfie}) async {
    try {
      faceStatus.value = FaceStatus.loading;
      // Real API integration would upload the selfie using FormData.
      // e.g. FormData formData = FormData.fromMap({ "selfie": await MultipartFile.fromFile(selfie.path) ... })
      await Future.delayed(const Duration(seconds: 2));

      // Mock setting some matched images (You can connect real data when API is ready)
      // matchedImages.assignAll([...]);
      // faceStatus.value = FaceStatus.hasMatches;
      
      // For now, let's just keep it to noMatches or an empty list if there's no actual API.
      // Assuming API would return no matches in the test:
      matchedImages.clear();
      faceStatus.value = FaceStatus.noMatches;
    } catch (e) {
      faceStatus.value = FaceStatus.error;
    }
  }
}

enum FaceStatus { initial, loading, hasMatches, noMatches, error }
