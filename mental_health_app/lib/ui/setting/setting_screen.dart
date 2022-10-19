import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/app_routes.dart';
import 'package:mental_health_app/constants/app_themes.dart';
import 'package:mental_health_app/models/user_model.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/services/firestore_database.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _formKey = GlobalKey<FormState>();
  late double _distanceToField;
  late TextfieldTagsController _tagsController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailAddressController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _zipcodeController;
  late UserModel? _user;

  static const List<String> _defaultCategories = <String>[
    'anger',
    'anxiety',
    'depression',
    'guilt'
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _tagsController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailAddressController.dispose();
    _zipcodeController.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    _user = UserModel();
    _tagsController = TextfieldTagsController();
    _firstNameController  = TextEditingController();
    _lastNameController  = TextEditingController();
    _emailAddressController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _zipcodeController = TextEditingController();
    _getUserModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [
            IconButton(
            tooltip: 'Answers',
            icon: Icon(Icons.question_answer), 
            color: AppThemes.whiteColor,
            onPressed: () {
              print("user answers icon pressed");
              // Application.router.navigateTo(context, AppRoutes.settings);
                    Navigator.pushNamed(
                        context,
                        AppRoutes.answers,
                        // arguments: PromptArguments(
                        //   'anxiety',
                        //   1,
                        // ),
                      );
            },)
        ],
      ),
      body: _buildLayoutSection(context),
    );
  }
  
  _getUserModel() async {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String currentUserId = await authProvider.getCurrentUID();
    
    firestoreDatabase.getUserModel(uid: currentUserId).then((value)  {
      _user = value;
      
      setState(() {
        _emailAddressController.text = _user!.email!;
        _firstNameController.text = _user!.firstName!;
        _lastNameController.text = _user!.lastName!;
        _phoneNumberController.text = _user!.phoneNumber!;
        _zipcodeController.text = _user!.zipcode!;
        for (var opt in _user!.pathsAllowed!) {
          _tagsController.addTag = opt;
        }
      });
    });
  }
  
  saveSettings() async {
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);

    if (_user!.uid!.isNotEmpty) {
      _user?.firstName = _firstNameController.text;
      _user?.lastName = _lastNameController.text;
      _user?.pathsAllowed = _tagsController.getTags;
      _user?.phoneNumber = _phoneNumberController.text;
      _user?.zipcode = _zipcodeController.text;
      _user?.lastModified = DateTime.now().toIso8601String();

      // await firestoreDatabase.setUser(_user!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: _buildLayoutSection(context),
    );
  }



    Flushbar(
      title:  "User Updated",
      message:  "User info was saved successfully",
      backgroundColor: AppThemes.notifGreen,
      flushbarPosition: FlushbarPosition.TOP,
      duration:  Duration(seconds: 3),
    ).show(context);

  }

  Widget _buildLayoutSection(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _userIdFormField(),
            Row(
              children: [
                _firstNameFormField(),
                _lastNameFormField(),
              ],
            ),
            _emailAddressFormField(),
            Row(
              children: [
                _phoneNumberFormField(),
                _zipcodeFormField(),
              ],
            ),
            Autocomplete<String>(
              optionsViewBuilder: (context, onSelected, options) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 4.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Material(
                      elevation: 4.0,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final dynamic option = options.elementAt(index);
                            return TextButton(
                              onPressed: () {
                                onSelected(option);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: Text(
                                    '#$option',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 74, 137, 92),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return _defaultCategories.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selectedTag) {
                _tagsController.addTag = selectedTag;
              },
              fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
                return TextFieldTags(
                  textEditingController: ttec,
                  focusNode: tfn,
                  textfieldTagsController: _tagsController,
                  textSeparators: const [' ', ','],
                  letterCase: LetterCase.normal,
                  validator: (String tag) {
                    // if (tag == 'php') {
                    //   return 'No, please just no';
                    if (_tagsController.getTags!.contains(tag)) {
                      return 'you already entered that';
                    }
                    return null;
                  },
                  inputfieldBuilder:
                      (context, tec, fn, error, onChanged, onSubmitted) {
                    return ((context, sc, tags, onTagDelete) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          controller: tec,
                          focusNode: fn,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 74, 137, 92),
                                  width: 3.0),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 74, 137, 92),
                                  width: 3.0),
                            ),
                            helperText: 'Choose available categories / paths...',
                            helperStyle: const TextStyle(
                              color: Color.fromARGB(255, 74, 137, 92),
                            ),
                            hintText: _tagsController.hasTags ? '' : "Enter categories / paths...",
                            errorText: error,
                            prefixIconConstraints: BoxConstraints(
                                maxWidth: _distanceToField * 0.74),
                            prefixIcon: tags.isNotEmpty
                                ? SingleChildScrollView(
                                    controller: sc,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        children: tags.map((String tag) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                          color:
                                              Color.fromARGB(255, 74, 137, 92),
                                        ),
                                        margin:
                                            const EdgeInsets.only(right: 10.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              child: Text(
                                                '#$tag',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onTap: () {
                                                //print("$tag selected");
                                              },
                                            ),
                                            const SizedBox(width: 4.0),
                                            InkWell(
                                              child: const Icon(
                                                Icons.cancel,
                                                size: 14.0,
                                                color: Color.fromARGB(
                                                    255, 233, 233, 233),
                                              ),
                                              onTap: () {
                                                onTagDelete(tag);
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList()),
                                  )
                                : null,
                          ),
                          onChanged: onChanged,
                          onSubmitted: onSubmitted,
                        ),
                      );
                    });
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(255, 74, 137, 92),
                  ),
                ),
                onPressed: () {
                  _tagsController.clearTags();
                },
                child: const Text('clear paths'),
              ),
            ),
            _isSubscribedCheckbox(),
            saveButton()
          ],
        ),
      ),
    );
  }

  _userIdFormField() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
          "UserId: ${_user?.uid}"
        ,)
    );
  }

  _firstNameFormField() {
    return Flexible(
      child: Container (
          padding: const EdgeInsets.all(10.0),
          color: Colors.white,
          child: Center(
            child: TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: "First Name",
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                  ),
                ),
                //fillColor: Colors.green
              ),
              validator: (val) {
                if(val!.isEmpty) {
                  return "First Name required";
                }
                return null;
              },
              keyboardType: TextInputType.name,
            )
          )
      ),
    );
  }

  _lastNameFormField() {
    return Flexible(
      child: Container (
          padding: const EdgeInsets.all(10.0),
          color: Colors.white,
          child: Center(
            child: TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: "Last Name",
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                  ),
                ),
                //fillColor: Colors.green
              ),
              validator: (val) {
                if(val!.isEmpty) {
                  return "Last Name required";
                }
                return null;
              },
              keyboardType: TextInputType.name,
            )
          )
      ),
    );
  }

  _emailAddressFormField() {
    return Container (
        padding: const EdgeInsets.all(10.0),
        color: Colors.white,
        child: Center(
          child: Column(
            children : [
              TextFormField(
                readOnly: true,
                controller: _emailAddressController,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                validator: validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
            ]
          )
      )
    );
  }

  _phoneNumberFormField() {
    return Flexible(
      child: Container (
          padding: const EdgeInsets.all(10.0),
          color: Colors.white,
          child: Center(
            child: Column(
              children : [
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                      ),
                    ),
                  ),
                  validator: validatePhoneNumber,
                  keyboardType: TextInputType.phone,
                ),
              ]
            )
            )
      ),
    );
  }

  _zipcodeFormField() {
    return Flexible(
      child: Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.white,
          child: Center(
            child: Column(
              children : [
                TextFormField(
                  controller: _zipcodeController,
                  decoration: InputDecoration(
                    labelText: "Zipcode",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                      ),
                    ),
                  ),
                  validator: validateZipcode,
                  keyboardType: TextInputType.phone,
                ),
              ]
            )
            )
      ),
    );
  }

  _isSubscribedCheckbox() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: CheckboxListTile(
        tileColor: AppThemes.promptCardColor,
        title: Text("Is Subscribed?"),
        value: _user?.isSubscribed,
        onChanged: _onIfSubscribedChanged,
        controlAffinity: ListTileControlAffinity.platform,
      )
    );
  }

  void _onIfSubscribedChanged(bool? newValue) {
    if (newValue != null) {
      setState(() {
        _user?.isSubscribed = newValue;
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
    if (value!.isEmpty) {
      return 'Mobile Number required';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  saveButton() {
    return  Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(AppThemes.angryColor),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            saveSettings(); // save settings to firebase UserModel
            Navigator.pushNamed(
              context,
              AppRoutes.root,
            );
          }
        },
        child: const Text('SAVE SETTINGS'),
      ),
    );
  }

}