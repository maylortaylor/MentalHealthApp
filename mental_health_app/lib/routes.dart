import 'package:flutter/material.dart';
import 'package:mental_health_app/screens/decision.screen.dart';
import 'package:mental_health_app/ui/auth/register_screen.dart';
import 'package:mental_health_app/ui/auth/sign_in_screen.dart';
import 'package:mental_health_app/ui/setting/setting_screen.dart';
import 'package:mental_health_app/ui/splash/splash_screen.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiate this object

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String setting = '/setting';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => SignInScreen(),
    register: (BuildContext context) => RegisterScreen(),
    home: (BuildContext context) => DecisionScreen(),
    setting: (BuildContext context) => SettingScreen(),
  };
}