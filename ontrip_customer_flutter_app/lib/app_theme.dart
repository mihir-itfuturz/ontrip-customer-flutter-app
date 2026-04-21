import 'app_export.dart';

class AppTheme {
  static final theme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Constant.instance.primarySwatch),
    scaffoldBackgroundColor: Constant.instance.bgColor,
    primarySwatch: Constant.instance.primarySwatch,
    useMaterial3: true,
    fontFamily: 'Lato',
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      backgroundColor: Constant.instance.primary,
      centerTitle: false,
      titleTextStyle: AppTextStyle.bold.copyWith(fontSize: 22, color: Constant.instance.white),
      scrolledUnderElevation: 00,
      surfaceTintColor: Constant.instance.white,
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Constant.instance.primary, statusBarIconBrightness: Brightness.light),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all<double>(0),
        foregroundColor: WidgetStateProperty.all<Color>(Constant.instance.greyShade500),
        visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity, horizontal: VisualDensity.minimumDensity),
        backgroundColor: WidgetStateProperty.all(Constant.instance.primary),
        animationDuration: const Duration(milliseconds: 400),
        textStyle: WidgetStateProperty.all<TextStyle>(AppTextStyle.medium),
        alignment: Alignment.center,
        enableFeedback: false,
        surfaceTintColor: WidgetStateProperty.all<Color>(Constant.instance.white),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Constant.instance.white,
      selectedItemColor: Constant.instance.primary,
      unselectedItemColor: Constant.instance.grey700,
      elevation: 1,
      enableFeedback: false,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      mouseCursor: WidgetStateProperty.all(MouseCursor.uncontrolled),
      landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
      selectedIconTheme: IconThemeData(color: Constant.instance.primary, size: 25),
      unselectedIconTheme: IconThemeData(color: Constant.instance.grey500, size: 23),
      selectedLabelStyle: AppTextStyle.semiBold.copyWith(color: Constant.instance.primary, fontSize: 12),
      unselectedLabelStyle: AppTextStyle.medium.copyWith(color: Constant.instance.grey500, fontSize: 11),
    ),
    checkboxTheme: CheckboxThemeData(
      visualDensity: VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      side: BorderSide(width: 0.8, color: Constant.instance.black),
    ),
    expansionTileTheme: ExpansionTileThemeData(tilePadding: EdgeInsets.zero, childrenPadding: EdgeInsets.zero),
    radioTheme: RadioThemeData(
      visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity, horizontal: VisualDensity.minimumDensity),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: WidgetStateProperty.all(Constant.instance.apple),
      overlayColor: WidgetStateProperty.all(Constant.instance.grey200),
    ),
  );
}
