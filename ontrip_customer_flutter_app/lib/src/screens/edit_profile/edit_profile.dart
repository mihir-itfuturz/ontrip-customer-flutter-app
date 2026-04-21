import 'package:ontrip_customer_flutter_app/src/screens/auth/authentication_controller.dart';

import '../../../../app_export.dart';

class EditProfileCtrl extends GetxController {
  final AuthenticationController authService = Get.find();

  late TextEditingController nameController;
  late TextEditingController emailController;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final userData = authService.userAuthData;
    nameController = TextEditingController(text: userData['name'] ?? "");
    emailController = TextEditingController(text: userData['email'] ?? "");
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  void discardChanges() {
    Get.back();
  }

  Future<void> saveChanges() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      warningToast("Please fill all fields");
      return;
    }

    try {
      isLoading.value = true;
      final body = {"name": nameController.text.trim(), "email": emailController.text.trim()};

      final response = await ApiManager.instance.call(endPoint: BACKEND.profileUpdate, type: ApiType.put, body: body);

      if (response.status == 200 || response.status == 1) {
        // Update local data
        authService.userAuthData.addAll(body);
        successToast("Profile updated successfully");
        Get.back();
      } else {
        errorToast(response.message ?? "Update failed");
      }
    } catch (e) {
      errorToast("Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}

class EditProfileScreen extends GetView<EditProfileCtrl> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = controller.authService.userAuthData;
    final name = userData['name'] ?? "User";

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Edit Profile", style: AppTextStyle.bold.copyWith(fontSize: 18)),
        centerTitle: true,
        leading: const CustomBackBtn(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Image/Icon Section
            _buildAvatarHeader(name),
            const SizedBox(height: 30),
            // Form Section
            _buildEditForm(),
            const SizedBox(height: 40),
            // Actions Section
            _buildActionButtons(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarHeader(String name) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Constant.instance.primary, width: 3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(name.isNotEmpty ? name[0].toUpperCase() : "U", style: AppTextStyle.bold.copyWith(color: Constant.instance.primary, fontSize: 50)),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                child: const Icon(Icons.verified_user, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(name, style: AppTextStyle.bold.copyWith(fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Constant.instance.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.person_outline, color: Constant.instance.primary),
              ),
              const SizedBox(width: 16),
              Text("IDENTITY DETAILS", style: AppTextStyle.bold.copyWith(fontSize: 16)),
              const Spacer(),
              IconButton(
                onPressed: controller.discardChanges,
                icon: Icon(Icons.close, color: Colors.grey.shade400, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _buildTextField(label: "PUBLIC FULL NAME", controller: controller.nameController, icon: Icons.person_outline),
          const SizedBox(height: 24),
          _buildTextField(label: "PRIMARY EMAIL ADDRESS", controller: controller.emailController, icon: Icons.email_outlined),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.bold.copyWith(fontSize: 10, color: Colors.grey.shade400, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)),
          child: TextField(
            controller: controller,
            style: AppTextStyle.bold.copyWith(fontSize: 16),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Constant.instance.primary.withValues(alpha: 0.5), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: controller.discardChanges,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text("DISCARD", style: AppTextStyle.bold.copyWith(fontSize: 14, color: Colors.grey.shade600, letterSpacing: 1)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Obx(() {
              return CustomBtn(text: "SAVE CHANGES", onTap: controller.saveChanges, isLoading: controller.isLoading.value, prefix: Icon(Icons.save_outlined));
            }),
          ),
        ],
      ),
    );
  }
}
