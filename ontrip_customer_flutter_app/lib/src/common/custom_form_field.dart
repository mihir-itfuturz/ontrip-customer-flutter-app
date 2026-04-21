import '../../app_export.dart';

class CustomFormField extends StatelessWidget {
  final String? initialValue;
  final String? label;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool readOnly;
  final void Function()? onTap;
  final ValueChanged<String>? onSubmit;
  final TextInputAction? textInputAction;
  final Widget? prefix, suffix;
  final bool obscureText;
  final bool isRequiredMark;
  final Color? fillColor;
  final Color borderColor;
  final TextStyle? style, hintStyle;
  final bool isUnderlineBorder;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final void Function(String)? onChanged;
  final EdgeInsets? contentPadding;

  const CustomFormField({
    super.key,
    this.focusNode,
    this.label,
    this.style,
    this.hintStyle,
    this.initialValue,
    this.inputFormatters,
    this.controller,
    this.validator,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
    this.hintText,
    this.readOnly = false,
    this.onTap,
    this.onSubmit,
    this.textInputAction,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.isRequiredMark = false,
    this.fillColor = Colors.white,
    this.isUnderlineBorder = false,
    this.borderColor = const Color(0xff183883),
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.contentPadding,
  });

  OutlineInputBorder _border({Color color = const Color(0xFF3083C9), double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  InputBorder _underlineBorder({Color color = const Color(0xFF3083C9), double width = 1.0}) => const UnderlineInputBorder();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: CustomRichText(
              text1: "$label",
              text2: isRequiredMark ? "*" : null,
              style: style ?? AppTextStyle.medium.copyWith(fontSize: 14, color: Colors.black),
              style2: AppTextStyle.medium.copyWith(fontSize: 17, height: 0.5, color: Constant.instance.primary),
            ),
          ),
        TextFormField(
          focusNode: focusNode,
          initialValue: initialValue,
          controller: controller,
          validator: validator,
          maxLength: maxLength,
          maxLines: maxLines,
          textAlign: textAlign,
          keyboardType: (maxLines != null && maxLines! > 1) ? TextInputType.multiline : keyboardType,
          inputFormatters: inputFormatters,
          textInputAction: (maxLines != null && maxLines! > 1) ? TextInputAction.none : (textInputAction ?? TextInputAction.next),
          readOnly: readOnly,
          onTap: onTap,
          onFieldSubmitted: onSubmit,
          obscureText: obscureText,
          onChanged: onChanged,
          style: AppTextStyle.medium.copyWith(fontSize: 15),
          decoration: InputDecoration(
            fillColor: fillColor,
            filled: fillColor != null,
            prefixIcon: prefix,
            suffixIcon: suffix == null ? null : Center(child: suffix),
            suffixIconConstraints: const BoxConstraints(maxWidth: 40, maxHeight: 40),
            prefixIconColor: null,
            counterText: "",
            contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            isDense: true,
            constraints: const BoxConstraints(maxHeight: 300, minHeight: 40),
            hintText: hintText,

            hintMaxLines: 1,
            hintStyle: hintStyle ?? AppTextStyle.regular.copyWith(color: Colors.grey.shade700, fontSize: 12.5),
            border: isUnderlineBorder ? _underlineBorder(width: 0.75, color: Colors.grey.shade500) : _border(width: 0.75, color: Colors.grey.shade500),
            focusedBorder: isUnderlineBorder ? _underlineBorder(color: borderColor, width: 1) : _border(color: borderColor, width: 1),
            disabledBorder: isUnderlineBorder ? _underlineBorder(width: 0.5, color: Colors.grey.shade500) : _border(width: 0.5, color: Colors.grey.shade500),
            enabledBorder: isUnderlineBorder ? _underlineBorder(width: 0.75, color: Colors.grey.shade500) : _border(width: 0.75, color: Colors.grey.shade500),
            errorBorder: isUnderlineBorder ? _underlineBorder(width: 0.45, color: Colors.red.shade400) : _border(width: 0.45, color: Colors.red.shade400),
            focusedErrorBorder: isUnderlineBorder ? _underlineBorder(width: 0.75, color: Colors.red.shade400) : _border(width: 0.75, color: Colors.red.shade400),
            errorMaxLines: 1,
            errorStyle: AppTextStyle.light.copyWith(fontSize: 12, color: Colors.red.shade400),
          ),
        ),
      ],
    );
  }
}
