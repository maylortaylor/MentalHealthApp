import 'package:flutter/material.dart';
import 'package:mental_health_app/caches/sharedpref/shared_preference_helper.dart';
import 'package:mental_health_app/constants/app_font_family.dart';
import 'package:mental_health_app/constants/app_colors.dart';

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = true;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    SharedPreferenceHelper.readData('themeMode').then((value) {
      var themeMode = value ?? 'light';
      _isDarkTheme = !_isDarkTheme;
      if (themeMode == 'light') {
        SharedPreferenceHelper.saveData('themeMode', 'dark');
      } else {
        SharedPreferenceHelper.saveData('themeMode', 'light');
      }
      notifyListeners();
    });
  }
  
  static ThemeData get appLightTheme { 
      return ThemeData( 
        fontFamily: AppFontFamily.poppins,
        primaryColor: AppColors.darkBlue,
        scaffoldBackgroundColor: AppColors.whiteColor,
        backgroundColor: AppColors.offWhiteColor,
        canvasColor: AppColors.offWhiteColor,
        cardColor: AppColors.lightModeBackground,
        secondaryHeaderColor: AppColors.lightModeBackground2,
        indicatorColor: AppColors.indicatorColor,
        primaryColorDark: AppColors.whiteColor,
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: AppColors.secondaryColor,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: AppFontFamily.poppins,
            color: Colors.black,
            fontSize: 18
          ),
          bodyMedium: TextStyle(
            fontFamily: AppFontFamily.poppins,
            color: Colors.white,
            fontSize: 14
          ),
          bodySmall: TextStyle(
            fontFamily: AppFontFamily.poppins,
            color: Colors.white,
            fontSize: 12
          ),
          displayLarge: TextStyle(
            fontFamily: AppFontFamily.poppins,
            color: Colors.black,
            fontSize: 42
          ),
          displayMedium: TextStyle(
            fontFamily: AppFontFamily.poppins,
            color: Colors.black,
            fontSize: 32
          ),
          displaySmall: TextStyle(
            fontFamily: AppFontFamily.poppins,
            color: Colors.white,
            fontSize: 22
          ),
          headlineLarge: TextStyle(
            fontFamily: AppFontFamily.poppins,
            color: Colors.black,
            fontSize: 42
          ),
          labelLarge: TextStyle(
            fontFamily: AppFontFamily.poppins,
            color: Colors.white,
            fontSize: 32
          ),
          labelMedium: TextStyle(
            fontFamily: AppFontFamily.poppins,
            color: Colors.white,
            fontSize: 16
          ),
          labelSmall: TextStyle(
            fontFamily: AppFontFamily.poppins,
            color: Colors.white,
            fontSize: 10
          ),
          titleLarge: TextStyle(
            fontFamily: AppFontFamily.poppins,
            color: Colors.white,
            fontSize: 36
          ),
          titleMedium: TextStyle(
            fontFamily: AppFontFamily.poppins,
            color: Colors.white,
            fontSize: 20
          ),
        ),
      );
    }
  static ThemeData get appDarkTheme {
    return ThemeData(
      fontFamily: AppFontFamily.poppins,
      primaryColor: AppColors.darkGrey,
      scaffoldBackgroundColor: AppColors.blackColor,
      backgroundColor: AppColors.darkBlue,
      canvasColor: AppColors.darkBlue,
      cardColor: AppColors.darkGrey,
      secondaryHeaderColor: AppColors.darkGrey,
      primaryColorDark: AppColors.lightGrey,
      indicatorColor: AppColors.indicatorColor,
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        buttonColor: AppColors.secondaryColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white,
          fontSize: 18
        ),
        bodyMedium: TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white,
          fontSize: 14
        ),
        bodySmall: TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white,
          fontSize: 12
        ),
        displayLarge: TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.black,
          fontSize: 42
        ),
        displayMedium: TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white,
          fontSize: 32
        ),
        displaySmall: TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white,
          fontSize: 22
        ),
        headlineLarge: TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white,
          fontSize: 42
        ),
        labelLarge: TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white,
          fontSize: 36
        ),
        labelMedium: TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white,
          fontSize: 16
        ),
        labelSmall: TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white,
          fontSize: 10
        ),
        titleLarge: TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white,
          fontSize: 36
        ),
        titleMedium: TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white,
          fontSize: 20
        ),
      ),
    );
  }
}
