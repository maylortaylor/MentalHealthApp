import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../main_2.dart';
import '../models/prompts.model.dart';
import '../widgets/colored_card.dart';
import '../screens/prompt.screen.dart';

class Constants {
  static const String Angry = 'Angry';
  static const String Anxious = 'Anxious';
  static const String Depressed = 'Depressed';
  static const String Guilty = 'Guilty';

  static const List<String> choices = <String>[Angry, Anxious, Depressed, Guilty];
}
  late DatabaseReference _promptsRef;

class DecisionScreen extends StatefulWidget {
  const DecisionScreen({Key? key}) : super(key: key);

  @override
  _DecisionScreenState createState() => _DecisionScreenState();
}

class _DecisionScreenState extends  State<DecisionScreen> {
  List<Prompt> promptsList = [];
  var rng = Random();

  getPrompts() async {
    List<Prompt> tempList = [];
    _promptsRef.onValue.listen((DatabaseEvent event) {
        var map = event.snapshot.value as List<dynamic>;
        for (var element in map) {
          final prompt = Prompt.fromJson(element);
          tempList.add(prompt);
          print('Prompt added: ${prompt.title}');
        }
        setState(() {
          promptsList = tempList;
        });
      });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    final database = FirebaseDatabase.instance;
    _promptsRef = database.ref('prompts');
    getPrompts();

    database.setLoggingEnabled(false);
  }

  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 5;
    final double itemWidth = size.width / 4;

    return Scaffold(
      body:Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              RichText(
                text: const TextSpan(
                  text: 'How are ',
                  style: TextStyle(fontSize: 42),
                  children:  [
                    TextSpan(text: 'you ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 42)),
                    TextSpan(text: 'feeling ', style: TextStyle(fontSize: 42)),
                    TextSpan(text: 'today?', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 42)),
                  ],
                ),
              )
            ],),
          ),
           Expanded(
             child: GridView.count(
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisCount: 2,
              children: <Widget>[
                buildCardWithIcon(
                  Icons.air_sharp,
                  context,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PromptScreen(prompt: promptsList[rng.nextInt(promptsList.length)]);
                        },
                      ),
                    );
                  },
                  "Angry",
                  Colors.red
                ),
                buildCardWithIcon(
                  Icons.supervisor_account,
                  context,
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return PromptScreen(prompt: promptsList[rng.nextInt(promptsList.length)]);
                    }));
                  },
                  "Anxious",
                  Colors.green
                ),
                buildCardWithIcon(
                  Icons.widgets,
                  context,
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return PromptScreen(prompt: promptsList[rng.nextInt(promptsList.length)]);
                    }));
                  },
                  "Depressed",
                  Colors.blueGrey
                ),
                buildCardWithIcon(
                  Icons.security,
                  context,
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return PromptScreen(prompt: promptsList[rng.nextInt(promptsList.length)]);
                    }));
                  },
                  "Guilty",
                  Colors.yellow
                )
              ],
                     ),
           ),
           Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Expanded(
                 child: Container(
                  color: Colors.lightGreen,
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
              Expanded(
                  child: Container(
                    color: Colors.white,
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
                Expanded(
                  child: Container(
                    color: Colors.lime,
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
                )
            ]),
           )
         ],
      ),
    );    
  }

  Padding buildCardWithIcon(
      IconData icon, context, VoidCallback onTap, String pageName, Color color) {
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
                Icon(
                  icon,
                  size: 70,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  pageName,
                  style: const TextStyle(
                    fontSize: 18,
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
}

