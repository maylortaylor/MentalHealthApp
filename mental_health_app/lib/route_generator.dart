// import 'package:flutter/material.dart';
// import 'package:mental_health_app/screens/decision.screen.dart';
// import 'package:mental_health_app/screens/prompt.screen.dart';

// class RouteGenerator {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     // Getting arguments passed in while calling Navigator.pushNamed
//     var routingData = settings.name.getRoutingData;
//     final args = settings.arguments;

//   switch (routingData.route) { // Switch on the path from the data
//     case '/':
//     case '/home':
//       return _getPageRoute(HomeView(), settings);
//     case EpisodeDetailsRoute:
//       var id = int.tryParse(routingData['id']); // Get the id from the data.
//       return _getPageRoute(EpisodeDetails(id: id), settings);
//     default:
//       return _getPageRoute(HomeView(), settings);
//   }

//     // switch (settings.name) {
//     //   case '/':
//     //   case '/home':
//     //     return MaterialPageRoute(builder: (_) => DecisionScreen());
//     //   case '/prompt':
//     //     // Validation of correct data type
//     //     if (args is String) {
//     //       return MaterialPageRoute(
//     //         builder: (_) => PromptScreen(
//     //               data: args,
//     //             ),
//     //       );
//     //     }
//     //     // If args is not of the correct type, return an error page.
//     //     // You can also throw an exception while in development.
//     //     return _errorRoute();
//     //   default:
//     //     // If there is no such named route in the switch statement, e.g. /third
//     //     return _errorRoute();
//     // }
//   }

  
//   static Route<dynamic> _errorRoute() {
//     return MaterialPageRoute(builder: (_) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Error'),
//         ),
//         body: const Center(
//           child: Text('ERROR'),
//         ),
//       );
//     });
//   }
// }