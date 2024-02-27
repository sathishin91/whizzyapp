import 'package:flutter/material.dart';

class ThemeConstants {
  ThemeConstants._();

  static const String fontFamily = "Poppins";

  static const int primaryColorCode = 0x00FF024757;
  static const int secondaryColorCode = 0x00FF43d296;
  static const int backgroundColorCode = 0x00FFfefefe;
  static const int dividerColorCode = 0xFFD3D3D3; // Color code error
  static const int accentColorCode = 0xFFfdf4c4;
  static const int blackColorCode = 0xFF000000;
  static const int greenColorCode = 0xFF7AE39E;
  static const int redColorCode = 0xFFF98F8F;
  static const int greyColorCode = 0xFF6D6E71;

  static const Color primaryColor = Color(primaryColorCode);
  static const Color secondaryColor = Color(secondaryColorCode);
  static const Color backgroundColor = Color(backgroundColorCode);
  static const Color dividerColor = Color(dividerColorCode);
  static const Color accentColor = Color(accentColorCode);
  static const Color black = Color(blackColorCode);
  static const Color white = Color(backgroundColorCode);
  static const grey = Color(greyColorCode);

  static const Color entryTotalColorCode = Color(0xFF66BB6A);
  static const Color exitTotalColorCode = Color(0xFFFFA726);
  static const Color peakHourColorCode = Color(0xFF42A5F5);
  static const Color avgDwellTimeColorCode = Color(0xFFBDBDBD);

  static const MaterialColor primaryColorSwatch = MaterialColor(
    primaryColorCode,
    <int, Color>{
      50: Color(primaryColorCode),
      100: Color(primaryColorCode),
      200: Color(primaryColorCode),
      300: Color(primaryColorCode),
      400: Color(primaryColorCode),
      500: Color(primaryColorCode),
      600: Color(primaryColorCode),
      700: Color(primaryColorCode),
      800: Color(primaryColorCode),
      900: Color(primaryColorCode),
    },
  );

  //status color
  static const Color green = Color(greenColorCode);
  static const Color red = Color(redColorCode);

  static TextStyle appFont = const TextStyle(fontFamily: fontFamily);
  static TextStyle tabLabelStyle =
      const TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold);

  static double get textScaleFactor {
    final MediaQueryData mediaQueryData =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    final devicePixelRatio = mediaQueryData.devicePixelRatio;
    // Set your desired reference DPI (usually 160, which corresponds to mdpi)
    const referenceDPI = 3.0;
    // Calculate the scaling factor based on the device's DPI
    final scaleFactor = devicePixelRatio / referenceDPI;
    // Return the scaling factor
    return scaleFactor;
  }

  // static double get deviceType {
  //   final MediaQueryData mediaQueryData =
  //       MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  //   double deviceSize = mediaQueryData.size.width;
  //   double tabSize = deviceSize >= 600 ?  ;
  //   return tabSize;
  // }

  static TextStyle btnTheme = const TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
  );

  static TextTheme appTextTheme([TextTheme? textTheme]) {
    return TextTheme(
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20 * textScaleFactor,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18 * textScaleFactor,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16 * textScaleFactor,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20 * textScaleFactor,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18 * textScaleFactor,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16 * textScaleFactor,
      ),
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 15 * textScaleFactor,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14 * textScaleFactor,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 13 * textScaleFactor,
      ),
    );
  }

  static TextTheme tabletTextTheme([TextTheme? textTheme]) {
    return TextTheme(
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 36 * textScaleFactor,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 34 * textScaleFactor,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32 * textScaleFactor,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 34 * textScaleFactor,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32 * textScaleFactor,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 30 * textScaleFactor,
      ),
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 29 * textScaleFactor,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28 * textScaleFactor,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 26 * textScaleFactor,
      ),
    );
  }
}
