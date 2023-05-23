import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_flutter/Models/favorites_model.dart';
import 'package:ecommerce_app_flutter/Models/products_model.dart';
import 'package:ecommerce_app_flutter/constants/firestore_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  FavoritesController({required this.prefs, required this.firebaseFirestore, required this.firebaseAuth});

  Stream<QuerySnapshot> getProductsInCart() {
    return firebaseFirestore
        .collection(FirestoreConstants.pathFavoritesCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(firebaseAuth.currentUser!.uid)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .snapshots();
  }

  Future<void> addProductToFavorites(
      int productId, String productTitle, String productImageURL, double productPrice) async {
    FavoritesModel product = FavoritesModel(
        userId: firebaseAuth.currentUser!.uid,
        productId: productId,
        productImageURL: productImageURL,
        productPrice: productPrice,
        productTitle: productTitle,
        timestamp: DateTime.now().microsecondsSinceEpoch.toString());

    await firebaseFirestore
        .collection(FirestoreConstants.pathFavoritesCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(firebaseAuth.currentUser!.uid)
        .doc(productId.toString())
        .set(product.toJson());
  }

  Future<void> removeProductFromFavorites(int productId) async {
    await firebaseFirestore
        .collection(FirestoreConstants.pathFavoritesCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(firebaseAuth.currentUser!.uid)
        .doc(productId.toString())
        .delete();
  }

  Future<bool> isProductAlreadyInFavorites(int productId) async {
    DocumentSnapshot documentSnapshot = await firebaseFirestore
        .collection(FirestoreConstants.pathFavoritesCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(firebaseAuth.currentUser!.uid)
        .doc(productId.toString())
        .get();

    return documentSnapshot.exists;
  }
}
