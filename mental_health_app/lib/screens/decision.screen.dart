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
import 'package:mental_health_app/widgets/platform_aware_asset_image.dart';
import 'package:mental_health_app/widgets/responsive.dart';
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
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.5;
    final double itemWidth = size.width / 2;

    // double screenWidth = MediaQuery.of(context).size.width;
    // double _crossAxisSpacing = 8, _mainAxisSpacing = 12, _aspectRatio = 2;
    // int _crossAxisCount = 2;
    // var width = (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
    // var height = width / _aspectRatio;

    setState(() {
      // print("CURRENT USER: ${currentUser?.firstName} : ${currentUser?.pathsAllowed}");
    });
   

    Color getAppBarColor() {
      return AppThemes.depressedColor;
    }

    Color getBackgroundColor() {
      return AppThemes.greyColor;
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: getAppBarColor(),
        // leading: authProvider.status == Status.Authenticated ? 
        // Center(child: Text("${currentUser?.firstName}")) : Container(),
        leading: leadingAppBar(),
        leadingWidth: 70,
        title: !ResponsiveWidget.isSmallScreen(context) ? const Text(
          "Try one block now for free!",
          style: TextStyle(
            fontSize: 16
          ),
          ) : Container(),
        actions: [
          ElevatedButton(
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
          ),
          ElevatedButton(
            onPressed: () {
                // Application.router.navigateTo(context, AppRoutes.register);
                Navigator.pushNamed(
                  context,
                  AppRoutes.trial
                );
            }, 
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                // If the button is pressed, return green, otherwise blue
                if (states.contains(MaterialState.pressed)) {
                  return AppThemes.lightestGreen;
                }
                return getAppBarColor();
            })),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: '3 Day Trial',
                style: TextStyle(
                  fontFamily:  AppFontFamily.poppins,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
          ),
           ElevatedButton(
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
                Flushbar(
                  title:  "Logout Successful",
                  message:  "User logout successful",
                  backgroundColor: AppThemes.notifBlue,
                  flushbarPosition: FlushbarPosition.TOP,
                  duration:  Duration(seconds: 3),
                ).show(context);
              }
          ),
          IconButton(
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
            },),
        ],
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        titleTextStyle: const TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white
        ),
      ),
      backgroundColor:  Color.fromRGBO(110, 121, 130,1),
      body: Column(
        children: [
          ResponsiveWidget.isSmallScreen(context) ? Container(
            color: AppThemes.angryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Try one block now for free!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black
                  ),
                )
            ],),
          ) : Container(),
          const Expanded(
            flex: 2,
            // height: MediaQuery.of(context).size.height * .20,
            child: Center(
              // child: RichText(
              //   textAlign: TextAlign.center,
              //   text: const TextSpan(
              //     text: 'What are ',
              //     style: TextStyle(
              //       fontFamily:  AppFontFamily.poppins,
              //       fontSize: 42,
              //       color: Colors.white
              //     ),
              //     children:  [
              //       TextSpan(text: 'you ', style: TextStyle(fontFamily:  AppFontFamily.poppins, fontWeight: FontWeight.bold, fontSize: 42, color: Colors.white)),
              //       TextSpan(text: 'feeling ', style: TextStyle(fontFamily:  AppFontFamily.poppins, fontSize: 42, color: Colors.white)),
              //       TextSpan(text: 'today?', style: TextStyle(fontFamily:  AppFontFamily.poppins, fontStyle: FontStyle.italic, fontSize: 42, color: Colors.white)),
              //     ],
              //   ),
              // ),
              child: AutoSizeText(
                'What are you feeling today?',
              maxLines: 1,
              minFontSize: 12,
              maxFontSize: 42, 
              style: TextStyle(
                  fontFamily: AppFontFamily.poppins,
                  fontSize: 42,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
              )
                )
            ),
          ),
           Expanded(
            flex: 12,
             child: Padding(
               padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
               child: GridView.count(
                childAspectRatio: (itemWidth / itemHeight),
                // childAspectRatio: (width / height),
                crossAxisSpacing: 40,
                mainAxisSpacing: 40,
                crossAxisCount: 2,
                children: <Widget>[
                  _getAngerCard(),
                  _getAnxiousCard(),
                  _getDepressionCard(),
                  _getGuiltyCard(),
                ],
                       ),
             ),
           ),
           Expanded(
            flex: 1,
            child: footer()
          )
         ],
      ),
    );    
  }


  Widget leadingAppBar() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(14,0,0,0),
      child: PlatformAwareAssetImage(
        asset: 'images/M4B_LOGO1_White.png',
        width: 0, height: 0
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
              side: const BorderSide(color: Colors.white, width: 1)
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap:() {

            },
            child: Container(
            // height: 40,
            color: AppThemes.lightestGrey,
              child: Center(
                child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Get the ',
                  style: TextStyle(fontFamily:  AppFontFamily.poppins, fontSize: 12, color: Colors.white),
                  children:  [
                    TextSpan(text: 'my4blocks ', style: TextStyle(fontFamily:  AppFontFamily.poppins, fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                    TextSpan(text: 'masterclass', style: TextStyle(fontFamily:  AppFontFamily.poppins, fontStyle: FontStyle.italic, fontSize: 12, color: Colors.white)),
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
            // height: 40,
              color: AppThemes.mediumGrey,
              child: Center(
                child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'The Ultimate ',
                  style: TextStyle(fontFamily:  AppFontFamily.poppins, fontSize: 12, color: Colors.white),
                  children:  [
                    TextSpan(text: 'Mental Health Nutitrion Guide ', style: TextStyle(fontFamily:  AppFontFamily.poppins, fontStyle: FontStyle.italic, fontSize: 12)),
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
            // height: 40,
            color: AppThemes.darkGrey,
            child: Center(
              child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Try ',
                style: TextStyle(fontFamily:  AppFontFamily.poppins, fontSize: 12, color: Colors.white),
                children:  [
                  TextSpan(text: 'Personalized Coaching ', style: TextStyle(fontFamily:  AppFontFamily.poppins, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
                          ),
            ),
          ),
        ),
      )
    ]);
  }
}

