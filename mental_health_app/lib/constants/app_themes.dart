import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/app_font_family.dart';

class AppThemes {
  AppThemes._();

  static final Color angryColor = const Color.fromRGBO(210,71,42,1);
  static final Color anxiousColor = const Color.fromRGBO(51,117,90,1);
  static final Color depressedColor = const Color.fromRGBO(42,86,105,1);
  static final Color guiltyColor = const Color.fromRGBO(212,171,113,1);
  static final Color darkCardColor = Color.fromRGBO(15,10,51,1);
  static final Color midCardColor = Color.fromRGBO(115, 110, 144,1);
  static final Color lightCardColor = Color.fromRGBO(140, 138, 150,1);

  //constants color range for light theme
  static const Color _lightPrimaryColor = const Color.fromRGBO(51,117,90,1);
  static const Color _lightCardColor = Color.fromRGBO(15,10,51,1);
  static const Color _lightPrimaryVariantColor = Colors.white;
  static const Color _lightSecondaryColor = const Color.fromRGBO(95,176,144,1);
  static const Color _lightTertiaryColor = const Color.fromRGBO(162,201,186,1);
  static const Color _lightOnPrimaryColor = Colors.black;
  static const Color _lightButtonPrimaryColor = Colors.orangeAccent;
  static const Color _lightAppBarColor = Colors.orangeAccent;
  static Color _lightIconColor = Colors.orangeAccent;
  static Color _lightSnackBarBackgroundErrorColor = Colors.redAccent;

  //text theme for light theme
  static final TextStyle _lightScreenHeadingTextStyle =
      TextStyle(fontSize: 20.0, color: _lightOnPrimaryColor);
  static final TextStyle _lightScreenTaskNameTextStyle =
      TextStyle(fontSize: 16.0, color: _lightOnPrimaryColor);
  static final TextStyle _lightScreenTaskDurationTextStyle =
      TextStyle(fontSize: 14.0, color: Colors.grey);
  static final TextStyle _lightScreenButtonTextStyle = TextStyle(
      fontSize: 14.0, color: _lightOnPrimaryColor, fontWeight: FontWeight.w500);
  static final TextStyle _lightScreenCaptionTextStyle = TextStyle(
      fontSize: 12.0, color: _lightAppBarColor, fontWeight: FontWeight.w100);

  static final TextTheme _lightTextTheme = TextTheme(
    displayLarge: _lightScreenHeadingTextStyle,
    bodyLarge: _lightScreenTaskNameTextStyle,
    titleLarge: _lightScreenTaskNameTextStyle,
    bodyMedium: _lightScreenTaskDurationTextStyle,
    headlineMedium: _lightScreenTaskNameTextStyle,
    labelLarge: _lightScreenButtonTextStyle,
    labelSmall: _lightScreenCaptionTextStyle,
  );

  //constants color range for dark theme
  static const Color _darkPrimaryColor = Colors.white;
  static const Color _darkPrimaryVariantColor = Color.fromRGBO(15,10,51,1);
  static const Color _darkSecondaryColor = Colors.white;
  static const Color _darkOnPrimaryColor = Colors.white;
  static const Color _darkButtonPrimaryColor = Colors.deepPurpleAccent;
  static const Color _darkAppBarColor = Colors.deepPurpleAccent;
  static Color _darkIconColor = Colors.deepPurpleAccent;
  static Color _darkSnackBarBackgroundErrorColor = Colors.redAccent;

  //text theme for dark theme
  static final TextStyle _darkScreenHeadingTextStyle =
      _lightScreenHeadingTextStyle.copyWith(color: _darkOnPrimaryColor);
  static final TextStyle _darkScreenTaskNameTextStyle =
      _lightScreenTaskNameTextStyle.copyWith(color: _darkOnPrimaryColor);
  static final TextStyle _darkScreenTaskDurationTextStyle =
      _lightScreenTaskDurationTextStyle;
  static final TextStyle _darkScreenButtonTextStyle = TextStyle(
      fontSize: 14.0, color: _darkOnPrimaryColor, fontWeight: FontWeight.w500);
  static final TextStyle _darkScreenCaptionTextStyle = TextStyle(
      fontSize: 12.0, color: _darkAppBarColor, fontWeight: FontWeight.w100);

  static final TextTheme _darkTextTheme = TextTheme(
    displayLarge: _darkScreenHeadingTextStyle,
    bodyLarge: _darkScreenTaskNameTextStyle,
    titleLarge: _darkScreenTaskNameTextStyle,
    bodyMedium: _darkScreenTaskDurationTextStyle,
    headlineMedium: _darkScreenTaskNameTextStyle,
    labelLarge: _darkScreenButtonTextStyle,
    labelSmall: _darkScreenCaptionTextStyle,
  );

  //the light theme
  static final ThemeData lightTheme = ThemeData(
    fontFamily: AppFontFamily.productSans,
    scaffoldBackgroundColor: _lightPrimaryVariantColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _lightButtonPrimaryColor,
    ),
    appBarTheme: AppBarTheme(
      color: _lightAppBarColor,
      iconTheme: IconThemeData(color: _lightOnPrimaryColor),
      // textTheme: _lightTextTheme,
    ),
    cardTheme: CardTheme(
      color: _lightCardColor
    ),
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      // primaryVariant: _lightPrimaryVariantColor,
      secondary: _lightSecondaryColor,
      onPrimary: _lightOnPrimaryColor,
      tertiary: _lightTertiaryColor
    ),
    snackBarTheme:
        SnackBarThemeData(backgroundColor: _lightSnackBarBackgroundErrorColor),
    iconTheme: IconThemeData(
      color: _lightIconColor,
    ),
    popupMenuTheme: PopupMenuThemeData(color: _lightAppBarColor),
    textTheme: _lightTextTheme,
    buttonTheme: ButtonThemeData(
        buttonColor: _lightButtonPrimaryColor,
        textTheme: ButtonTextTheme.primary),
    unselectedWidgetColor: _lightPrimaryColor,
    inputDecorationTheme: InputDecorationTheme(
        fillColor: _lightPrimaryColor,
        labelStyle: TextStyle(
          color: _lightPrimaryColor,
        )),
  );

  //the dark theme
  static final ThemeData darkTheme = ThemeData(
    fontFamily: AppFontFamily.productSans,
    scaffoldBackgroundColor: _darkPrimaryVariantColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _darkButtonPrimaryColor,
    ),
    appBarTheme: AppBarTheme(
      color: _darkAppBarColor,
      iconTheme: IconThemeData(color: _darkOnPrimaryColor),
      textTheme: _darkTextTheme,
    ),
    colorScheme: ColorScheme.light(
      primary: _darkPrimaryColor,
      primaryVariant: _darkPrimaryVariantColor,
      secondary: _darkSecondaryColor,
      onPrimary: _darkOnPrimaryColor,
    ),
    snackBarTheme:
        SnackBarThemeData(backgroundColor: _darkSnackBarBackgroundErrorColor),
    iconTheme: IconThemeData(
      color: _darkIconColor,
    ),
    popupMenuTheme: PopupMenuThemeData(color: _darkAppBarColor),
    textTheme: _darkTextTheme,
    buttonTheme: ButtonThemeData(
        buttonColor: _darkButtonPrimaryColor,
        textTheme: ButtonTextTheme.primary),
    unselectedWidgetColor: _darkPrimaryColor,
    inputDecorationTheme: InputDecorationTheme(
        fillColor: _darkPrimaryColor,
        labelStyle: TextStyle(
          color: _darkPrimaryColor,
        )),
  );
}