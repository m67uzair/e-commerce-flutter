import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_flutter/Models/favorites_model.dart';
import 'package:ecommerce_app_flutter/constants/firestore_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController extends ChangeNotifier {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  // List _favoritesList = [];

  FavoritesController({required this.prefs, required this.firebaseFirestore, required this.firebaseAuth});

  Stream<QuerySnapshot> getProductsInCart() {
    Stream<QuerySnapshot<Map<String, dynamic>>> favoritesStream = firebaseFirestore
        .collection(FirestoreConstants.pathFavoritesCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(firebaseAuth.currentUser!.uid)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .snapshots();

    // favoritesStream.listen((QuerySnapshot snapshot) {
    //   for (DocumentSnapshot documentSnapshot in snapshot.docs) {
    //     FavoritesModel favoriteProduct = FavoritesModel.fromDocument(documentSnapshot);
    //
    //     _favoritesList.add(favoriteProduct);
    //   }
    // });

    return favoritesStream;
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

    // _favoritesList.add(product);
    // notifyListeners();

    await firebaseFirestore
        .collection(FirestoreConstants.pathFavoritesCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(firebaseAuth.currentUser!.uid)
        .doc(productId.toString())
        .set(product.toJson());

    notifyListeners();
  }

  Future<void> removeProductFromFavorites(int productId) async {
    await firebaseFirestore
        .collection(FirestoreConstants.pathFavoritesCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(firebaseAuth.currentUser!.uid)
        .doc(productId.toString())
        .delete();

    notifyListeners();
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
