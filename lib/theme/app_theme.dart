import 'package:flutter/material.dart';

import '../constants/theme_constants.dart';

class AppTheme {
  AppTheme._();

  static const String fontFamily = "Gilmer";

  static ThemeData buildTheme(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double fontSize = screenWidth >= 600 ? 24.0 : 16.0;
    final MediaQueryData mediaQueryData =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    double deviceSize = mediaQueryData.size.width;
    return ThemeData(
      primarySwatch: ThemeConstants.primaryColorSwatch,
      dividerColor: ThemeConstants.dividerColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
          backgroundColor: ThemeConstants.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: ThemeConstants.black),
          titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
              )),
      fontFamily: fontFamily,
      inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ThemeConstants.black),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ThemeConstants.red),
            ),
            focusColor: ThemeConstants.black,
          ),
      textTheme: deviceSize > 600
          ? ThemeConstants.tabletTextTheme()
          : ThemeConstants.appTextTheme(),
      tabBarTheme: TabBarTheme.of(context).copyWith(
        labelStyle: ThemeConstants.tabLabelStyle,
        labelColor: ThemeConstants.black,
        unselectedLabelStyle: ThemeConstants.appFont,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: ThemeConstants.black,
        selectionHandleColor: ThemeConstants.black,
      ),
    );
  }

  static ThemeData lightTheme(BuildContext context) => ThemeData(
        primarySwatch: ThemeConstants.primaryColorSwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0,
            titleTextStyle: ThemeConstants.appFont,
            actionsIconTheme: Theme.of(context).iconTheme,
            iconTheme: Theme.of(context).iconTheme),
        inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: ThemeConstants.black)),
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusColor: ThemeConstants.black,
              labelStyle: const TextStyle(color: ThemeConstants.grey),
            ),
        textTheme: ThemeConstants.appTextTheme(),
        tabBarTheme: TabBarTheme.of(context).copyWith(
            labelStyle: ThemeConstants.tabLabelStyle,
            labelColor: ThemeConstants.black,
            unselectedLabelStyle: ThemeConstants.appFont),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: ThemeConstants.black,
          selectionHandleColor: ThemeConstants.black,
        ),
      );

  static ThemeData darkTheme(BuildContext context) => ThemeData.dark(
        useMaterial3: true,
      );
}
