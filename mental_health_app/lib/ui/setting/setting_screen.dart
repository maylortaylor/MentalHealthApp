import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/config/Application.dart';
import 'package:mental_health_app/constants/app_themes.dart';
import 'package:mental_health_app/models/user_model.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/providers/theme_provider.dart';
import 'package:mental_health_app/routes.dart';
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
late TextfieldTagsController _controller;
late final TextEditingController _displayNameController = TextEditingController();
late final TextEditingController _emailAddressController = TextEditingController();
late UserModel _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();
    _user = UserModel();
    _getUser();
  }

  _getUser() {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final a = authProvider.user;
    
    // firestoreDatabase.getUser(uid: authProvider.user.)

    // authProvider.user.listen((value) {
    //   DateTime now = DateTime.now();

    //   setState(() {
    //         _user = UserModel(
    //         uid: value.uid,
    //         email: value.email,
    //         displayName: value.displayName,
    //         pathsAllowed: _controller.getTags ?? _availableCategories,
    //         dateCreated: value.dateCreated ?? now.toIso8601String(),
    //         lastModified: now.toIso8601String(),
    //         isSubscribed: false
    //       );
    //       _emailAddressController.text = value.email!;
    //   });
    // });
  }


  static const List<String> _availableCategories = <String>[
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

    if (_user.uid!.isNotEmpty) {
      _user.displayName = _displayNameController.text;
      _user.lastModified = DateTime.now().toIso8601String();
      _user.pathsAllowed = _controller.getTags;

      await firestoreDatabase.setUser(_user);
    }
  }

  Widget _buildLayoutSection(BuildContext context) {
    return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                _user.uid ?? ""
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
                return _availableCategories.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selectedTag) {
                _controller.addTag = selectedTag;
              },
              fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
                return TextFieldTags(
                  textEditingController: ttec,
                  focusNode: tfn,
                  textfieldTagsController: _controller,
                  initialTags: _availableCategories,
                  textSeparators: const [' ', ','],
                  letterCase: LetterCase.normal,
                  validator: (String tag) {
                    // if (tag == 'php') {
                    //   return 'No, please just no';
                    // } else if (_controller.getTags!.contains(tag)) {
                    //   return 'you already entered that';
                    // }
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
                            hintText: _controller.hasTags ? '' : "Enter categories / paths...",
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
                  _controller.clearTags();
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
                  Application.router.navigateTo(context, AppRoutes.root);
                },
                child: const Text('SAVE SETTINGS'),
              ),
            ),
          ],
        );
    // return ListView(
    //   children: <Widget>[
    //     // ListTile(
    //     //   title: Text("Theme List subtitle"),
    //     //   // title: Text(
    //     //   //     AppLocalizations.of(context).translate("settingThemeListTitle")),
    //     //   // subtitle: Text(AppLocalizations.of(context)
    //     //   //     .translate("settingThemeListSubTitle")),
    //     //   trailing: Switch(
    //     //     activeColor: Theme.of(context).appBarTheme.color,
    //     //     activeTrackColor: Theme.of(context).textTheme.titleLarge!.color,
    //     //     value: Provider.of<ThemeProvider>(context).isDarkModeOn,
    //     //     onChanged: (booleanValue) {
    //     //       Provider.of<ThemeProvider>(context, listen: false)
    //     //           .updateTheme(booleanValue);
    //     //     },
    //     //   ),
    //     // ),
    //     // ListTile(
    //     //   title: Text("Language List"),
    //     //   subtitle: Text("Language subtitle"),
    //     //   trailing: SettingLanguageActions(),
    //     // ),
    //     // ListTile(
    //     //   title: Text(
    //     //       "Logout list title"),
    //     //   subtitle: Text("logout list subtitle"),
    //     //   trailing: ElevatedButton(
    //     //       onPressed: () {
    //     //         // _confirmSignOut(context);
    //     //         print("confirm sign out");
    //     //       },
    //     //       child: Text("logout button")),
    //     // )
    //     TextFieldTags(
    //       textfieldTagsController: _controller,
    //       initialTags: const [
    //         'anxiety',
    //         'depression',
    //         'guilt',
    //         'anger',
    //       ],
    //       textSeparators: const [' ', ','],
    //       letterCase: LetterCase.normal,
    //       validator: (String tag) {
    //         // if (tag == 'php') {
    //         //   return 'No, please just no';
    //         // } else if (_controller.getTags.contains(tag)) {
    //         //   return 'you already entered that';
    //         // }
    //         return null;
    //       },
    //       inputfieldBuilder:
    //           (context, tec, fn, error, onChanged, onSubmitted) {
    //         return ((context, sc, tags, onTagDelete) {
    //           return Padding(
    //             padding: const EdgeInsets.all(10.0),
    //             child: TextField(
    //               controller: tec,
    //               focusNode: fn,
    //               decoration: InputDecoration(
    //                 isDense: true,
    //                 border: const OutlineInputBorder(
    //                   borderSide: BorderSide(
    //                     color: Color.fromARGB(255, 74, 137, 92),
    //                     width: 3.0,
    //                   ),
    //                 ),
    //                 focusedBorder: const OutlineInputBorder(
    //                   borderSide: BorderSide(
    //                     color: Color.fromARGB(255, 74, 137, 92),
    //                     width: 3.0,
    //                   ),
    //                 ),
    //                 helperText: 'available category access...',
    //                 helperStyle: const TextStyle(
    //                   color: Color.fromARGB(255, 74, 137, 92),
    //                 ),
    //                 hintText: _controller.hasTags ? '' : "Enter category...",
    //                 errorText: error,
    //                 prefixIconConstraints:
    //                     BoxConstraints(maxWidth: _distanceToField * 0.74),
    //                 prefixIcon: tags.isNotEmpty
    //                     ? SingleChildScrollView(
    //                         controller: sc,
    //                         scrollDirection: Axis.horizontal,
    //                         child: Row(
    //                             children: tags.map((String tag) {
    //                           return Container(
    //                             decoration: const BoxDecoration(
    //                               borderRadius: BorderRadius.all(
    //                                 Radius.circular(20.0),
    //                               ),
    //                               color: Color.fromARGB(255, 74, 137, 92),
    //                             ),
    //                             margin: const EdgeInsets.symmetric(
    //                                 horizontal: 5.0),
    //                             padding: const EdgeInsets.symmetric(
    //                                 horizontal: 10.0, vertical: 5.0),
    //                             child: Row(
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                 InkWell(
    //                                   child: Text(
    //                                     '#$tag',
    //                                     style: const TextStyle(
    //                                         color: Colors.white),
    //                                   ),
    //                                   onTap: () {
    //                                     print("$tag selected");
    //                                   },
    //                                 ),
    //                                 const SizedBox(width: 4.0),
    //                                 InkWell(
    //                                   child: const Icon(
    //                                     Icons.cancel,
    //                                     size: 14.0,
    //                                     color: Color.fromARGB(
    //                                         255, 233, 233, 233),
    //                                   ),
    //                                   onTap: () {
    //                                     onTagDelete(tag);
    //                                   },
    //                                 )
    //                               ],
    //                             ),
    //                           );
    //                         }).toList()),
    //                       )
    //                     : null,
    //               ),
    //               onChanged: onChanged,
    //               onSubmitted: onSubmitted,
    //             ),
    //           );
    //         });
    //       },
    //     ),
    //   ],
    // );
  }



  // _confirmSignOut(BuildContext context) {
  //   showPlatformDialog(
  //       context: context,
  //       builder: (_) => PlatformAlertDialog(
  //             material: (_, PlatformTarget target) => MaterialAlertDialogData(
  //                 backgroundColor: Theme.of(context).appBarTheme.color),
  //             title: Text(
  //                 "dialog title"),
  //             content: Text(
  //                 "dialog message"),
  //             actions: <Widget>[
  //               PlatformDialogAction(
  //                 child: PlatformText("Dialog Cancel"),
  //                 onPressed: () => Navigator.pop(context),
  //               ),
  //               PlatformDialogAction(
  //                 child: PlatformText("Yes"),
  //                 onPressed: () {
  //                   final authProvider =
  //                       Provider.of<AuthProvider>(context, listen: false);

  //                   authProvider.signOut();

  //                   Application.router.navigateTo(context, '/login');
  //                   // Navigator.pop(context);
  //                   // Navigator.of(context).pushNamedAndRemoveUntil(
  //                   //     '/login', ModalRoute.withName('/login'));
  //                 },
  //               )
  //             ],
  //           ));
  // }


}