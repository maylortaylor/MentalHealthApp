import 'package:flutter/material.dart';
import 'package:mental_health_app/screens/decision.screen.dart';
import 'package:mental_health_app/screens/prompt.screen.dart';
import 'package:mental_health_app/string_extensions.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final routingData = settings.name?.getRoutingData; // Get the routing Data
  switch (routingData?.route) {
    case '/':
    case '/home':
      return _getPageRoute(DecisionScreen(), settings);
    case '/prompt':
      final category = routingData?['category'];
      final step = int.tryParse(routingData?['step'] ?? '1');
      return _getPageRoute(PromptScreen(category: category, step: step), settings);
    default:
      return _errorRoute(settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name!);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  _FadeRoute({required this.child, required this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

  Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }