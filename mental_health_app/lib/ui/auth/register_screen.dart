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

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _zipcodeController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordontroller;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _obscurePasswordText = true;
  bool _obscureConfirmText = true;


  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController(text: "");
    _lastNameController = TextEditingController(text: "");
    _zipcodeController = TextEditingController(text: "");
    _phoneNumberController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _confirmPasswordontroller = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppThemes.midCardColor,
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _zipcodeController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordontroller.dispose();
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
                Row(
                  children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: TextFormField(
                        controller: _firstNameController,
                        autofocus: true,
                        style: Theme.of(context).textTheme.bodySmall,
                        validator: (value) => value!.isEmpty
                            ? "First Name required"
                            : null,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            labelText: "First Name*",
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: TextFormField(
                        controller: _lastNameController,
                        style: Theme.of(context).textTheme.bodySmall,
                        validator: (value) => value!.isEmpty
                            ? "Last Name required"
                            : null,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            labelText: "Last Name*",
                            border: OutlineInputBorder()),
                      ),
                    ),
                  )
                ],),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    style: Theme.of(context).textTheme.bodySmall,
                    validator: validateEmail,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        labelText: "Email*",
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePasswordText,
                    maxLength: 12,
                    style: Theme.of(context).textTheme.bodySmall,
                    validator: (value) => value!.length < 6
                        ? "Error in Password"
                        : null,
                    decoration: InputDecoration(
                      suffix: IconButton(
                        icon: Icon(_obscurePasswordText ? Icons.visibility : Icons.visibility_off),
                        color: Theme.of(context).iconTheme.color,
                        onPressed: _togglePasswordObscureText,
                      ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        labelText: "Password*",
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _confirmPasswordontroller,
                    obscureText: _obscureConfirmText,
                    maxLength: 12,
                    style: Theme.of(context).textTheme.bodySmall,
                    validator: (value) {
                        if (value!.length < 6) {
                         return "Error in Confirm Password";
                        }
                        
                        if (value != _passwordController.text) {
                          return "Passwords do not match";
                        }
                    },
                    decoration: InputDecoration(
                      suffix: IconButton(
                        icon: Icon(_obscureConfirmText ? Icons.visibility : Icons.visibility_off),
                        color: Theme.of(context).iconTheme.color,
                        onPressed: _toggleConfirmObscureText,
                      ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        labelText: "Confirm Password*",
                        border: OutlineInputBorder()),
                  ),
                ),
                Row(
                  children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: TextFormField(
                        controller: _zipcodeController,
                        autofocus: true,
                        style: Theme.of(context).textTheme.bodySmall,
                        validator: validateZipcode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            labelText: "Zipcode (optional)",
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: TextFormField(
                        controller: _phoneNumberController,
                        style: Theme.of(context).textTheme.bodySmall,
                        validator: validatePhoneNumber,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            labelText: "Phone (optional)",
                            border: OutlineInputBorder()),
                      ),
                    ),
                  )
                ],),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        child: Text(
                          "Sign up",
                          style: Theme.of(context).textTheme.button,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context)
                                .unfocus();
                  
                            UserModel? userModel =
                                await authProvider.registerWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text,
                                    _firstNameController.text,
                                    _lastNameController.text,
                                    _zipcodeController.text,
                                    _phoneNumberController.text);
                  
                            if (userModel!.uid!.isNotEmpty) {
                              // saveUserToDatabase();
                              Flushbar(
                                title:  "User Created",
                                message:  "User info was created successfully",
                                backgroundColor: AppThemes.notifGreen,
                                flushbarPosition: FlushbarPosition.TOP,
                                duration:  Duration(seconds: 3),
                              ).show(context);
                            }
                  
                            Navigator.pushNamed(
                                context,
                                AppRoutes.home,
                              );
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


  void _togglePasswordObscureText() {
    setState(() {
      _obscurePasswordText = !_obscurePasswordText;
    });
  }

  void _toggleConfirmObscureText() {
    setState(() {
      _obscureConfirmText = !_obscureConfirmText;
    });
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

   String? validateZipcode(String? value) {
    String pattern = r"[a-z0-9][a-z0-9\- ]{0,10}[a-z0-9]$";
    RegExp regExp = RegExp(pattern);
    // if (value!.isEmpty) {
    //   return 'Email Address required';
    // }
    if (!regExp.hasMatch(value!)) {
      return 'Please enter valid zipcode';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    String pattern = r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)';
    RegExp regExp = RegExp(pattern);
    // if (value!.isEmpty) {
    //   return 'Mobile Number required';
    // }
    if (!regExp.hasMatch(value!)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }