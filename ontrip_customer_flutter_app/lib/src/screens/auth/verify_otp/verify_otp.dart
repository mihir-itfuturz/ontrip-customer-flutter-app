import 'package:ontrip_customer_flutter_app/src/helper/decoration.dart';
import '../../../../app_export.dart';

class VerifyOTPScreen extends GetView<VerifyOTPCtrl> {
  const VerifyOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: const CustomBackBtn()),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFF8FAFC), Colors.blue.shade50.withValues(alpha: 0.5), Colors.blue.shade50.withValues(alpha: 0.2)],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [_buildHeader(), const SizedBox(height: 24), _buildOTPCard()]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(colors: [decoration.colorScheme.primary, decoration.colorScheme.primary.withValues(alpha: 0.7)]),
            boxShadow: [BoxShadow(color: decoration.colorScheme.primary.withValues(alpha: 0.2), blurRadius: 25, spreadRadius: 2)],
          ),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), shape: BoxShape.rectangle, color: Colors.white),
            child: Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                shape: BoxShape.rectangle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [decoration.colorScheme.primary, decoration.colorScheme.primary.withValues(alpha: 0.8)],
                ),
                image: DecorationImage(image: AssetImage(Graphics.instance.logo), fit: BoxFit.cover, opacity: 0.9),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text("Verify OTP", style: AppTextStyle.bold.copyWith(fontSize: 28, color: Colors.grey.shade900)),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyle.medium.copyWith(fontSize: 16, color: Colors.grey.shade600, height: 1.5),
              children: [
                const TextSpan(text: "We have sent a verification code to\n"),
                TextSpan(
                  text: "+91 ${controller.phone}",
                  style: AppTextStyle.bold.copyWith(color: Constant.instance.primary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOTPCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 32, offset: const Offset(0, 12))],
      ),
      child: Column(
        children: [
          TextField(
            controller: controller.otpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 4,
            style: AppTextStyle.bold.copyWith(fontSize: 24, letterSpacing: 34),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: "",
              hintText: "0000",
              hintStyle: TextStyle(color: Constant.instance.grey, letterSpacing: 34),
              filled: true,
              fillColor: Constant.instance.grey.withValues(alpha: 0.15),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
            ),
          ),
          const SizedBox(height: 32),
          Obx(() => _buildVerifyButton()),
          const SizedBox(height: 24),
          _buildResendOption(),
        ],
      ),
    );
  }

  Widget _buildVerifyButton() {
    return GestureDetector(
      onTap: controller.verifyOTP,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [Constant.instance.primary, Constant.instance.primary.withValues(alpha: 0.8)]),
          boxShadow: [BoxShadow(color: Constant.instance.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: controller.isLoading.value ? null : controller.verifyOTP,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: controller.isLoading.value
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : Text("Verify & Proceed", style: AppTextStyle.bold.copyWith(fontSize: 18, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResendOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Didn't receive the code? ", style: TextStyle(color: Colors.grey.shade600)),
        TextButton(
          onPressed: () {
            // Implement resend logic if needed
            successToast("OTP Resent successfully");
          },
          child: Text("Resend", style: AppTextStyle.bold.copyWith(color: Constant.instance.primary)),
        ),
      ],
    );
  }
}
