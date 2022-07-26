import 'dart:async';
import 'dart:collection';

import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import './screens/prompt.screen..dart';

import 'firebase_options.dart';
import 'models/prompts.model.dart';

// Change to false to use live database instance.
const USE_DATABASE_EMULATOR = false;
// The port we've set the Firebase Database emulator to run on via the
// `firebase.json` configuration file.
const emulatorPort = 9000;
// Android device emulators consider localhost of the host machine as 10.0.2.2
// so let's use that if running on Android.
final emulatorHost =
    (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
        ? '10.0.2.2'
        : 'localhost';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (USE_DATABASE_EMULATOR) {
    FirebaseDatabase.instance.useDatabaseEmulator(emulatorHost, emulatorPort);
  }

  runApp(
    const MaterialApp(
      title: 'Flutter Database Example',
      home: MyHomePage(),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Prompt> promptsList = [];
  late DatabaseReference _promptsRef;
  bool _anchorToBottom = false;
      // Query promptsSnapshot = FirebaseDatabase.instance
      // .ref()
      // .child("needs-posts")
      // .orderByKey();
  String _kTestKey = 'Hello';
  String _kTestValue = 'world!';
  FirebaseException? _error;
  bool initialized = false;

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

    if (!kIsWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }

    setState(() {
      initialized = true;
    });

    final messagesQuery = _promptsRef.limitToLast(10);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _deleteMessage(DataSnapshot snapshot) async {
    // final promptsRef = _promptsRef.child(snapshot.key!);
    // await promptsRef.remove();
  }
    
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
  Widget build(BuildContext context) {
    if (!initialized) return Container();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health App'),
      ),
      body: Column(
        children: [
          Flexible(
            child: Center(
              child: Swiper(
                itemBuilder: (BuildContext context,int index){
                  // return Image.network("https://via.placeholder.com/350x150",fit: BoxFit.fill,);
                  return _buildPrompt(context, index);
                },
                itemCount: promptsList.length,
                pagination: SwiperPagination(),
                control: SwiperControl(),
              ))
              // child: StreamBuilder(
              //   stream: _promptsRef.onValue,
              //   builder: (context, index) {
              //     return ListView.separated(
              //     itemBuilder: (context, index) {
              //       return _buildPrompt(context, index);
              //     },
              //    separatorBuilder: (context, index) => const Divider(color: Colors.black),
              //    itemCount: promptsList.length);
              //   } 
              // ),)
          ),
        ],
      )
    );
  }

  Widget _buildPrompt(BuildContext context, int index) {
    // return ListTile(
    //         contentPadding: EdgeInsets.all(5),
    //         dense: true,
    //         onTap: () async {
    //           Navigator.of(context).push(MaterialPageRoute(builder: (context) => PromptScreen(prompt: promptsList[index])));

    //           // if (await canLaunch(e.url)) {
    //           //   await launch(e.url);
    //           // } else {
    //           //   throw 'Could not launch ${e.url}';
    //           // }
    //         },
    //         // leading: e.image,
    //         title: Text(
    //           promptsList[index].title,
    //           style: TextStyle(fontSize: 20),
    //         ),
    // );

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top:35, left: 35, right: 35),
        child: Column(
          children: [
          Expanded(child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Expanded(
                child: Container(
                  color: Colors.lightBlue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PromptScreen(prompt: promptsList[index])));
                          },
                          child: Text(
                            promptsList[index].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),),
                        ),
                  ],),
                )
              ),
              Expanded(
                child: Container(
                  color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(promptsList[index].body,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w100,
                        color: Colors.black,
                      ),)
                  ],),
                )
              ),
     
        ]),
          )]
      )));
  }
}