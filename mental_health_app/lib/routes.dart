import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/screens/decision.screen.dart';
import 'package:mental_health_app/screens/prompt.screen.dart';
import 'package:mental_health_app/constants/string_extensions.dart';

class AppRoutes {
  static String root = '/';
  static final FluroRouter router = FluroRouter();

static final _decisionHandler = Handler(handlerFunc: (context, params) =>
   DecisionScreen());

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

}