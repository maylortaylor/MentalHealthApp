import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/config/Application.dart';
import 'package:mental_health_app/constants/app_routes.dart';
import 'package:mental_health_app/constants/app_themes.dart';
import 'package:mental_health_app/models/arguments/PromptArguments.dart';
import 'package:mental_health_app/models/user_model.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/providers/theme_provider.dart';
import 'package:mental_health_app/routes.dart';
import 'package:mental_health_app/screens/decision.screen.dart';
import 'package:mental_health_app/services/firestore_database.dart';
import 'package:mental_health_app/ui/setting/setting_language_actions.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
late double _distanceToField;
late TextfieldTagsController _tagsController;
late TextEditingController _displayNameController;
late TextEditingController _emailAddressController;
late UserModel? _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _tagsController.dispose();
    _displayNameController.dispose();
    _emailAddressController.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    _user = UserModel();
    _tagsController = TextfieldTagsController();
    _displayNameController  = TextEditingController();
    _emailAddressController = TextEditingController();
    _getUserModel();
  }

  _getUserModel() async {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String currentUserId = await authProvider.getCurrentUID();
    
    firestoreDatabase.getUserModel(uid: currentUserId).then((value)  {
      _user = value;
      
      setState(() {
        _emailAddressController.text = _user!.email!;
        _displayNameController.text = _user!.displayName!;
        for (var opt in _user!.pathsAllowed!) {
          _tagsController.addTag = opt;
        }
      });
    });

  }

  static const List<String> _defaultCategories = <String>[
    'anger',
    'anxiety',
    'depression',
    'guilt'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: _buildLayoutSection(context),
    );
  }

  saveSettings() async {
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);

    if (_user!.uid!.isNotEmpty) {
      _user?.displayName = _displayNameController.text;
      _user?.lastModified = DateTime.now().toIso8601String();
      _user?.pathsAllowed = _tagsController.getTags;

      await firestoreDatabase.setUser(_user!);
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
    return SingleChildScrollView(
      child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                   "${_user?.uid}"
                  ,)
              ),
              Container (
                  padding: const EdgeInsets.all(30.0),
                  color: Colors.white,
                  child: Center(
                    child: Column(
                     children : [
                      TextFormField(
                      controller: _displayNameController,
                      decoration: InputDecoration(
                        labelText: "Display Name",
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
                          return "Name cannot be empty";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                    ),
                     ]
                    )
                   )
              ),
              Container (
                  padding: const EdgeInsets.all(30.0),
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
                      validator: (val) {
                        if(val!.isEmpty) {
                          return "Email cannot be empty";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                     ]
                    )
                   )
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
                    // initialTags: _user!.pathsAllowed!.isNotEmpty ? _user!.pathsAllowed! : _defaultCategories,
                    // initialTags: _tagsController.getTags,
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
                      const Color.fromARGB(255, 74, 137, 92),
                    ),
                  ),
                  onPressed: () {
                    _tagsController.clearTags();
                  },
                  child: const Text('clear paths'),
                ),
              ),
    
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppThemes.angryColor),
                  ),
                  onPressed: () {
                    // save settings to firebase user
                    saveSettings();
                    Navigator.pushNamed(
                      context,
                      AppRoutes.root,
                    );
                  },
                  child: const Text('SAVE SETTINGS'),
                ),
              ),
            ],
          ),
    );
  }
}