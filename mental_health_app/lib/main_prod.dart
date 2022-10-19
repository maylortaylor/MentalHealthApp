import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mental_health_app/app_component.dart';
import 'package:mental_health_app/flavor.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/providers/language_provider.dart';
import 'package:mental_health_app/providers/theme_provider.dart';
import 'package:mental_health_app/services/firestore_database.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    runApp(
      /*
      * MultiProvider for top services that do not depends on any runtime values
      * such as user uid/email.
       */
      MultiProvider(
        providers: [
          Provider<Flavor>.value(value: Flavor.prod),
          ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(),
          ),
          ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider(),
          ),
          ChangeNotifierProvider<LanguageProvider>(
            create: (context) => LanguageProvider(),
          ),
        ],
        child: AppComponent(
          // databaseBuilder: (_, uid) => FirestoreDatabase(uid: uid),
          key: Key('SimpleFinance'),
        ),
      ),
    );
  });
}