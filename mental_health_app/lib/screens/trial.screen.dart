import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/app_localizations.dart';
import 'package:mental_health_app/constants/app_font_family.dart';
import 'package:mental_health_app/constants/app_routes.dart';
import 'package:mental_health_app/constants/app_themes.dart';
import 'package:mental_health_app/models/arguments/PromptArguments.dart';
import 'package:mental_health_app/models/user_model.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/routes.dart';
import 'package:mental_health_app/screens/prompt.screen.dart';
import 'package:mental_health_app/services/firestore_database.dart';
import 'package:mental_health_app/ui/auth/login_screen.dart';
import 'package:mental_health_app/widgets/platform_aware_asset_image.dart';
import 'package:mental_health_app/widgets/responsive.dart';
import 'package:provider/provider.dart';
import 'package:responsive_ui/responsive_ui.dart';

class TrialScreen extends StatefulWidget {
  @override
  _TrialScreenState createState() => _TrialScreenState();
}

class _TrialScreenState extends State<TrialScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppThemes.lightGrey,
      appBar: AppBar(
        backgroundColor: AppThemes.darkGrey,
        title: const Text(
          'Trial Offer',
          style: TextStyle(
            fontFamily: AppFontFamily.poppins,
            fontSize: 22
          ),),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        titleTextStyle: const TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Flexible(
              child: Padding(
                padding: ResponsiveWidget.isSmallScreen(context) ? 
                EdgeInsets.fromLTRB(20, 20, 20, 20) : EdgeInsets.fromLTRB(20, 100, 20, 20),
                child: Responsive(
                  children: [
                  Div(
                    divison: const Division(
                      colS: 12,
                      colM: 12,
                      colL: 6
                    ),
                    child: Column(
                      children: [
                        !ResponsiveWidget.isSmallScreen(context) ? Container(
                          height: MediaQuery.of(context).size.height * 0.10,
                        ) : Container(),
                        mainText(),
                      ],
                    ),
                  ),
                  Div(
                    divison: const Division(
                      colS: 12,
                      colM: 12,
                      colL: 6
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: const PlatformAwareAssetImage(asset: 'images/dr_face.png',
                            width:400, height:500, fit: BoxFit.contain,),
                    ),
                  ),
                  ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mainText() {
    return Row(
      children: [
      Flexible(
        child: Column(children: [
        const Align(
          alignment: Alignment.center,
          child: AutoSizeText(
            "Welcome to Dr. Parr's",
            maxLines: 1,
            minFontSize: 18,
            maxFontSize: 32, 
            style: TextStyle(
              fontFamily: AppFontFamily.poppins,
              fontStyle: FontStyle.normal,
              color: Colors.white,
              fontSize: 32)
          ),
        ),
        const Align(
          alignment: Alignment.center,
          child: AutoSizeText(
            "'4 Blocks Emotional Calculator'",
            maxLines: 1,
            minFontSize: 18,
            maxFontSize: 32,
            style: TextStyle(
              fontFamily: AppFontFamily.poppins,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              fontSize: 32),
          ),
        ),
        const Align(
          alignment: Alignment.center,
          child: AutoSizeText(
            "Before you jump in to managing",
            maxLines: 1,
            minFontSize: 12,
            maxFontSize: 26,
            style: TextStyle(
              fontFamily: AppFontFamily.poppins,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 32),
          ),
        ),
        const Align(
          alignment: Alignment.center,
          child: AutoSizeText(
            "Anger, Anxiety, Depression & Guilt...",
            maxLines: 1,
            minFontSize: 12,
            maxFontSize: 26, 
            style: TextStyle(
              fontFamily: AppFontFamily.poppins,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontSize: 32)
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: startTrialButton(),
        )
        ],),
      )      
    ],);
  }

  Widget startTrialButton() {
    return ElevatedButton(
      onPressed: () => {
        Navigator.push(context, MaterialPageRoute(
              settings: RouteSettings(name: AppRoutes.abcs, arguments: PromptArguments('ABCs')),
              builder: (context) {
                return PromptScreen(args: PromptArguments('ABCs'),);
            }))
      },
      style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return AppThemes.lightestGreen;
          }
          return Colors.black;
      } )),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          text: 'You must first learn your ABC\'s! \n CLICK HERE TO BEGIN!',
          style: TextStyle(
            fontFamily:  AppFontFamily.poppins,
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.white
          ),
        ),
    ),
      ));
  }

}