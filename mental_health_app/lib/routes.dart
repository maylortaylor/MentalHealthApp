import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/screens/decision.screen.dart';
import 'package:mental_health_app/screens/prompt.screen.dart';
import 'package:mental_health_app/constants/string_extensions.dart';
import 'package:mental_health_app/ui/auth/register_screen.dart';
import 'package:mental_health_app/ui/auth/sign_in_screen.dart';
import 'package:mental_health_app/ui/setting/setting_screen.dart';

class AppRoutes {
  static String root = '/';
  static String login = '/login';
  static String register = '/register';
  static String settings = '/settings';
  static final FluroRouter router = FluroRouter();

static final _decisionHandler = Handler(handlerFunc: (context, params) =>
   DecisionScreen());

static final _signInHandler = Handler(handlerFunc: (context, params) =>
   SignInScreen());

static final _registerHandler = Handler(handlerFunc: (context, params) =>
   RegisterScreen());

static final _settingsHandler = Handler(handlerFunc: (context, params) =>
   SettingScreen());

static final Handler _promptHandler =
    Handler(handlerFunc: (context, params) {
  String category = params['category']?.first ?? '';

  return PromptScreen(category: category.capitalize(), step: 1);
});

static final Handler _promptHandler2 =
    Handler(handlerFunc: (context, params) {
  String category = params['category']?.first ?? '';
  int? step = int.tryParse(params['step']?.first ?? '1');

  return PromptScreen(category: category, step: step);
});


  static void configureRoutes(FluroRouter router){
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return;
    });


    router.define(
      root,
      handler: _decisionHandler,
    );
    router.define(
      login, 
      handler: _signInHandler
    );
    router.define(
      register, 
      handler: _registerHandler
    );
    router.define(
      settings,
      handler: _settingsHandler
    );
    router.define(
      '/prompt/:category',
      handler: _promptHandler,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      '/prompt/:category/:step',
      handler: _promptHandler2,
      transitionType: TransitionType.fadeIn,
    );
  }


  /// Handles deep links into the app
/// To test on Android:
///
/// `adb shell am start -W -a android.intent.action.VIEW -d "fluro://deeplink?path=/message&mesage=fluro%20rocks%21%21" com.theyakka.fluro`
// var deepLinkHandler = Handler(
//     handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//   String? colorHex = params["color_hex"]?.first;
//   String? result = params["result"]?.first;
//   Color color = Color(0xFFFFFFFF);
//   if (colorHex != null && colorHex.length > 0) {
//     color = Color(ColorHelpers.fromHexString(colorHex));
//   }
//   return DemoSimpleComponent(
//       message: "DEEEEEP LINK!!!", color: color, result: result);
// });

}