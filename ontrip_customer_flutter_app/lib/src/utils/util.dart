import '../../app_export.dart';

class Utils {
  Utils._();

  static final Utils _instance = Utils._();

  factory Utils() => _instance;

  static Widget formFieldSuffix({required String svg, Color? color, double? width, double? height, EdgeInsetsGeometry? padding, GestureTapCallback? onTap}) => InkWell(
    onTap: onTap,
    child: SizedBox(
      width: width ?? 20,
      height: height ?? 20,
      child: Padding(
        padding: padding ?? const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        child: SvgPicture.asset(width: width ?? 15, height: height ?? 15, svg, fit: BoxFit.contain, colorFilter: ColorFilter.mode(color ?? Constant.instance.black, BlendMode.srcIn)),
      ),
    ),
  );

  static Widget verticalDivider({Color? color, double? thickness, double? width, double? endIndent, double? indent, EdgeInsetsGeometry? padding}) => Padding(
    padding: padding ?? EdgeInsets.zero,
    child: VerticalDivider(width: width ?? 2, color: color ?? Constant.instance.grey100, endIndent: endIndent ?? 03, indent: indent ?? 03, thickness: thickness ?? 1),
  );

  static Widget horizontalDivider({Color? color, double? height, double? endIndent, double? indent, double? thickness, EdgeInsetsGeometry? padding}) => Padding(
    padding: padding ?? EdgeInsets.zero,
    child: Divider(color: color ?? Constant.instance.grey.withValues(alpha: 0.1), height: height ?? 0, endIndent: endIndent ?? 0, indent: indent ?? 0, thickness: thickness ?? 1.5),
  );

  static Future customDelay({int milliseconds = 150, Future<dynamic> Function()? computation}) => Future.delayed(Duration(milliseconds: milliseconds), computation);

  static String toTitleCase(String input) {
    if (input.isEmpty) return input;
    final words = input.toLowerCase().split(' ');
    final titleCaseWords = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    });
    return titleCaseWords.join(' ');
  }

  static Widget listenDialog() => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(width: 45, height: 45, Graphics.instance.iconMicrophone, colorFilter: ColorFilter.mode(Constant.instance.grey, BlendMode.srcIn)),
          Constant.instance.square.copyWith(height: 5),
          Text("Listening...", style: AppTextStyle.bold.copyWith(color: Constant.instance.red, fontSize: 15)),
        ],
      ),
    ),
  );
}
