import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/app_themes.dart';

import '../screens/prompt.screen.dart';

class Constants {
  static const String Angry = 'Angry';
  static const String Anxious = 'Anxious';
  static const String Depressed = 'Depression';
  static const String Guilty = 'Guilty';

  static const List<String> choices = <String>[Angry, Anxious, Depressed, Guilty];
}
  late DatabaseReference _promptsRef;

class DecisionScreen extends StatefulWidget {
  @override
  _DecisionScreenState createState() => _DecisionScreenState();
}

class _DecisionScreenState extends  State<DecisionScreen> {
  var rng = Random();

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
    final double itemHeight = (size.height - kToolbarHeight - 24) / 5;
    final double itemWidth = size.width / 4;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(247,247,248,1),
      body:Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .20,
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'How are ',
                  style: TextStyle(fontSize: 42),
                  children:  [
                    TextSpan(text: 'you ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 42)),
                    TextSpan(text: 'feeling ', style: TextStyle(fontSize: 42)),
                    TextSpan(text: 'today?', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 42)),
                  ],
                ),
              ),
            ),
          ),
           Expanded(
             child: GridView.count(
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisCount: 2,
              children: <Widget>[
                buildCardWithIcon(
                  null,
                  context,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PromptScreen(category: "Anger");
                        },
                      ),
                    );
                  },
                  "Angry",
                AppThemes.angryColor
                ),
                buildCardWithIcon(
                  null,
                  context,
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return PromptScreen(category: "Anxiety");
                    }));
                  },
                  "Anxious",
                AppThemes.anxiousColor
                ),
                buildCardWithIcon(
                  null,
                  context,
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return PromptScreen(category: "Depression");
                    }));
                  },
                  "Depressed",
                  AppThemes.depressedColor
                ),
                buildCardWithIcon(
                  null,
                  context,
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return PromptScreen(category: "Guilty");
                    }));
                  },
                  "Guilty",
                  AppThemes.guiltyColor
                )
              ],
                     ),
           ),
           footer()
         ],
      ),
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
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Text(
                  pageName,
                  style: const TextStyle(
                    fontSize: 64,
                    color: Colors.white,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget footer() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
            height: 40,
            color: Theme.of(context).colorScheme.tertiary,
              child: Center(
                child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Get the ',
                  style: TextStyle(fontSize: 18),
                  children:  [
                    TextSpan(text: 'my4blocks ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    TextSpan(text: 'masterclass', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18)),
                  ],
                ),
                            ),
              ),
            ),
          ),
        Expanded(
          child: Container(
          height: 40,
            color: Theme.of(context).colorScheme.secondary,
            child: Center(
              child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'The Ultimate ',
                style: TextStyle(fontSize: 18),
                children:  [
                  TextSpan(text: 'Mental Health Nutitrion Guide ', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18)),
                ],
              ),
                          ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 40,
            color: Theme.of(context).colorScheme.primary,
            child: Center(
              child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Try ',
                style: TextStyle(fontSize: 18),
                children:  [
                  TextSpan(text: 'Personalized Coaching ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
                          ),
            ),
          ),
        )
      ]),
      );
  }
}

