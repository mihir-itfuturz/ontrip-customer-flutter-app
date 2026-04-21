import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';

import '../../app_export.dart';

class CustomCountyFormField extends StatefulWidget {
  const CustomCountyFormField({
    super.key,
    this.controller,
    this.onCountryChanged,
    this.onChanged,
    this.label,
    this.labelStyle,
    this.onSaved,
    this.onSubmitted,
    this.fillColor,
    this.validator,
    this.initialValue,
    this.inputFormatters,
    this.keyboardType,
    this.hintText,
    this.readOnly = false,
    this.onTap,
    this.onSubmit,
    this.textInputAction,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.borderColor,
    this.style,
    this.isUnderlineBorder = false,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.country,
    this.isFloatingLabel = true,
    this.showRequiredIndicator = false,
  });

  final String? label;
  final TextStyle? labelStyle;
  final TextEditingController? controller;
  final void Function(Country)? onCountryChanged;
  final void Function(PhoneNumber)? onChanged;
  final Color? fillColor;
  final void Function(PhoneNumber?)? onSaved;
  final void Function(String)? onSubmitted;
  final String? Function(PhoneNumber?)? validator;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool readOnly;
  final void Function()? onTap;
  final ValueChanged<String>? onSubmit;
  final TextInputAction? textInputAction;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final Color? borderColor;
  final TextStyle? style;
  final bool isUnderlineBorder;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final Country? country;
  final bool isFloatingLabel;
  final bool showRequiredIndicator;

  @override
  State<CustomCountyFormField> createState() => _CustomCountyFormFieldState();
}

