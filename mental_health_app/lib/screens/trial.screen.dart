import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/app_routes.dart';
import 'package:mental_health_app/constants/app_colors.dart';
import 'package:mental_health_app/models/arguments/PromptArguments.dart';
import 'package:mental_health_app/screens/prompt.screen.dart';
import 'package:mental_health_app/widgets/platform_aware_asset_image.dart';
import 'package:mental_health_app/widgets/responsive.dart';
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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Trial Offer',
          style: Theme.of(context).textTheme.displaySmall
          ,),
        iconTheme: IconThemeData(
          color: AppColors.whiteColor, //change your color here
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
        Align(
          alignment: Alignment.center,
          child: AutoSizeText(
            "Welcome to Dr. Parr's",
            maxLines: 1,
            minFontSize: 18,
            maxFontSize: 32, 
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: AutoSizeText(
            "'4 Blocks Emotional Calculator'",
            maxLines: 1,
            minFontSize: 18,
            maxFontSize: 32,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: AutoSizeText(
            "Before you jump in to managing",
            maxLines: 1,
            minFontSize: 12,
            maxFontSize: 26,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: AutoSizeText(
            "Anger, Anxiety, Depression & Guilt...",
            maxLines: 1,
            minFontSize: 12,
            maxFontSize: 26, 
            style: Theme.of(context).textTheme.displayLarge,
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
            return AppColors.indicatorColor;
          }
          return AppColors.blackColor;
      } )),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'You must first learn your ABC\'s! \n CLICK HERE TO BEGIN!',
          style: Theme.of(context).textTheme.titleMedium
        ),
    ),
      ));
  }

}