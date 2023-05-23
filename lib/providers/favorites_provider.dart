import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier{
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  FavoritesProvider({required this.prefs, required this.firebaseFirestore, required this.firebaseAuth});



}