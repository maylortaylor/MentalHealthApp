import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/app_localizations.dart';
import 'package:mental_health_app/constants/app_font_family.dart';
import 'package:mental_health_app/constants/app_routes.dart';
import 'package:mental_health_app/constants/app_themes.dart';
import 'package:mental_health_app/models/user_model.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/routes.dart';
import 'package:mental_health_app/services/firestore_database.dart';
import 'package:mental_health_app/ui/auth/login_screen.dart';
import 'package:mental_health_app/widgets/responsive.dart';
import 'package:provider/provider.dart';
import 'package:responsive_ui/responsive_ui.dart';

class PayWallScreen extends StatefulWidget {
  @override
  _PayWallScreenState createState() => _PayWallScreenState();
}

class _PayWallScreenState extends State<PayWallScreen> {
  late TextEditingController _creditCardNumberController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();

    _creditCardNumberController = TextEditingController(text: "");
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppThemes.midCardColor,
      appBar: AppBar(
        backgroundColor: AppThemes.anxiousColor,
        title: const Text(
          'Payment',
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
        child: Padding(
          padding: ResponsiveWidget.isSmallScreen(context) ? 
          EdgeInsets.fromLTRB(20, 20, 20, 0) : EdgeInsets.fromLTRB(20, 100, 20, 0),
          child: Responsive(
            children: [
            Div(
              divison: const Division(
                colS: 12,
                colM: 6,
                colL: 7
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    !ResponsiveWidget.isSmallScreen(context) ? Container(
                      height: MediaQuery.of(context).size.height * 0.10,
                    ) : Container(),
                    AutoSizeText(
                      "Manage Anger, Anxiety, Depression & Guilt",
                      maxLines: 1,
                      minFontSize: 12,
                      maxFontSize: 26, 
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    AutoSizeText(
                      "with this simple & effective therapy tool.",
                      maxLines: 1,
                      minFontSize: 12,
                      maxFontSize: 26, 
                      style: Theme.of(context).textTheme.displayLarge
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          'images/All-White/M4B_LOGO2_AllWhite-34.png',
                          width:400, height:150
                         ),
                      )
                    )
                  ],
                ),
              ),
            ),
            Div(
              divison: const Division(
                colS: 12,
                colM: 6,
                colL: 5
              ),
              child: Card(
                color: AppThemes.whiteColor,
                child: Align(
                  alignment: Alignment.center,
                  child: _buildForm(context),
                ),
              ),
            ),
            ]
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _creditCardNumberController.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
            child: authProvider.status == Status.Registering
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(50),
                      child: CircularProgressIndicator(),
                    ),
                  ) : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: 
                    Column(
                      children: [
                        Text(
                          "3-Day Free Trial, then \$11/mo",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontStyle: FontStyle.normal
                          )
                        ),
                        Text(
                          "No Risk, Cancel Anytime",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontStyle: FontStyle.italic
                          ),),
                      ],)
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      child: Text(
                        "Stripe",
                        style: TextStyle(
                          color: AppThemes.whiteColor,
                          fontSize: 22,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          

                          // if (userModel == null) {
                          //   Flushbar(
                          //     title:  "Error During Login",
                          //     message:  "User Info Incorrect",
                          //     backgroundColor: AppThemes.notifRed,
                          //     flushbarPosition: FlushbarPosition.TOP,
                          //     duration:  Duration(seconds: 3),
                          //   ).show(context);
                          // } else {
                          //   Flushbar(
                          //     title:  "Login Successful",
                          //     message:  "User login successful",
                          //     backgroundColor: AppThemes.notifBlue,
                          //     flushbarPosition: FlushbarPosition.TOP,
                          //     duration:  Duration(seconds: 3),
                          //   ).show(context);
                          //     Navigator.pushNamed(
                          //         context,
                          //         AppRoutes.root,
                          //     );                              
                          // }

                        }
                      }),
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextButton(
                    child: Text("Existing Users Login Here"),
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context).textTheme.bodyText1;
                          return null; // Use the component's default.
                        },
                      ),),
                    onPressed: () {
                      Navigator.pushNamed(
                          context,
                          AppRoutes.login,
                        );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

}