import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mental_health_app/flavor.dart';
import 'package:mental_health_app/locator.dart';
import 'package:mental_health_app/app_component.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/providers/language_provider.dart';
import 'package:mental_health_app/providers/theme_provider.dart';
import 'package:mental_health_app/services/firestore_database.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firebase_options.dart';

Future<void> main() async {
  setupLocator();
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    runApp(
      /*
      * MultiProvider for top services that do not depends on any runtime values
      * such as user uid/email.
       */
      MultiProvider(
        providers: [
          Provider<Flavor>.value(value: Flavor.dev),
          ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(),
          ),
          ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider(),
          ),
          // ChangeNotifierProvider<LanguageProvider>(
          //   create: (context) => LanguageProvider(),
          // ),
          Provider<FirestoreDatabase>(
                create: (context) => FirestoreDatabase(),
          ),
        ],
        child: AppComponent(
          // databaseBuilder: (_, uid) => FirestoreDatabase(uid: uid),
          key: Key('MyApp'),
        ),
      ),
    );
  });
}