import 'package:ontrip_customer_flutter_app/src/helper/decoration.dart';
import 'package:ontrip_customer_flutter_app/src/screens/auth/sign_in/sign_in_ctrl.dart';

import '../../../../app_export.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> with TickerProviderStateMixin {
  late AnimationController _fadeController, _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _companyAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final RxBool _isLoading = false.obs;
  final RxBool _showPassword = false.obs;
  final RxBool _showConfirmPassword = false.obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _slideController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () => _slideController.forward());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _companyNameController.dispose();
    _positionController.dispose();
    _companyAddressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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
            child: ListView(shrinkWrap: true, physics: const ClampingScrollPhysics(), children: [_buildSignUpFormCard(), _buildFooterSection()]),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpFormCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 32, offset: const Offset(0, 12)),
              BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 28),
                _buildPersonalInfoSection(),
                const SizedBox(height: 24),
                _buildCompanyInfoSection(),
                const SizedBox(height: 24),
                _buildPasswordSection(),
                const SizedBox(height: 32),
                _buildCreateAccountButton(),
                const SizedBox(height: 20),
                _buildAlreadyHaveAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.close(1),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Icon(Icons.arrow_back_rounded, color: decoration.colorScheme.primary, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Account",
                style: TextStyle(fontSize: 22, color: Colors.grey.shade900, fontWeight: FontWeight.w800, letterSpacing: -0.2),
              ),
              const SizedBox(height: 6),
              Text(
                "Join OnTrip in a few quick steps",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Personal Information",
          style: TextStyle(fontSize: 16, color: Colors.grey.shade900, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text("Tell us about yourself", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 16),
        _buildInputField(
          label: "Full Name",
          hintText: "John Doe",
          controller: _fullNameController,
          prefixIcon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your full name";
            }
            if (value.length < 2) {
              return "Name must be at least 2 characters";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildInputField(
          label: "Email Address",
          hintText: "name@company.com",
          controller: _emailController,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your email address";
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return "Please enter a valid email address";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildInputField(
          label: "Mobile Number",
          hintText: "91 234567890",
          controller: _mobileController,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.numberWithOptions(signed: true),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your mobile number";
            }
            if (value.length < 10) {
              return "Please enter a valid mobile number";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCompanyInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Company Information",
          style: TextStyle(fontSize: 16, color: Colors.grey.shade900, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text("Tell us about your company", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 16),
        _buildInputField(
          label: "Company Name",
          hintText: "ACME Corporation",
          controller: _companyNameController,
          prefixIcon: Icons.business_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your company name";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildInputField(
          label: "Position/Role",
          hintText: "Founder, Sales Lead",
          controller: _positionController,
          prefixIcon: Icons.work_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your position";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildInputField(
          label: "Company Address",
          hintText: "Street, City, State, Country",
          controller: _companyAddressController,
          prefixIcon: Icons.location_on_outlined,
          maxLines: 2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter company address";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Security",
          style: TextStyle(fontSize: 16, color: Colors.grey.shade900, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text("Create a secure password", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 16),
        _buildPasswordField(label: "Password", controller: _passwordController, isConfirm: false),
        const SizedBox(height: 16),
        _buildPasswordField(label: "Confirm Password", controller: _confirmPasswordController, isConfirm: true),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text("Password must be at least 6 characters", style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade800, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            textInputAction: TextInputAction.done,
            maxLength: keyboardType == TextInputType.numberWithOptions(signed: true) ? 10 : null,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
            decoration: InputDecoration(
              counterText: "",
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              prefixIcon: Container(
                margin: const EdgeInsets.all(10),
                child: Icon(prefixIcon, size: 20, color: Colors.grey.shade600),
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.red.shade400, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: maxLines > 1 ? 12 : 16),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({required String label, required TextEditingController controller, required bool isConfirm}) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade800, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: TextFormField(
              controller: controller,
              obscureText: isConfirm ? !_showConfirmPassword.value : !_showPassword.value,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade800),
              decoration: InputDecoration(
                hintText: "Enter your password",
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(10),
                  child: Icon(Icons.lock_outline, size: 20, color: Colors.grey.shade600),
                ),
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 4),
                  child: IconButton(
                    icon: Icon(
                      isConfirm
                          ? (_showConfirmPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined)
                          : (_showPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    onPressed: () {
                      if (isConfirm) {
                        _showConfirmPassword.value = !_showConfirmPassword.value;
                      } else {
                        _showPassword.value = !_showPassword.value;
                      }
                    },
                  ),
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
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.red.shade400, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your password";
                }
                if (value.length < 6) {
                  return "Password must be at least 6 characters";
                }
                if (isConfirm && value != _passwordController.text) {
                  return "Passwords do not match";
                }
                return null;
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCreateAccountButton() {
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
            onTap: _isLoading.value ? null : _createAccount,
            child: Container(
              alignment: Alignment.center,
              child: _isLoading.value
                  ? SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation(Colors.white.withValues(alpha: 0.9))),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 22),
                        const SizedBox(width: 12),
                        Text(
                          "CREATE ACCOUNT",
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

  Widget _buildAlreadyHaveAccount() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Already have an account?",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: decoration.colorScheme.primary, width: 1.5),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Get.close(1),
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login_rounded, color: decoration.colorScheme.primary, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "BACK TO LOGIN",
                      style: TextStyle(fontSize: 15, color: decoration.colorScheme.primary, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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
            Text("Member Login | info@linket.com", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text("© 2024 OnTrip. All rights reserved.", style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      _isLoading.value = true;

      final Map<String, dynamic> registrationData = {
        "company": {
          "businessKeyword": "",
          "companyName": _companyNameController.text.trim(),
          "companyAddress": _companyAddressController.text.trim(),
          "companyRole": _positionController.text,
        },
        "products": [
          {"amount": 500, "name": "nfc-card"},
        ],
        "user": {
          "emailId": _emailController.text.trim(),
          "mobile": _mobileController.text.trim(),
          "name": _fullNameController.text.trim(),
          "password": _passwordController.text,
        },
      };

      final response = await ApiManager.instance.call(
        endPoint: BACKEND.signUp,
        body: registrationData,
        customHeaders: {'admin-id': '67ca6934c15747af04fff36c'},
      );

      if (response.status == 200 && response.data != null && response.data != 0) {
        successToast("Account created successfully!");
        if (Get.isRegistered<SignInCtrl>()) {
          final signInCtrl = Get.find<SignInCtrl>();
          signInCtrl.txtEmailId.text = _emailController.text;
          signInCtrl.edtPassword.text = _passwordController.text;
        }

        Get.close(1);
        successToast("Please sign in with your new account");
      } else {
        errorToast(response.message);
      }
    } catch (e) {
      errorToast("An error occurred. Please try again.");
    } finally {
      _isLoading.value = false;
    }
  }
}
