import '../../app_export.dart';

class CustomRadioListTile<T> extends StatelessWidget {
  const CustomRadioListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.groupValue,
    this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.titleGap = 10,
    this.height = 0,
    this.padding,
  });

  final T value;
  final T? groupValue;
  final void Function(T?) onChanged;
  final double titleGap, height;
  final String? title, subtitle;
  final TextStyle? titleStyle, subtitleStyle;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: padding ?? const EdgeInsets.only(top: 2, bottom: 2, right: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Radio<T>(value: value, groupValue: groupValue, onChanged: onChanged),
            Constant.instance.square.copyWith(height: 0, width: titleGap),
            if (title.notEmptyNotNull || subtitle.notEmptyNotNull)
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title.notEmptyNotNull) Text(title!, style: titleStyle ?? AppTextStyle.medium.copyWith(fontSize: 12.5, color: Constant.instance.black)),
                    Constant.instance.square.copyWith(width: 0, height: height),
                    if (subtitle.notEmptyNotNull)
                      Text(subtitle!, style: subtitleStyle ?? AppTextStyle.regular.copyWith(fontSize: 12, color: Constant.instance.grey400)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
