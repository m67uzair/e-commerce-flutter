import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/firestore_constants.dart';

class ProfileProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  String _userId = "";
  String _photoURL = "";
  String _displayName = "";
  String _phoneNumber = "";
  String _email = "";

  File? avatarImageFile;
  bool _isLoading = false;

  ProfileProvider({required this.prefs, required this.firebaseAuth, required this.firebaseStorage});

  String get userId => _userId;

  String get email => _email;

  String get displayName => _displayName;

  String get phoneNumber => _phoneNumber;

  String get photoURL => _photoURL;

  bool get isLoading => _isLoading;

  void readLocal() {
    _userId = prefs.getString(FirestoreConstants.userId) ?? "";
    _email = prefs.getString(FirestoreConstants.email) ?? "";
    _displayName = prefs.getString(FirestoreConstants.displayName) ?? "";
    _phoneNumber = prefs.getString(FirestoreConstants.phoneNumber)==null ? "" : "3332525537";
    _photoURL = firebaseAuth.currentUser!.photoURL ?? "";
    // notifyListeners();
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery).catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString());
      return null;
    });

    File? image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      avatarImageFile = image;
      _isLoading = true;
      notifyListeners();

      await uploadImageFile();
    }
  }

  Future<void> uploadImageFile() async {
    String fileName = firebaseAuth.currentUser!.uid;

    try {
      Reference reference = firebaseStorage.ref().child(fileName);
      TaskSnapshot uploadTask = await reference.putFile(avatarImageFile!);

      _photoURL = await uploadTask.ref.getDownloadURL();

      await prefs.setString(FirestoreConstants.photoUrl, photoURL);
      await firebaseAuth.currentUser!.updatePhotoURL(photoURL);
    } on FirebaseException catch (e) {
      _isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }

    _isLoading = false;
    notifyListeners();
    Fluttertoast.showToast(msg: "Profile photo updated ");
  }

  Future<void> updateDisplayName(String displayName) async {
    _isLoading = true;
    notifyListeners();

    try {
      await prefs.setString(FirestoreConstants.displayName, displayName);
      await firebaseAuth.currentUser!.updateDisplayName(displayName);
    } on FirebaseException catch (e) {
      _isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }

    _isLoading = false;
    notifyListeners();
    Fluttertoast.showToast(msg: "Display name updated");
  }
}
