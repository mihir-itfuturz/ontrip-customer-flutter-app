import '../../../app_export.dart';

class DialogStructure extends StatelessWidget {
  const DialogStructure({
    super.key,
    this.icon,
    this.svg,
    this.iconColor,
    this.iconTitleDistance = 15,
    this.titleSubtitleDistance = 5,
    this.subtitleBottomDistance = 18,
    this.title,
    this.subtitle,
    this.bottom,
  }) : assert(!(icon != null && svg != null), 'Used icon or svg one at time');

  final Color? iconColor;
  final Widget? icon, title, subtitle, bottom;
  final String? svg;
  final double iconTitleDistance, titleSubtitleDistance, subtitleBottomDistance;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Constant.instance.white,
      clipBehavior: Clip.none,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon != null
              ? icon!
              : svg != null
                  ? SizedBox(
                      width: 35,
                      height: 35,
                      child: SvgPicture.asset(
                        svg!,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(iconColor ?? Constant.instance.primary, BlendMode.srcIn),
                      ),
                    )
                  : const SizedBox.shrink(),
          if (title != null) ...[
            Constant.instance.square.copyWith(height: iconTitleDistance),
            title ?? const SizedBox.shrink(),
          ],
          if (subtitle != null) ...[
            Constant.instance.square.copyWith(height: titleSubtitleDistance),
            Flexible(child: subtitle ?? const SizedBox.shrink()),
          ],
          if (bottom != null) ...[
            Constant.instance.square.copyWith(height: subtitleBottomDistance),
            Flexible(child: bottom ?? const SizedBox.shrink()),
          ],
        ],
      ),
    );
  }
}
