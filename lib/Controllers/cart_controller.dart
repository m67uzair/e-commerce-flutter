import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_flutter/Models/cart_model.dart';
import 'package:ecommerce_app_flutter/constants/firestore_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends ChangeNotifier {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;

  CartController({required this.prefs, required this.firebaseFirestore});

  Future<void> addProductToCart(
      String userId, int productId, String productTitle, String productImageURL, double productPrice) async {
    CartModel product = CartModel(
      userId: userId,
      productId: productId,
      count: 1,
      productImageURL: productImageURL,
      productPrice: productPrice,
      productTitle: productTitle,
      timestamp: DateTime.now().microsecondsSinceEpoch.toString(),
    );

    await firebaseFirestore
        .collection(FirestoreConstants.pathCartCollection)
        .doc(userId)
        .collection(userId)
        .doc(productId.toString())
        .set(product.toJson());
  }

  Stream<QuerySnapshot> getProductsInCart(String userId, int limit) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathCartCollection)
        .doc(userId)
        .collection(userId)
        .orderBy(FirestoreConstants.timestamp)
        .limit(limit)
        .snapshots();
  }
}
