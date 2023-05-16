import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app_flutter/constants/firestore_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum Status { uninitialized, authenticated, authenticating, authenticateError, authenticateCanceled }

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final SharedPreferences prefs;
  User? firebaseUser;

  Status _status = Status.uninitialized;
  bool signInActivityDone = false;

  Status get status => _status;

  AuthProvider({required this.googleSignIn, required this.firebaseAuth, required this.prefs});

  String? getFirebaseUserId() => prefs.getString(FirestoreConstants.id);

  Future<bool> isLoggedIn() async {
    if (firebaseUser != null && prefs.getString(FirestoreConstants.id)!.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> signUpWithEmailAndPassword(
      {required String email,
      required String password,
      required String displayName,
      required String phoneNumber}) async {
    try {
      _status = Status.authenticating;
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      firebaseUser = firebaseAuth.currentUser;

      await firebaseUser!.updateDisplayName(displayName);

      await prefs.setString(FirestoreConstants.id, firebaseUser!.uid);
      await prefs.setString(FirestoreConstants.displayName, displayName);
      await prefs.setString(FirestoreConstants.phoneNumber, phoneNumber ?? "");
      await prefs.setString(FirestoreConstants.email, email);

      _status = Status.authenticated;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? e.toString(), backgroundColor: Colors.grey[900]);

      _status = Status.authenticateError;
    }
    notifyListeners();
  }

  Future<void> loginWithEmailAndPassword({required String email, required String password}) async {
    try {
      _status = Status.authenticating;
      notifyListeners();

      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      firebaseUser = firebaseAuth.currentUser;

      await prefs.setString(FirestoreConstants.id, firebaseUser!.uid);
      await prefs.setString(FirestoreConstants.displayName, firebaseUser!.displayName.toString());
      await prefs.setString(FirestoreConstants.phoneNumber, firebaseUser!.phoneNumber.toString() ?? "");
      await prefs.setString(FirestoreConstants.email, firebaseUser!.email.toString());

      _status = Status.authenticated;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? e.toString(), backgroundColor: Colors.grey[900]);
      _status = Status.authenticateError;
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _status = Status.authenticating;
    notifyListeners();

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final AuthCredential credential =
          GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        await prefs.setString(FirestoreConstants.id, firebaseUser!.uid);
        await prefs.setString(FirestoreConstants.displayName, firebaseUser!.displayName.toString());
        await prefs.setString(FirestoreConstants.photoUrl, firebaseUser!.photoURL.toString() ?? "");
        await prefs.setString(FirestoreConstants.phoneNumber, firebaseUser!.phoneNumber.toString() ?? "");
        await prefs.setString(FirestoreConstants.email, firebaseUser!.email.toString());

        _status = Status.authenticated;
        notifyListeners();
        // return true;
      } else {
        //firebaseUser if condition ends and else starts
        _status = Status.authenticateError;
        notifyListeners();
        // return false;
      }
    } else {
      // google user if condition ends and else starts
      _status = Status.authenticateCanceled;
      notifyListeners();
      // return false;
    }
  }

  Future<void> signOut() async {
    _status = Status.uninitialized;
    await firebaseAuth.signOut();

    if (googleSignIn.currentUser != null) {
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
    }
  }
}
