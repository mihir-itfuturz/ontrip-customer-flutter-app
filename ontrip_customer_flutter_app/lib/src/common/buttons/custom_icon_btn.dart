import '../../../app_export.dart';

class CustomIconBtn extends StatelessWidget {
  const CustomIconBtn({
    super.key,
    this.svgPath,
    this.svg,
    this.color,
    this.bgColor,
    this.width,
    this.height,
    this.padding,
    this.radius = 10,
    this.svgWidth,
    this.svgHeight,
    this.onTap,
    this.fit = BoxFit.cover,
    this.isLoading = false,
    this.border,
    this.onLongPressStart,
    this.onLongPressEnd,
  }) : assert(!(svgPath != null && svg != null), "You can't use svg and svgPath at same-time");
  final String? svgPath;
  final Widget? svg;
  final Color? color, bgColor;
  final double? width, height, svgWidth, svgHeight;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final GestureTapCallback? onTap;
  final BoxFit fit;
  final bool isLoading;
  final BoxBorder? border;
  final ValueChanged<LongPressStartDetails>? onLongPressStart;
  final ValueChanged<LongPressEndDetails>? onLongPressEnd;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        onLongPressStart: onLongPressStart,
        onLongPressEnd: onLongPressEnd,
        child: Ink(
          width: width ?? 30,
          height: height ?? 30,
          padding: padding,
          decoration: BoxDecoration(
            color: bgColor ?? Constant.instance.white,
            borderRadius: BorderRadius.circular(radius),
            border: border,
          ),
          child: isLoading
              ? CustomLoadingIndicator()
              : Center(
                  child: svgPath != null
                      ? SvgPicture.asset(
                          svgPath!,
                          fit: fit,
                          width: svgWidth,
                          height: svgHeight,
                          colorFilter: ColorFilter.mode(color ?? Constant.instance.primary, BlendMode.srcIn),
                        )
                      : svg,
                ),
        ),
      ),
    );
  }
}
