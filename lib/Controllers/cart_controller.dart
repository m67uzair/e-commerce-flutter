import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_flutter/Models/cart_model.dart';
import 'package:ecommerce_app_flutter/constants/firestore_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends ChangeNotifier {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  double _cartTotalPrice = 0.0;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  CartController({required this.prefs, required this.firebaseFirestore});

  double get cartTotalPrice => _cartTotalPrice;

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

    try {
      await firebaseFirestore
          .collection(FirestoreConstants.pathCartCollection)
          .doc(userId)
          .collection(userId)
          .doc(productId.toString())
          .set(product.toJson());

      _cartTotalPrice += productPrice;

      await firebaseFirestore
          .collection(FirestoreConstants.pathCartCollection)
          .doc(userId)
          .set({FirestoreConstants.cartTotalPrice: cartTotalPrice}, SetOptions(merge: true));
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    notifyListeners();
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

  Future<bool> isProductAlreadyInCart(int productId, String userId) async {
    final DocumentSnapshot documentSnapshot = await firebaseFirestore
        .collection(FirestoreConstants.pathCartCollection)
        .doc(userId)
        .collection(userId)
        .doc(productId.toString())
        .get();

    return documentSnapshot.exists;
  }

  Future<void> updateCartProductCountAndPrice(String userId, int productId, int count, double price) async {
    try {
      _isLoading = true;
      notifyListeners();

      await firebaseFirestore
          .collection(FirestoreConstants.pathCartCollection)
          .doc(userId)
          .collection(userId)
          .doc(productId.toString())
          .update({FirestoreConstants.count: count, FirestoreConstants.productPrice: price});
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateCartTotalPrice(String userId, double priceAddition) async {
    _cartTotalPrice += priceAddition;
    await firebaseFirestore
        .collection(FirestoreConstants.pathCartCollection)
        .doc(userId)
        .update({FirestoreConstants.cartTotalPrice: cartTotalPrice});
  }
}
