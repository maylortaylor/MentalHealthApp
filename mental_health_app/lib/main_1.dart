// import 'dart:async';
// import 'dart:collection';

// import 'package:card_swiper/card_swiper.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:mental_health_app/screens/decision.screen.dart';
// import 'screens/prompt.screen.dart';

// import 'firebase_options.dart';
// import 'models/prompts_model.dart';

// // Change to false to use live database instance.
// const USE_DATABASE_EMULATOR = false;
// // The port we've set the Firebase Database emulator to run on via the
// // `firebase.json` configuration file.
// const emulatorPort = 9000;
// // Android device emulators consider localhost of the host machine as 10.0.2.2
// // so let's use that if running on Android.
// final emulatorHost =
//     (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
//         ? '10.0.2.2'
//         : 'localhost';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   if (USE_DATABASE_EMULATOR) {
//     FirebaseDatabase.instance.useDatabaseEmulator(emulatorHost, emulatorPort);
//   }

//   runApp(
//     const MaterialApp(
//       title: 'Flutter Database Example',
//       home: MyHomePage(),
//     ),
//   );
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   List<Prompt> promptsList = [];
//   late DatabaseReference _promptsRef;
//   bool _anchorToBottom = false;
//       // Query promptsSnapshot = FirebaseDatabase.instance
//       // .ref()
//       // .child("needs-posts")
//       // .orderByKey();
//   String _kTestKey = 'Hello';
//   String _kTestValue = 'world!';
//   FirebaseException? _error;
//   bool initialized = false;

//   @override
//   void initState() {
//     init();
//     super.initState();
//   }

//   Future<void> init() async {
//     final database = FirebaseDatabase.instance;
//     _promptsRef = database.ref('prompts');
//     getPrompts();

//     database.setLoggingEnabled(false);

//     if (!kIsWeb) {
//       database.setPersistenceEnabled(true);
//       database.setPersistenceCacheSizeBytes(10000000);
//     }

//     setState(() {
//       initialized = true;
//     });

//     final messagesQuery = _promptsRef.limitToLast(10);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future<void> _deleteMessage(DataSnapshot snapshot) async {
//     // final promptsRef = _promptsRef.child(snapshot.key!);
//     // await promptsRef.remove();
//   }
    
//   getPrompts() async {
//     List<Prompt> tempList = [];

//     _promptsRef.onValue.listen((DatabaseEvent event) {
//         var map = event.snapshot.value as List<dynamic>;
//         for (var element in map) {
//           // final prompt = Prompt.fromJson(element);
//           // tempList.add(prompt);
//           // print('Prompt added: ${prompt.title}');
//         }
//         setState(() {
//           promptsList = tempList;
//         });
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!initialized) return Container();

//     return Scaffold(
//       body: DecisionScreen()
//     );
//   }
// }