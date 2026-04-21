import '../../app_export.dart';

Future<T?>? nextScreen<T>({required String path, dynamic arguments, Map<String, String>? parameters}) async {
  return await Get.toNamed(path, arguments: arguments, parameters: parameters);
}

//! BackScreen
void backScreen<T>({T? result, bool closeOverlays = false, bool canPop = true, bool closeAfterCloseKeyboardClosing = true, int? id}) {
  Get.back(result: result, closeOverlays: closeOverlays, canPop: canPop, id: id);
}

Future<T?>? pushNReplace<T>({required String path, dynamic arguments, bool preventDuplicates = true, Map<String, String>? parameters, int? id}) async {
  return await Get.offNamed(path, arguments: arguments, preventDuplicates: preventDuplicates, parameters: parameters, id: id);
}

Future<T?>? pushNRemoveUntil<T>({required String path, bool Function(Route<dynamic>)? predicate, dynamic arguments, Map<String, String>? parameters, int? id}) async {
  return await Get.offNamedUntil(path, predicate ?? (_) => false, arguments: arguments, parameters: parameters, id: id);
}

//offAllNamed
Future<T?>? offAllNamed<T>({required String path, bool Function(Route<dynamic>)? predicate, dynamic arguments, Map<String, String>? parameters, int? id}) async {
  return await Get.offAllNamed(path, arguments: arguments, parameters: parameters, predicate: predicate ?? (_) => false, id: id);
}

Future<T?> openGetDialog<T>(Widget child, {bool barrierDismissible = false}) {
  return Get.dialog(child, barrierDismissible: barrierDismissible, transitionCurve: Curves.linearToEaseOut, barrierColor: Constant.instance.black.withAlpha(100), useSafeArea: true);
}

//! BOTTOM SHIT
Future<T?> openBottomShit<T>({
  required Widget child,
  bool isDismissible = true,
  Color? barrierColor,
  bool? ignoreSafeArea,
  RouteSettings? settings,
  bool readySetup = false,
  String? title,
  TextStyle? style,
  bool enableDrag = true,
  bool isScrollControlled = false,
}) => Get.bottomSheet(
  backgroundColor: Constant.instance.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
  elevation: 0.75,
  isDismissible: isDismissible,
  barrierColor: barrierColor,
  ignoreSafeArea: ignoreSafeArea,
  settings: settings,
  enableDrag: enableDrag,
  isScrollControlled: isScrollControlled,
  readySetup
      ? SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: Constant.instance.popupPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox.shrink(),
                    Text("$title", style: style ?? AppTextStyle.medium.copyWith(fontSize: 15, color: Constant.instance.black)),
                    CustomCloseBtn(size: 25),
                  ],
                ),
                Constant.instance.square,
                child,
              ],
            ),
          ),
        )
      : child,
);
