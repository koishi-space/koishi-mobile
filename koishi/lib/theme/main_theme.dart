import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KoishiTheme {
  static final ThemeData defaultTheme = _buildKoishiTheme();

  static ThemeData _buildKoishiTheme() {
    final ThemeData base = ThemeData.light();

    const backgroundColor = Color(0xFFf5f5f5);
    const primaryColor = Color(0xFF1138f7);

    return base.copyWith(
        // Colors
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,

        // Scaffold
        scaffoldBackgroundColor: backgroundColor,

        // App bar
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarColor: Color.fromRGBO(0, 0, 0, 0),
          ),
        ),

        // Input
        inputDecorationTheme: base.inputDecorationTheme.copyWith(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.white,
          filled: true,
        ),

        // Progress indicator
        progressIndicatorTheme: base.progressIndicatorTheme.copyWith(
          color: primaryColor,
        ),

        // Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: primaryColor,
              elevation: 0,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w200,
                color: Colors.white,
                fontSize: 17,
              )),
        ),

        // Text
        textTheme: base.textTheme.copyWith(
          headline1: base.textTheme.headline1!.copyWith(
            color: primaryColor,
            fontSize: 50,
            fontWeight: FontWeight.normal,
          ),
          headline2: base.textTheme.headline3!.copyWith(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w300,
          ),
        ),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: primaryColor));
  }
}
