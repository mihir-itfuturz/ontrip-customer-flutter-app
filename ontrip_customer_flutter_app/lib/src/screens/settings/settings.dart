import '../../../../app_export.dart';
import 'settings_ctrl.dart';

class SettingsScreen extends GetView<SettingsCtrl> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("Settings", style: AppTextStyle.bold.copyWith(fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CustomBackBtn(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileCard(),
            const SizedBox(height: 30),
            _buildMenuSection(),
            const SizedBox(height: 40),
            _buildFooter(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Obx(() {
      final userData = controller.authService.userAuthData;
      final name = userData['name'] ?? "User Name";
      final email = userData['email'] ?? "user@example.com";
      final phone = userData['phone'] ?? "";

      return Container(
        width: Get.width,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Constant.instance.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Constant.instance.primary, width: 2),
                  ),
                  child: Center(
                    child: Text(name[0].toUpperCase(), style: AppTextStyle.bold.copyWith(color: Constant.instance.primary, fontSize: 40)),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(name, style: AppTextStyle.bold.copyWith(fontSize: 22)),
            const SizedBox(height: 4),
            Text(email, style: AppTextStyle.medium.copyWith(color: Colors.grey.shade600, fontSize: 14)),
            if (phone.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text("+91 $phone", style: AppTextStyle.medium.copyWith(color: Colors.grey.shade600, fontSize: 14)),
            ],
            const SizedBox(height: 24),
            CustomBtn(text: "EDIT PROFILE", onTap: controller.navigateToEditProfile, prefix: Icon(Icons.edit_outlined)),
          ],
        ),
      );
    });
  }

  Widget _buildMenuSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          _buildMenuItem(icon: Icons.description_outlined, title: "Terms & Conditions", onTap: controller.openTermsAndConditions),
          _buildDivider(),
          _buildMenuItem(icon: Icons.privacy_tip_outlined, title: "Privacy Policy", onTap: controller.openPrivacyPolicy),
          _buildDivider(),
          _buildMenuItem(icon: Icons.logout_rounded, title: "Logout", onTap: controller.logout, color: Colors.red.shade600, showChevron: false),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.delete_forever_outlined,
            title: "Delete Account",
            onTap: controller.deleteAccount,
            color: Colors.red.shade900,
            showChevron: false,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required VoidCallback onTap, Color? color, bool showChevron = true}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: (color ?? Constant.instance.primary).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color ?? Constant.instance.primary, size: 22),
      ),
      title: Text(title, style: AppTextStyle.medium.copyWith(fontSize: 16, color: color ?? Colors.grey.shade800)),
      trailing: showChevron ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400) : null,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey.shade100, indent: 60);
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text("Version 1.0.0", style: AppTextStyle.medium.copyWith(color: Colors.grey.shade400, fontSize: 12)),
        const SizedBox(height: 8),
        Text("Made with ❤️ by OnTrip", style: AppTextStyle.medium.copyWith(color: Colors.grey.shade400, fontSize: 12)),
      ],
    );
  }
}
