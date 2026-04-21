import 'package:ontrip_customer_flutter_app/src/helper/decoration.dart';
import 'package:ontrip_customer_flutter_app/src/screens/auth/sign_in/sign_in_ctrl.dart';

import '../../../../app_export.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _slideController = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInCtrl>(
      builder: (ctrl) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: PopScope(
            canPop: false,
            child: Scaffold(
              backgroundColor: const Color(0xFFF8FAFC),
              body: Container(
                padding: EdgeInsets.all(16),
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
                    child: ListView(
                      shrinkWrap: true,
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: ClampingScrollPhysics(),
                      children: [_buildSignInFormCard(ctrl), _buildFooterSection()],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignInFormCard(SignInCtrl ctrl) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 32, offset: const Offset(0, 12)),
              BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_buildWelcomeSection(), const SizedBox(height: 28), _buildCredentialField(ctrl), const SizedBox(height: 28), _buildSignInButton(ctrl)],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
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
        Text(
          "Welcome Back",
          style: TextStyle(fontSize: 22, color: Colors.grey.shade900, fontWeight: FontWeight.w800, letterSpacing: -0.2),
        ),
        const SizedBox(height: 6),
        Text(
          "Sign in to access your professional dashboard",
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildCredentialField(SignInCtrl ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Phone Number",
          style: TextStyle(fontSize: 13, color: Colors.grey.shade800, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: TextFormField(
            controller: ctrl.txtPhoneNumber,
            keyboardType: TextInputType.phone,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
            decoration: InputDecoration(
              hintText: "Enter Phone number",
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              prefixIcon: Container(
                margin: const EdgeInsets.all(10),
                child: Icon(Icons.phone_android_rounded, size: 20, color: Colors.grey.shade600),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: decoration.colorScheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onChanged: (value) => ctrl.update(),
            // onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton(SignInCtrl ctrl) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [decoration.colorScheme.primary, decoration.colorScheme.primary.withValues(alpha: 0.9)],
          ),
          boxShadow: [BoxShadow(color: decoration.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: ctrl.isLoadingForSignIn.value ? null : ctrl.signIn,
            child: Container(
              alignment: Alignment.center,
              child: ctrl.isLoadingForSignIn.value
                  ? SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation(Colors.white.withValues(alpha: 0.9))),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login_rounded, color: Colors.white, size: 22),
                        const SizedBox(width: 12),
                        Text(
                          "SIGN IN",
                          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 1.0),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("By signing in, you agree to our", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 4,
              children: [
                GestureDetector(
                  onTap: () => AppUrl.urlLaunch(url: StringConstants.privacyPolicy),
                  child: Text(
                    "Terms of Service",
                    style: TextStyle(fontSize: 12, color: decoration.colorScheme.primary, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                  ),
                ),
                Text(" and ", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                GestureDetector(
                  onTap: () => AppUrl.urlLaunch(url: StringConstants.privacyPolicy),
                  child: Text(
                    "Privacy Policy",
                    style: TextStyle(fontSize: 12, color: decoration.colorScheme.primary, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("© 2024 OnTrip. All rights reserved.", style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}
