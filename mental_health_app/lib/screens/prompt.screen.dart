import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../main_2.dart';
import '../models/prompts_model.dart';
import '../widgets/colored_card.dart';

class Constants {
  static const String Subscribe = 'Go Home Page';
  static const String Settings = 'Go Another Page';
  static const String SignOut = 'Refresh Page';

  static const List<String> choices = <String>[Subscribe, Settings, SignOut];
}
//   void choiceAction(String choice) {
//     if (choice == Constants.Settings) {
//       _scaffoldKey.currentState.showSnackBar(SnackBar(
//         content: Text(
//           Constants.Settings,
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//       ));
//     } else if (choice == Constants.Subscribe) {
//       _scaffoldKey.currentState.showSnackBar(SnackBar(
//         content: Text(
//           Constants.Subscribe,
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//       ));
//     } else if (choice == Constants.SignOut) {
//       _scaffoldKey.currentState.showSnackBar(SnackBar(
//         duration: Duration(milliseconds: 200),
//         content: Text(
//           Constants.SignOut,
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//       ));
//     }
//   }
// }

late DatabaseReference _promptsRef;

class PromptScreen extends StatefulWidget {
  // const PromptScreen({Key? key}) : super(key: key);
  const PromptScreen({super.key, required this.category});
  final String category;

  @override
  _PromptScreenState createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  List<Prompt> promptsList = [];
  
  getPrompts() async {
    List<Prompt> tempList = [];
    _promptsRef.onValue.listen((DatabaseEvent event) {
        var map = event.snapshot.value as List<dynamic>;
        for (var element in map) {
          // final prompt = Prompt.fromMap(element);
          // tempList.add(prompt);
          // print('Prompt added: ${prompt.title}');
        }
        setState(() {
          promptsList = tempList;
        });
      });
  }
  
  Future<void> init() async {
    final database = FirebaseDatabase.instance;
    _promptsRef = database.ref(widget.category);
    getPrompts();

    database.setLoggingEnabled(false);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("TITLE"),
      ),
      body: ListView(
        children: [
          ColoredCard(
            key: _scaffoldKey,
            bodyContent: Text("BODY"),
            headerColor: Color(0xFF6078dc),
            footerColor: Color(0xFF6078dc),
            cardHeight: 250,
            elevation: 4,
            bodyColor: Color(0xFF6c8df6),
            showFooter: true,
            showHeader: true,
            bodyGradient: LinearGradient(
              colors: [
                Color(0xFF55affd).withOpacity(1),
                Color(0xFF6b8df8),
                Color(0xFF887ef1),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0, 0.2, 1],
            ),
            headerBar: HeaderBar(
                gradient:  LinearGradient(
              colors: [
                Color(0xFF55affd).withOpacity(1),
                Color(0xFF6b8df8),
                Color(0xFF887ef1),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0, 0.2, 1],
            ),
                borderRadius: 7,
                padding: 7,
                backgroundColor: Colors.black,
                title: const Text(
                  "Header Text",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: "Poppins"),
                ),
                leading: Text('Step # XX'),
                // leading: IconButton(
                //   icon: const Icon(
                //     Icons.refresh,
                //     color: Colors.white,
                //   ),
                //   onPressed: () {
                //     Scaffold.of(context).showSnackBar(SnackBar(
                //       content: Text('Hello!'),
                //     ));
                //   },
                // ),
                action: PopupMenuButton<String>(
                  icon: Icon(Icons.menu),
                  // onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return Constants.choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                )),
                footerBar: FooterBar(
                          title: Text('footer title'),
                          action: Text('action'),
                          centerMiddle: true,
                          backgroundColor: Colors.deepPurple,
                          leading: Text('leading'),
                          borderRadius: 7,
                          padding: 7, 
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF55affd).withOpacity(1),
                              Color(0xFF6b8df8),
                              Color(0xFF887ef1),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [0, 0.2, 1],
                          ),
                        ),
                        bottomContent: Text('bottom content'),),
          Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyHomePage()));
            },
            child: const Text('Go back!'),
          ),
        )],
      ),
    );
  }
}