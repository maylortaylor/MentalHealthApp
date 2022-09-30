import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mental_health_app/models/user_model.dart';
import 'package:mental_health_app/services/firestore_database.dart';
import 'package:mental_health_app/services/firestore_service.dart';
import 'package:provider/provider.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Registering
}
/*
The UI will depends on the Status to decide which screen/action to be done.
- Uninitialized - Checking user is logged or not, the Splash Screen will be shown
- Authenticated - User is authenticated successfully, Home Page will be shown
- Authenticating - Sign In button just been pressed, progress bar will be shown
- Unauthenticated - User is not authenticated, login page will be shown
- Registering - User just pressed registering, progress bar will be shown
Take note, this is just an idea. You can remove or further add more different
status for your UI or widgets to listen.
 */

class AuthProvider extends ChangeNotifier {
  //Firebase Auth object
  late FirebaseAuth _auth;
  late FirestoreService _firestoreService;
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  //Default status
  Status _status = Status.Uninitialized;

  Status get status => _status;

  Stream<UserModel> get user => _auth.authStateChanges().map(_userFromFirebase);

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _firestoreService = FirestoreService.instance;
    //listener for authentication changes such as user sign in and sign out
    _auth.authStateChanges().listen(onAuthStateChanged);
  }

  Future _populateCurrentUser(User? user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUserModel(user.uid);
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = _auth.currentUser;
    return user != null;
  }

  //Create user object based on the given User
  UserModel _userFromFirebase(User? user) {
    if (user == null) {
      print("NO USER");
      return UserModel(displayName: null, uid: '');
    }

    return UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL
      );
  }

  //Method to detect live auth changes such as user sign in and sign out
  Future<void> onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
      print("auth state changed: Unauthenticated");
    } else {
      _userFromFirebase(firebaseUser);
      await _populateCurrentUser(firebaseUser);
      _status = Status.Authenticated;
      print("auth state changed: Authenticated");
    }
    notifyListeners();
  }

  //Method for new user registration using email and password
  Future<UserModel> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      _status = Status.Registering;
      notifyListeners();

      // create user in Firebase Authentication
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // add user to Firestore Realtime DB
      await _firestoreService.set(
        path:'users/${result.user!.uid}',
        data: UserModel(
          uid: result.user!.uid,
          email: result.user!.email,
          displayName: result.user!.displayName,
          phoneNumber: result.user!.phoneNumber,
          photoUrl: result.user!.photoURL,
          dateCreated: DateTime.now().toIso8601String(),
          isSubscribed: false,
          pathsAllowed: ['anger', 'anxiety', 'depression', 'guilt']
        ).toMap()
      );

      print(email);
      print(password);
      print("Register With Email and Password");

      return _userFromFirebase(result.user);
    } catch (e) {
      print("Error on the new user registration = " + e.toString());
      _status = Status.Unauthenticated;
      notifyListeners();
      return UserModel(displayName: 'Null', uid: 'null');
    }
  }

  //Method to handle user sign in using email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      // _firestoreService.getUser(result.user!.uid).listen((event) {
      //   _auth.currentUser = event;
      // },);

      await _populateCurrentUser(result.user);
      print('$email : $password');
      print("Sign In With Email And Password");
      return true;
    } catch (e) {
      print("Error on the sign in = " + e.toString());
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  //Method to handle password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    print("Send Password Reset Email");
    await _auth.sendPasswordResetEmail(email: email);
  }

  //Method to handle user signing out
  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    print("Signed Out");
    return Future.delayed(Duration.zero);
  }
}