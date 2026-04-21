import '../../../app_export.dart';

class CustomCloseBtn extends StatelessWidget {
  const CustomCloseBtn({
    super.key,
    this.onClose,
    this.bgColor,
    this.size,
  });
  final GestureTapCallback? onClose;
  final Color? bgColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return CustomIconBtn(
      onTap: onClose ?? () => backScreen(),
      svgPath: Graphics.instance.iconClose,
      height: size ?? 35,
      width: size ?? 35,
      radius: size ?? 35,
      svgHeight: size ?? 35,
      svgWidth: size ?? 35,
      color: Constant.instance.black,
    );
  }
}
