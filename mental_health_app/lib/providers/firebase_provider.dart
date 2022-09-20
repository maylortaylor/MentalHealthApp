// import 'package:flutter/material.dart';
// import 'package:mental_health_app/caches/sharedpref/shared_preference_helper.dart';
// import 'package:mental_health_app/services/firestore_database.dart';

// class FirebaseProvider extends ChangeNotifier {
//   // shared pref object
//   late SharedPreferenceHelper _sharedPrefsHelper;
//   var _firestoreDatabase;
//   bool _isDarkModeOn = false;

//   FirebaseProvider() {
//     _sharedPrefsHelper = SharedPreferenceHelper();
//     // _firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
//   }

//   // bool get isDarkModeOn {
//   //   _sharedPrefsHelper.isDarkMode.then((statusValue) {
//   //     _isDarkModeOn = statusValue;
//   //   });

//   //   return _isDarkModeOn;
//   // }

//   // void updateTheme(bool isDarkModeOn) {
//   //   _sharedPrefsHelper.changeTheme(isDarkModeOn);
//   //   _sharedPrefsHelper.isDarkMode.then((darkModeStatus) {
//   //     _isDarkModeOn = darkModeStatus;
//   //   });

//   //   notifyListeners();
//   // }
// }