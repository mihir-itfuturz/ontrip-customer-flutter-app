import 'dart:io';

import 'package:flutter/foundation.dart';
import '../../app_export.dart';

class Constant with _ColorMixin, _NumericalMixin, _ConstMixin {
  Constant._();

  factory Constant() => instance;
  static final instance = Constant._();
}

mixin _ColorMixin {
  static final primaryInt = 0xff2466FF;
  final primary = Color(primaryInt);
  final bgColor = const Color(0xffF5F4F7);

  final primarySwatch = MaterialColor(primaryInt, <int, Color>{
    50: Color.fromRGBO(10, 64, 165, 0.1),
    100: Color.fromRGBO(10, 64, 165, 0.2),
    200: Color.fromRGBO(10, 64, 165, 0.3),
    300: Color.fromRGBO(10, 64, 165, 0.4),
    400: Color.fromRGBO(10, 64, 165, 0.5),
    500: Color.fromRGBO(10, 64, 165, 0.6),
    600: Color.fromRGBO(10, 64, 165, 0.7),
    700: Color.fromRGBO(10, 64, 165, 0.8),
    800: Color.fromRGBO(10, 64, 165, 0.9),
    900: Color.fromRGBO(10, 64, 165, 1),
  });

  final black = const Color(0xff111111);
  final white = const Color(0xffffffff);
  final grey = const Color(0xff6A6D73);
  final blue = const Color(0xFF7B88FF);
  final orange = const Color(0xffEF9E24);
  final green = const Color(0xFF97B424);
  final green2 = const Color(0xFF3ADD7B);
  final whatsAppGreen = const Color(0xFF5EC943);
  final red = const Color(0xffEF2424);
  final pink = const Color(0xFFE57BFF);
  final apple = const Color(0xff4BB543);

  final fbBlue = const Color(0xFF3579E0);
  final skypeBlue = const Color(0xFF00A9F0);
  final lightBlue = const Color(0xFF5DBEFF);
  final lightBlue2 = const Color(0xFF6EA6F9);
  final skyBlue = const Color(0xFFF6FAFF);
  final skyOrange = const Color(0xFFFFF2ED);
  final skyGreen = const Color(0xFFEBFFF3);
  final redLight = const Color(0xFFFFF6F6);

  final primary15 = const Color.fromRGBO(10, 64, 165, 0.15);
  final blue50 = const Color(0xffF1F5FF);
  final red10 = const Color(0x1AF13637);
  final apple10 = const Color(0x1A4BB543);
  static const shadow = Color(0x1A000000);

  final grey100 = const Color(0xffEDEEF1);
  final grey200 = const Color(0xffD8DBDF);
  final grey400 = const Color(0xff8E95A2);
  final grey500 = const Color(0xff6B7280);
  final grey600 = const Color(0xff666666);
  final grey700 = const Color(0xff4A4E5A);
  final grey800 = const Color(0xff40444C);
  final grey950 = const Color(0xff25272C);

  final greyShade50 = const Color(0xFFFAFAFA);
  final greyShade100 = const Color(0xFFF5F5F5);
  final greyShade200 = const Color(0xFFEEEEEE);
  final greyShade300 = const Color(0xFFE0E0E0);
  final greyShade400 = const Color(0xFFE9E9E9);
  final greyShade500 = const Color(0xFFBDBDBD);
  final greyShade600 = const Color(0xFF757575);
  final greyShade700 = const Color(0xFF616161);
  final greyShade800 = const Color(0xFF424242);
  final greyShade900 = const Color(0xFF212121);

  final blue400 = const Color(0xff78A0FF);
  final blue500 = const Color(0xff5D87E9);
  final blue600 = const Color(0xff4169C7);
  final blue800 = const Color(0xff183883);

  final transparent = Colors.transparent;
}

mixin _NumericalMixin {
  final SizedBox square = const SizedBox(width: 15, height: 15);
  final EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 13);
  final boxShadow = <BoxShadow>[const BoxShadow(color: _ColorMixin.shadow, offset: Offset(0, 1), blurRadius: 2)];
  final EdgeInsetsGeometry popupPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
}

mixin _ConstMixin {
  final bool isDebug = kDebugMode == true && kReleaseMode == false && kProfileMode == false;
  final isAndroid = Platform.isAndroid;

  final initialErrorMdg = 'Something went wrong';
  final code201Msg = 'Record created successfully';
  final code400Msg = 'This request can\'n be processed';
  final code404Msg = '404 Request can\'n found';
  final code409Msg = 'This record already exist';
  final code500Msg = 'Internal Server error';
}
