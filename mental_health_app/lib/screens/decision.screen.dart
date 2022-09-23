import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/config/Application.dart';
import 'package:mental_health_app/constants/app_font_family.dart';
import 'package:mental_health_app/constants/app_themes.dart';
import 'package:mental_health_app/locator.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/routes.dart';
import 'package:mental_health_app/services/navigation_service.dart';
import 'package:provider/provider.dart';

import '../screens/prompt.screen.dart';

class Constants {
  static const String Angry = 'Angry';
  static const String Anxious = 'Anxious';
  static const String Depressed = 'Depression';
  static const String Guilty = 'Guilty';

  static const List<String> choices = <String>[Angry, Anxious, Depressed, Guilty];
}
  late DatabaseReference _promptsRef;

class DecisionScreen extends StatefulWidget {
  @override
  _DecisionScreenState createState() => _DecisionScreenState();
}

class _DecisionScreenState extends  State<DecisionScreen> {
  var rng = Random();
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    final database = FirebaseDatabase.instance;
    _promptsRef = database.ref('prompts');
    database.setLoggingEnabled(false);
  }

  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 5;
    final double itemWidth = size.width / 4;
    final authProvider = Provider.of<AuthProvider>(context);

    Color getAppBarColor() {
      if (authProvider.status == Status.Authenticated) {
        return AppThemes.anxiousColor;
      }
      return AppThemes.depressedColor;
    }

    Color getBackgroundColor() {
      if (authProvider.status == Status.Authenticated) {
        print("DecisionScreen Status Check: Status.Authenticated");
        return AppThemes.whiteColor;
      }
      print("DecisionScreen Status Check: Status.Unauthenticated");
      return AppThemes.greyColor;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: getAppBarColor(),
        actions: [
          authProvider.status == Status.Unauthenticated ? ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
              // If the button is pressed, return green, otherwise blue
              if (states.contains(MaterialState.pressed)) {
                return AppThemes.lightestGreen;
              }
              return getAppBarColor();
            })
            ),
            child: Text(
              "Login",
              style: TextStyle(color: AppThemes.whiteColor),
            ),
            onPressed: () {
              print("login icon pressed");
                Application.router.navigateTo(context, AppRoutes.login);
              },
          ) : Container(),
          (authProvider.status == Status.Unauthenticated) ? ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
              // If the button is pressed, return green, otherwise blue
              if (states.contains(MaterialState.pressed)) {
                return AppThemes.lightestGreen;
              }
              return getAppBarColor();
            })
            ),
            child: Text(
              "Register",
              style: TextStyle(color: AppThemes.whiteColor),
            ),
            onPressed: () {
              print("login icon pressed");
                Application.router.navigateTo(context, AppRoutes.register);
              },
          ) :  Container(),
           authProvider.status == Status.Authenticated ? ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
              // If the button is pressed, return green, otherwise blue
              if (states.contains(MaterialState.pressed)) {
                return AppThemes.lightestGreen;
              }
              return getAppBarColor();
            })
            ),
            child: Text(
              "Logout",
              style: TextStyle(color: AppThemes.whiteColor),
            ),
            onPressed: () {
                print("logout icon pressed");
                if (authProvider.status == Status.Authenticated) {
                  authProvider.signOut();
                }
              }
          ) : Container(),


          authProvider.status == Status.Authenticated ? IconButton(
            tooltip: 'Settings',
            icon: Icon(Icons.settings), 
            color: AppThemes.whiteColor,
            onPressed: () {
              print("settings icon pressed");
              Application.router.navigateTo(context, AppRoutes.settings);
            },) : Container(),
          // IconButton(
          //   icon: Icon(Icons.account_circle), 
          //   color: AppThemes.whiteColor,
          //   onPressed: () {
          //     print("account icon pressed");
          //     Application.router.navigateTo(context, AppRoutes.register);
          //     }
          //   ),
          // IconButton(
          //   tooltip: 'Login',
          //   icon: Icon(Icons.login), 
          //   color: AppThemes.whiteColor,
          //   onPressed: () {
          //     print("login icon pressed");
          //     if (authProvider.status == Status.Unauthenticated) {
          //       Application.router.navigateTo(context, AppRoutes.login);
          //     }
          //     },),
          // authProvider.status == Status.Authenticated ? IconButton(
          //   tooltip: 'Logout',
          //   icon: Icon(Icons.logout), 
          //   color: AppThemes.whiteColor,
          //   onPressed: () {
          //     print("logout icon pressed");
          //     if (authProvider.status == Status.Authenticated) {
          //       authProvider.signOut();
          //     }
          //     }
          //   ,) : Container()
        ],
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        titleTextStyle: const TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white
        ),
      ),
      backgroundColor:  getBackgroundColor(),
      body:Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .20,
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'How are ',
                  style: TextStyle(
                    fontFamily:  AppFontFamily.poppins,
                    fontSize: 42,
                  ),
                  children:  [
                    TextSpan(text: 'you ', style: TextStyle(fontFamily:  AppFontFamily.poppins, fontWeight: FontWeight.bold, fontSize: 42)),
                    TextSpan(text: 'feeling ', style: TextStyle(fontFamily:  AppFontFamily.poppins, fontSize: 42)),
                    TextSpan(text: 'today?', style: TextStyle(fontFamily:  AppFontFamily.poppins, fontStyle: FontStyle.italic, fontSize: 42)),
                  ],
                ),
              ),
            ),
          ),
           Expanded(
             child: GridView.count(
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisCount: 2,
              children: <Widget>[
                buildCardWithIcon(
                  null,
                  context,
                  () {
                    Application.router.navigateTo(
                      context, 
                      '/prompt/anxiety',
                      routeSettings: RouteSettings(name: '/anxiety', arguments: {'category': 'Anxiety', 'step': '1'})
                    );
                    
                    // Navigator.push(context, MaterialPageRoute(
                    //   settings: RouteSettings(name: '/anxiety', arguments: {'category': 'Anxiety', 'step': '1'}),
                    //   builder: (context) {
                    //     return PromptScreen(category: "Anxiety", step: 1);
                    // }));
                    
                    // _navigationService.navigateTo('/prompt', queryParams: {'category': 'Anxiety', 'step': '1'});
                    
                  },
                  "Anxious",
                AppThemes.anxiousColor
                ),
                buildCardWithIcon(
                  null,
                  context,
                  () {
                    // _navigationService.navigateTo('/prompt', queryParams: {'category': 'Depression', 'step': '1'});
                    // Application.router.navigateTo(context, '/prompt/depression');

                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return PromptScreen(category: "Depression", step: 1);
                    }));
                  },
                  "Depressed",
                  AppThemes.depressedColor
                ),
                buildCardWithIcon(
                  null,
                  context,
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return PromptScreen(category: "Guilt", step: 1);
                    }));
                    // Application.router.navigateTo(context, '/prompt/guilt');

                  },
                  "Guilty",
                  AppThemes.guiltyColor
                ),
                buildCardWithIcon(
                  null,
                  context,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PromptScreen(category: "Anger", step: 1);
                        },
                      ),
                    );
                    // Application.router.navigateTo(context, '/prompt/anger');

                  },
                  "Angry",
                AppThemes.angryColor
                ),
              ],
                     ),
           ),
           footer()
         ],
      ),
    );    
  }

  Padding buildCardWithIcon(
      IconData? icon, context, VoidCallback onTap, String pageName, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: color,
          elevation: 20,
          shadowColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
          ),
          // shape:  OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(12),
          //     borderSide: BorderSide(color: Colors.white, width: 1)
          // ),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${pageName}',
                style: const TextStyle(
                  fontFamily: AppFontFamily.poppins,
                  color: Colors.white,
                ),),
            ),
          ),
        ),
      ),
    );
  }

  Widget footer() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap:() {

              },
              child: Container(
              height: 40,
              color: AppThemes.lightestGreen,
                child: Center(
                  child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: 'Get the ',
                    style: TextStyle(fontFamily:  AppFontFamily.poppins, fontSize: 18),
                    children:  [
                      TextSpan(text: 'my4blocks ', style: TextStyle(fontFamily:  AppFontFamily.poppins, fontWeight: FontWeight.bold, fontSize: 18)),
                      TextSpan(text: 'masterclass', style: TextStyle(fontFamily:  AppFontFamily.poppins, fontStyle: FontStyle.italic, fontSize: 18)),
                    ],
                  ),
                              ),
                ),
              ),
            ),
          ),
        Expanded(
          child: GestureDetector(
            onTap:() {
            
            },
            child:
              Container(
              height: 40,
                color: AppThemes.mediumGreen,
                child: Center(
                  child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: 'The Ultimate ',
                    style: TextStyle(fontFamily:  AppFontFamily.poppins, fontSize: 16, color: Colors.white),
                    children:  [
                      TextSpan(text: 'Mental Health Nutitrion Guide ', style: TextStyle(fontFamily:  AppFontFamily.poppins, fontStyle: FontStyle.italic, fontSize: 16)),
                    ],
                  ),
                              ),
                ),
              ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {

            },
            child: Container(
              height: 40,
              color: AppThemes.darkGreen,
              child: Center(
                child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Try ',
                  style: TextStyle(fontFamily:  AppFontFamily.poppins, fontSize: 18, color: Colors.white),
                  children:  [
                    TextSpan(text: 'Personalized Coaching ', style: TextStyle(fontFamily:  AppFontFamily.poppins, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                            ),
              ),
            ),
          ),
        )
      ]),
      );
  }
}

