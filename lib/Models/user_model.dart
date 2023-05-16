import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_flutter/constants/firestore_constants.dart';

class UserModel {
  final String id;
  final String photoURL;
  final String displayName;
  final String phoneNumber;
  final String aboutMe;

  const UserModel(
      {required this.id,
      required this.photoURL,
      required this.displayName,
      required this.phoneNumber,
      required this.aboutMe});

  UserModel copyWith({String? id, String? photoURL, String? nickName, String? phoneNumber, String? email}) => UserModel(
      id: id ?? this.id,
      photoURL: photoURL ?? this.photoURL,
      displayName: nickName ?? displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      aboutMe: email ?? aboutMe);

  Map<String, dynamic> toJson() => {
        FirestoreConstants.id: id,
        FirestoreConstants.displayName: displayName,
        FirestoreConstants.photoUrl: photoURL,
        FirestoreConstants.phoneNumber: phoneNumber,
        FirestoreConstants.aboutMe: aboutMe
      };

  factory UserModel.fromDocument(DocumentSnapshot snapshot) {
    String id = "";
    String photoURL = "";
    String phoneNumber = "";
    String nickname = "";
    String aboutMe = "";

    try {
      id = snapshot.data().toString().contains(FirestoreConstants.id) ? snapshot.get(FirestoreConstants.id) ?? "" : "";
      photoURL = snapshot.data().toString().contains(FirestoreConstants.photoUrl)
          ? snapshot.get(FirestoreConstants.photoUrl) ?? ""
          : "";
      nickname = snapshot.data().toString().contains(FirestoreConstants.displayName)
          ? snapshot.get(FirestoreConstants.displayName) ?? ""
          : "";
      phoneNumber = snapshot.data().toString().contains(FirestoreConstants.phoneNumber)
          ? snapshot.get(FirestoreConstants.phoneNumber) ?? 0
          : 0;
      aboutMe = snapshot.data().toString().contains(FirestoreConstants.aboutMe)
          ? snapshot.get(FirestoreConstants.aboutMe) ?? ""
          : "";
    } catch (e) {
      print(e);
    }
    return UserModel(id: id, photoURL: photoURL, displayName: nickname, phoneNumber: phoneNumber, aboutMe: aboutMe);
    }
}
