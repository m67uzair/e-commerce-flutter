import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_flutter/constants/firestore_constants.dart';

class FavoritesModel {
  String userId;
  int productId;
  String productImageURL;
  double productPrice;
  String productTitle;
  String timestamp;

  FavoritesModel(
      {required this.userId,
      required this.productId,
      required this.productImageURL,
      required this.productPrice,
      required this.productTitle,
      required this.timestamp});

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.userId: userId,
      FirestoreConstants.productId: productId,
      FirestoreConstants.productTitle: productTitle,
      FirestoreConstants.productPrice: productPrice,
      FirestoreConstants.productImageURL: productImageURL,
      FirestoreConstants.timestamp: timestamp,
    };
  }

  factory FavoritesModel.fromDocument(DocumentSnapshot documentSnapshot) {
    String userId = documentSnapshot.data().toString().contains(FirestoreConstants.userId)
        ? documentSnapshot.get(FirestoreConstants.userId)
        : "";
    int productId = documentSnapshot.data().toString().contains(FirestoreConstants.productId)
        ? documentSnapshot.get(FirestoreConstants.productId)
        : 0;
    String productTitle = documentSnapshot.data().toString().contains(FirestoreConstants.productTitle)
        ? documentSnapshot.get(FirestoreConstants.productTitle)
        : "";
    double productPrice = documentSnapshot.data().toString().contains(FirestoreConstants.productPrice)
        ? documentSnapshot.get(FirestoreConstants.productPrice)
        : 0.0;
    String productImageURL = documentSnapshot.data().toString().contains(FirestoreConstants.productImageURL)
        ? documentSnapshot.get(FirestoreConstants.productImageURL)
        : "";
    String timestamp = documentSnapshot.data().toString().contains(FirestoreConstants.timestamp)
        ? documentSnapshot.get(FirestoreConstants.timestamp)
        : "";

    return FavoritesModel(
        userId: userId,
        productId: productId,
        productImageURL: productImageURL,
        productPrice: productPrice,
        productTitle: productTitle,
        timestamp: timestamp);
  }
}