class _CustomCountyFormFieldState extends State<CustomCountyFormField> with SingleTickerProviderStateMixin {
  Country? _selectedCountry;
  bool _isFocused = false, _hasError = false;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.country ?? countries.firstWhere((country) => country.code == 'IN');
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    widget.focusNode?.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = widget.focusNode?.hasFocus ?? false;
    });
    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  InputBorder _buildBorder({Color? color, double width = 1.5, bool isError = false}) {
    Color borderColor =
        color ??
        (isError
            ? Colors.red.shade400
            : _isFocused
            ? (widget.borderColor ?? Constant.instance.primary)
            : Colors.grey.shade300);
    if (widget.isUnderlineBorder) {
      return UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: width),
      );
    } else {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: borderColor, width: width),
      );
    }
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      fillColor: widget.fillColor ?? (_isFocused ? Colors.white : Colors.grey.shade50),
      filled: true,
      prefixIcon: widget.prefix,
      suffixIcon: widget.suffix == null ? null : Container(margin: const EdgeInsets.only(right: 8), child: widget.suffix),
      suffixIconConstraints: const BoxConstraints(maxWidth: 48, maxHeight: 48),
      counterText: "",
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      isDense: false,
      constraints: const BoxConstraints(minHeight: 56),
      hintText: widget.hintText,
      hintMaxLines: 1,
      hintStyle: AppTextStyle.regular.copyWith(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.w400),
      border: _buildBorder(width: 0),
      focusedBorder: _buildBorder(color: widget.borderColor ?? Constant.instance.primary, width: 2.0),
      disabledBorder: _buildBorder(color: Colors.grey.shade200, width: 1.0),
      enabledBorder: _buildBorder(color: Colors.grey.shade300, width: 1.0),
      errorBorder: _buildBorder(color: Colors.red.shade400, width: 1.5, isError: true),
      focusedErrorBorder: _buildBorder(color: Colors.red.shade400, width: 2.0, isError: true),
      errorMaxLines: 2,
      errorStyle: AppTextStyle.regular.copyWith(fontSize: 13, color: Colors.red.shade600, fontWeight: FontWeight.w400),
      floatingLabelBehavior: widget.isFloatingLabel ? FloatingLabelBehavior.auto : FloatingLabelBehavior.never,
      labelText: widget.isFloatingLabel ? widget.label : null,
      labelStyle: AppTextStyle.medium.copyWith(
        fontSize: 16,
        color: _isFocused ? (widget.borderColor ?? Constant.instance.primary) : Colors.grey.shade600,
        fontWeight: FontWeight.w500,
      ),
      floatingLabelStyle: AppTextStyle.medium.copyWith(
        fontSize: 14,
        color: _isFocused ? (widget.borderColor ?? Constant.instance.primary) : Colors.grey.shade600,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  String? _validatePhoneNumber(PhoneNumber? value) {
    if (value == null || _selectedCountry == null) {
      _errorMessage = "Please enter a valid mobile number";
      _hasError = true;
      return _errorMessage;
    }
    String phoneNumber = value.number.trim();
    if (phoneNumber.isEmpty) {
      _errorMessage = "Mobile number is required";
      _hasError = true;
      return _errorMessage;
    }
    if (phoneNumber.length < _selectedCountry!.minLength || phoneNumber.length > _selectedCountry!.maxLength) {
      _errorMessage = "Please enter a valid ${_selectedCountry!.name} mobile number (${_selectedCountry!.minLength}-${_selectedCountry!.maxLength} digits)";
      _hasError = true;
      return _errorMessage;
    }
    _hasError = false;
    _errorMessage = null;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.isFloatingLabel && widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  widget.label!,
                  style: widget.labelStyle ?? AppTextStyle.medium.copyWith(fontSize: 15, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                ),
                if (widget.showRequiredIndicator)
                  Text(
                    " *",
                    style: AppTextStyle.medium.copyWith(fontSize: 15, color: Colors.red.shade500, fontWeight: FontWeight.w500),
                  ),
              ],
            ),
          ),
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isFocused
                      ? [BoxShadow(color: (widget.borderColor ?? Constant.instance.primary).withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))]
                      : null,
                ),
                child: IntlPhoneField(
                  focusNode: widget.focusNode,
                  initialValue: widget.initialValue,
                  controller: widget.controller,
                  validator: widget.validator ?? _validatePhoneNumber,
                  textAlign: widget.textAlign,
                  keyboardType: widget.keyboardType ?? TextInputType.numberWithOptions(signed: true),
                  inputFormatters: widget.inputFormatters,
                  textInputAction: widget.textInputAction ?? TextInputAction.next,
                  readOnly: widget.readOnly,
                  onTap: widget.onTap,
                  obscureText: widget.obscureText,
                  onChanged: (phoneNumber) {
                    setState(() {
                      _hasError = false;
                      _errorMessage = null;
                    });
                    widget.onChanged?.call(phoneNumber);
                  },
                  showCountryFlag: true,
                  flagsButtonMargin: EdgeInsets.only(left: 2),
                  flagsButtonPadding: const EdgeInsets.only(left: 12, right: 8),
                  dropdownIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey, size: 22),
                  showDropdownIcon: false,
                  dropdownDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  style: widget.style ?? AppTextStyle.medium.copyWith(fontSize: 16, color: Colors.grey.shade800, fontWeight: FontWeight.w400),
                  decoration: _buildInputDecoration(),
                  initialCountryCode: _selectedCountry?.code ?? 'IN',
                  onCountryChanged: (country) {
                    setState(() {
                      _selectedCountry = country;
                    });
                    widget.onCountryChanged?.call(country);
                  },
                  onSaved: widget.onSaved,
                  onSubmitted: widget.onSubmitted,
                  autovalidateMode: AutovalidateMode.disabled,
                  pickerDialogStyle: PickerDialogStyle(searchFieldInputDecoration: InputDecoration(hintText: 'Search country')),
                  dropdownTextStyle: AppTextStyle.medium.copyWith(fontSize: 15, color: Colors.grey.shade800),
                ),
              ),
            );
          },
        ),
        if (!_hasError && _isFocused && _selectedCountry != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, size: 14, color: Colors.green.shade600),
                const SizedBox(width: 4),
                Text(
                  "Enter ${_selectedCountry!.minLength}-${_selectedCountry!.maxLength} digit number",
                  style: AppTextStyle.regular.copyWith(fontSize: 12, color: Colors.green.shade600, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
