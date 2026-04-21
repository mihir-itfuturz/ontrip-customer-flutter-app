import '../../../app_export.dart';

class CustomPopupMenuBtn<T> extends StatelessWidget {
  const CustomPopupMenuBtn({
    super.key,
    required this.items,
    this.elevation,
    this.offset,
    this.menuPadding,
    this.padding,
    this.borderRadius,
    this.constraints,
    this.onOpened,
    this.onCanceled,
    this.onSelected,
    this.icon,
    this.child,
    this.height,
    this.width,
  });
  final List<PopupMenuEntry<T>> items;
  final double? elevation;
  final Offset? offset;
  final EdgeInsetsGeometry? menuPadding, padding;
  final BorderRadius? borderRadius;
  final BoxConstraints? constraints;
  final GestureTapCallback? onOpened, onCanceled;
  final ValueChanged<T>? onSelected;
  final Widget? child, icon;
  final double? width, height;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      elevation: elevation ?? 2.5,
      offset: offset ?? Offset(10, 0),
      menuPadding: menuPadding ?? EdgeInsets.zero,
      padding: padding ?? EdgeInsets.zero,
      color: Constant.instance.white,
      position: PopupMenuPosition.under,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      borderRadius: BorderRadius.circular(8),
      shadowColor: Constant.instance.greyShade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      iconSize: width ?? 12,
      icon: icon ??
          SvgPicture.asset(
            Graphics.instance.iconMoreVertical,
            width: width ?? 12,
            height: height ?? 12,
            colorFilter: ColorFilter.mode(Constant.instance.black, BlendMode.srcIn),
          ),
      onCanceled: onCanceled,
      onOpened: onOpened,
      onSelected: onSelected,
      constraints: constraints ?? BoxConstraints(maxHeight: 300, maxWidth: 200, minWidth: 80),
      itemBuilder: (context) => items,
      child: child,
    );
  }
}
