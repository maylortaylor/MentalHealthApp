import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/app_localizations.dart';
import 'package:mental_health_app/constants/app_font_family.dart';
import 'package:mental_health_app/constants/app_routes.dart';
import 'package:mental_health_app/constants/app_colors.dart';
import 'package:mental_health_app/models/user_model.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/routes.dart';
import 'package:mental_health_app/services/firestore_database.dart';
import 'package:mental_health_app/ui/auth/login_screen.dart';
import 'package:mental_health_app/widgets/platform_aware_asset_image.dart';
import 'package:mental_health_app/widgets/responsive.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:responsive_ui/responsive_ui.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Login',
          style: Theme.of(context).textTheme.displaySmall
          ,),
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
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: PlatformAwareAssetImage(
                          asset: 'images/All-White/M4B_LOGO2_AllWhite-34.png',
                          width:400, height:150
                        )
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
                color: Theme.of(context).cardColor,
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context) {

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    style: Theme.of(context).textTheme.labelMedium,
                    validator: validateEmail,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).indicatorColor,
                        ),
                        labelText: "Email*",
                        labelStyle: Theme.of(context).textTheme.labelMedium,
                        border: OutlineInputBorder(
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    obscureText: _obscureText,
                    maxLength: 12,
                    controller: _passwordController,
                    style: Theme.of(context).textTheme.labelMedium,
                    validator: (value) => value!.length < 6
                        ? "Error in Password"
                        : null,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Theme.of(context).indicatorColor,
                      ),
                      suffix: IconButton(
                        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                        color: Theme.of(context).indicatorColor,
                        onPressed: _toggleObscureText,
                      ),
                      labelText: "Password*",
                      labelStyle: Theme.of(context).textTheme.labelMedium,
                      helperStyle: Theme.of(context).textTheme.labelSmall,
                      border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor
                        // textStyle: Theme.of(context).textTheme.displayLarge
                      ),
                      // style: ButtonStyle(
                      //     backgroundColor: MaterialStateProperty.resolveWith((states) {
                      //     // If the button is pressed, return green, otherwise blue
                      //     if (states.contains(MaterialState.pressed)) {
                      //       return AppColors.indicatorColor;
                      //     }
                      //     return Theme.of(context).;
                      // })),
                      child: Text(
                        "Sign In",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context)
                              .unfocus(); //to hide the keyboard - if any
                          // signInUser();
                          // UserModel? userModel =
                          //     await authProvider.signInWithEmailAndPassword(
                          //         _emailController.text,
                          //         _passwordController.text);

                          // if (userModel == null) {
                          //   Flushbar(
                          //     title:  "Error During Login",
                          //     message:  "User Info Incorrect",
                          //     backgroundColor: AppColors.notifRed,
                          //     flushbarPosition: FlushbarPosition.TOP,
                          //     duration:  Duration(seconds: 3),
                          //   ).show(context);
                          // } else {
                          //   Flushbar(
                          //     title:  "Login Successful",
                          //     message:  "User login successful",
                          //     backgroundColor: AppColors.notifBlue,
                          //     flushbarPosition: FlushbarPosition.TOP,
                          //     duration:  Duration(seconds: 3),
                          //   ).show(context);
                          //     Navigator.pushNamed(
                          //         context,
                          //         AppRoutes.root,
                          //    );                              
                          // }
                        }
                      }),
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context).textTheme.bodyText1;
                            return null; // Use the component's default.
                          },
                        ),),
                      onPressed: () {
                        // Navigator.pushNamed(
                        //     context,
                        //     AppRoutes.register,
                        //   );
                      },
                      child: Text(
                        "Don't Have An Account?",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                ),
              ],
            ),
          ),
        ));
  }

}

  String? validateEmail(String? value) {
    String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Email Address required';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid email address';
    }
    return null;
  }

  signInUser() async {
    var settings = ConnectionSettings(
      host: 'u92444630500443.db.44630500.352.hostedresource.net', 
      port: 3309,
      user: 'u92444630500443',
      password: 'HQeP98.{B(+ei',
      db: 'mydb'
    );
    var conn = await MySqlConnection.connect(settings);

    var userId = 1;
    var results = await conn.query('select name, email from users where id = ?', [userId]);
  }