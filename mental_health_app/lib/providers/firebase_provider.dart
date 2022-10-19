import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/caches/sharedpref/shared_preference_helper.dart';
import 'package:mental_health_app/models/prompts_model.dart';
import 'package:mental_health_app/services/firestore_database.dart';
import 'package:mental_health_app/services/firestore_service.dart';
import 'package:provider/provider.dart';

class FirebaseProvider extends ChangeNotifier {
  FirebaseProvider._();
  static final instance = FirebaseProvider._();

  // Stream<List<Prompt>> streamWeapons() {
  //   var ref = FirebaseFirestore.instance.collection('prompts');

  //   return ref.snapshots().map((list) =>
  //       list.documents.map((doc) => Prompt.fromMap(doc)).toList());
    
  // }
  // shared pref object
  // late SharedPreferenceHelper _sharedPrefsHelper;
  // var _firestoreDatabase;
  // bool _isDarkModeOn = false;

  // FirebaseProvider() {
  //   _sharedPrefsHelper = SharedPreferenceHelper();
  //   // _firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
  // }

  // bool get isDarkModeOn {
  //   _sharedPrefsHelper.isDarkMode.then((statusValue) {
  //     _isDarkModeOn = statusValue;
  //   });

  //   return _isDarkModeOn;
  // }

  // void updateTheme(bool isDarkModeOn) {
  //   _sharedPrefsHelper.changeTheme(isDarkModeOn);
  //   _sharedPrefsHelper.isDarkMode.then((darkModeStatus) {
  //     _isDarkModeOn = darkModeStatus;
  //   });

  //   notifyListeners();
  // }
}