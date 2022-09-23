import 'package:flutter/material.dart';
import 'package:mental_health_app/app_localizations.dart';
import 'package:mental_health_app/config/Application.dart';
import 'package:mental_health_app/constants/app_font_family.dart';
import 'package:mental_health_app/constants/app_themes.dart';
import 'package:mental_health_app/models/user_model.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/routes.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppThemes.anxiousColor,
        title: const Text(
          'Register',
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
      body: Stack(
        children: <Widget>[
          _buildBackground(),
          Align(
            alignment: Alignment.center,
            child: _buildForm(context),
          ),
        ],
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
    final authProvider = Provider.of<AuthProvider>(context);

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FlutterLogo(
                    size: 128,
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  style: Theme.of(context).textTheme.bodyLarge,
                  validator: (value) => value!.isEmpty
                      // ? AppLocalizations.of(context)
                      //     .translate("loginTxtErrorEmail")
                      ? "Error in email"
                      : null,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      // labelText: AppLocalizations.of(context)
                      //     .translate("loginTxtEmail"),
                      labelText: "Email",
                      border: OutlineInputBorder()),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: TextFormField(
                    obscureText: true,
                    maxLength: 12,
                    controller: _passwordController,
                    style: Theme.of(context).textTheme.bodyLarge,
                    validator: (value) => value!.length < 6
                        // ? AppLocalizations.of(context)
                        //     .translate("loginTxtErrorPassword")
                        ? "Error in password"
                        : null,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        // labelText: AppLocalizations.of(context)
                        //     .translate("loginTxtPassword"),
                        labelText: "Password",
                        border: OutlineInputBorder()),
                  ),
                ),
                authProvider.status == Status.Registering
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        child: Text(
                          // AppLocalizations.of(context)
                          //     .translate("loginBtnSignUp"),
                          "Sign up",
                          style: Theme.of(context).textTheme.button,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context)
                                .unfocus(); //to hide the keyboard - if any

                            UserModel userModel =
                                await authProvider.registerWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text);

                            // if (userModel == null) {
                            //   _scaffoldKey.currentState!.showSnackBar(SnackBar(
                            //     content: Text(AppLocalizations.of(context)
                            //         .translate("loginTxtErrorSignIn")),
                            //   ));
                            // }
                          }
                        }),
                authProvider.status == Status.Registering
                    ? Center(
                        child: null,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: Center(
                            child: Text(
                          // AppLocalizations.of(context)
                          //     .translate("loginTxtHaveAccount"),
                          "Have Account",
                          style: Theme.of(context).textTheme.button,
                        )),
                      ),
                authProvider.status == Status.Registering
                    ? Center(
                        child: null,
                      )
                    : TextButton(
                        // child: Text(AppLocalizations.of(context)
                        //     .translate("loginBtnLinkSignIn")),
                        child: Text("Sign In"),
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Theme.of(context).textTheme.bodyText1;
                              return null; // Use the component's default.
                            },
                          ),),
                        onPressed: () {
                          // Navigator.of(context)
                          //     .pushReplacementNamed('/login');
                          Application.router.navigateTo(context, AppRoutes.login);
                        },
                      ),
              ],
            ),
          ),
        ));
  }
  Widget _buildBackground() {
    return ClipPath(
      clipper: SignInCustomClipper(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}

class SignInCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    var firstEndPoint = Offset(size.width / 2, size.height - 95);
    var firstControlPoint = Offset(size.width / 6, size.height * 0.45);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height / 2 - 50);
    var secondControlPoint = Offset(size.width, size.height + 15);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}