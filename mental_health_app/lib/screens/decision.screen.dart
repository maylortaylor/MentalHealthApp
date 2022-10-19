import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/app_font_family.dart';
import 'package:mental_health_app/constants/app_routes.dart';
import 'package:mental_health_app/constants/app_themes.dart';
import 'package:mental_health_app/locator.dart';
import 'package:mental_health_app/models/arguments/PromptArguments.dart';
import 'package:mental_health_app/models/user_model.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/routes.dart';
import 'package:mental_health_app/services/navigation_service.dart';
import 'package:mental_health_app/ui/auth/register_screen.dart';
import 'package:mental_health_app/ui/setting/setting_screen.dart';
import 'package:provider/provider.dart';

import '../screens/prompt.screen.dart';


  late DatabaseReference _promptsRef;

class DecisionScreen extends StatefulWidget {
  @override
  _DecisionScreenState createState() => _DecisionScreenState();
}

class _DecisionScreenState extends  State<DecisionScreen> {
  var rng = Random();
  final NavigationService _navigationService = locator<NavigationService>();
  late UserModel? currentUser;

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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      currentUser = authProvider.currentUserModel;
      print("${currentUser?.firstName} : ${currentUser?.pathsAllowed}");
    });
   

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
        leading: authProvider.status == Status.Authenticated ? 
        Center(child: Text("${currentUser?.firstName}")) : Container(),
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
                // Application.router.navigateTo(context, AppRoutes.login);
                      Navigator.pushNamed(
                        context,
                        AppRoutes.login,
                        // arguments: PromptArguments(
                        //   'anxiety',
                        //   1,
                        // ),
                      );
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
                // Application.router.navigateTo(context, AppRoutes.register);
                      Navigator.pushNamed(
                        context,
                        AppRoutes.register,
                        // arguments: PromptArguments(
                        //   'anxiety',
                        //   1,
                        // ),
                      );
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
                  Flushbar(
                    title:  "Logout Successful",
                    message:  "User logout successful",
                    backgroundColor: AppThemes.notifBlue,
                    flushbarPosition: FlushbarPosition.TOP,
                    duration:  Duration(seconds: 3),
                  ).show(context);
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
              // Application.router.navigateTo(context, AppRoutes.settings);
                    Navigator.pushNamed(
                        context,
                        AppRoutes.settings,
                        // arguments: PromptArguments(
                        //   'anxiety',
                        //   1,
                        // ),
                      );
            },) : Container(),
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
                  text: 'What are ',
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
                _getAngerCard(),
                _getAnxiousCard(),
                _getDepressionCard(),
                _getGuiltyCard(),
              ],
                     ),
           ),
           footer()
         ],
      ),
    );    
  }

  _getAnxiousCard() {
    // if (currentUser == null || !currentUser!.pathsAllowed!.contains('anxiety')) {
    //   return Container();
    // }
    return buildCardWithIcon(
            null,
            context,
            () {
              Navigator.push(context, MaterialPageRoute(
                settings: RouteSettings(name: AppRoutes.anxiety, arguments: PromptArguments('anxiety')),
                builder: (context) {
                  return PromptScreen(args: PromptArguments('anxiety'),);
                  // return PromptScreen(arguments: PromptArguments('anxiety', 5),);
              }));
            },
            "Anxiety",
          AppThemes.anxiousColor);
  }

  _getDepressionCard() {
    // if (currentUser == null || !currentUser!.pathsAllowed!.contains('depression')) {
    //   return Container();
    // }
    return buildCardWithIcon(
            null,
            context,
            () {
              Navigator.push(context, MaterialPageRoute(
                settings: RouteSettings(name: AppRoutes.depression, arguments: PromptArguments('depression')),
                builder: (context) {
                  return PromptScreen(args: PromptArguments('depression'),);
              }));
            },
            "Depression",
            AppThemes.depressedColor
          );
  }

  _getGuiltyCard() {
    // if (currentUser == null || !currentUser!.pathsAllowed!.contains('guilt')) {
    //   return Container();
    // }
    return buildCardWithIcon(
            null,
            context,
            () {
              Navigator.push(context, MaterialPageRoute(
                settings: RouteSettings(name: AppRoutes.guilt, arguments: PromptArguments('guilt')),
                builder: (context) {
                  return PromptScreen(args: PromptArguments('guilt'),);
              }));
            },
            "Guilt",
            AppThemes.guiltyColor
          );
  }

  _getAngerCard() {
    // if (currentUser == null || !currentUser!.pathsAllowed!.contains('anger')) {
    //   return Container();
    // }
    return buildCardWithIcon(
            null,
            context,
            () {
              Navigator.push(context, MaterialPageRoute(
                settings: RouteSettings(name: AppRoutes.anger, arguments: PromptArguments('anger')),
                builder: (context) {
                  return PromptScreen(args: PromptArguments('anger'),);
              }));
            },
            "Anger",
          AppThemes.angryColor
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

