import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/app_localizations.dart';
import 'package:mental_health_app/auth_widget_builder.dart';
import 'package:mental_health_app/config/Application.dart';
import 'package:mental_health_app/constants/app_themes.dart';
import 'package:mental_health_app/flavor.dart';
import 'package:mental_health_app/locator.dart';
import 'package:mental_health_app/models/user_model.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/providers/language_provider.dart';
import 'package:mental_health_app/providers/theme_provider.dart';
import 'package:mental_health_app/routes.dart';
import 'package:mental_health_app/screens/decision.screen.dart';
import 'package:mental_health_app/screens/prompt.screen.dart';
import 'package:mental_health_app/services/firestore_database.dart';
import 'package:mental_health_app/services/navigation_service.dart';
import 'package:mental_health_app/ui/auth/sign_in_screen.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

class AppComponent extends StatefulWidget {
  const AppComponent({required Key key, required this.databaseBuilder})
      : super(key: key);


  // Expose builders for 3rd party services at the root of the widget tree
  // This is useful when mocking services while testing
  final FirestoreDatabase Function(BuildContext context, String uid)
      databaseBuilder;

  @override
  State<AppComponent> createState() {
    return _AppComponentState();
  }
}

class _AppComponentState extends State<AppComponent> {
  _AppComponentState() {
    final router = FluroRouter();
    AppRoutes.configureRoutes(router);
    Application.router = router;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, themeProviderRef, __) {
        //{context, data, child}
            return AuthWidgetBuilder(
              databaseBuilder: widget.databaseBuilder,
              builder: (BuildContext context,
                  AsyncSnapshot<UserModel> userSnapshot) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  // // locale: languageProviderRef.appLocale,
                  // //List of all supported locales
                  // supportedLocales: [
                  //   Locale('en', 'US'),
                  //   // Locale('zh', 'CN'),
                  // ],
                  // //These delegates make sure that the localization data for the proper language is loaded
                  // localizationsDelegates: [
                  //   //A class which loads the translations from JSON files
                  //   AppLocalizations.delegate,
                  //   // //Built-in localization of basic text for Material widgets (means those default Material widget such as alert dialog icon text)
                  //   // GlobalMaterialLocalizations.delegate,
                  //   // //Built-in localization for text direction LTR/RTL
                  //   // GlobalWidgetsLocalizations.delegate,
                  // ],
                  // //return a locale which will be used by the app
                  // localeResolutionCallback: (locale, supportedLocales) {
                  //   //check if the current device locale is supported or not
                  //   for (var supportedLocale in supportedLocales) {
                  //     if (supportedLocale.languageCode ==
                  //             locale?.languageCode ||
                  //         supportedLocale.countryCode == locale?.countryCode) {
                  //       return supportedLocale;
                  //     }
                  //   }
                  //   //if the locale from the mobile device is not supported yet,
                  //   //user the first one from the list (in our case, that will be English)
                  //   return supportedLocales.first;
                  // },
                  title: Provider.of<Flavor>(context).toString(),
                  // onGenerateRoute: Application.router.generator,
                  theme: AppThemes.lightTheme,
                  // darkTheme: AppThemes.darkTheme,
                  // themeMode: themeProviderRef.isDarkModeOn
                  //     ? ThemeMode.light
                  //     : ThemeMode.light,
                  home: Consumer<AuthProvider>(
                    builder: (_, authProviderRef, __) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.active) {
                        return userSnapshot.hasData
                            ? Navigator(
                                key: locator<NavigationService>().navigatorKey,
                                onGenerateRoute: Application.router.generator,
                                // initialRoute: '/'
                              )
                          //  ? DecisionScreen()
                            : SignInScreen();
                      }
                
                      return Material();
                    },
                  ),
                );
              },
              key: Key('AuthWidget'),
            );
      },
    );
  }
}