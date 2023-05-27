import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_flutter/Models/cart_model.dart';
import 'package:ecommerce_app_flutter/constants/firestore_constants.dart';
import 'package:ecommerce_app_flutter/views/my_cart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends ChangeNotifier {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  double _cartTotalPrice = 0.0;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  CartController({required this.prefs, required this.firebaseFirestore, required this.firebaseAuth});

  double get cartTotalPrice => _cartTotalPrice;

  Future<double> getCartTotalPrice() async {
    // _isLoading = true;
    // notifyListeners();
    DocumentSnapshot<Map<String, dynamic>> snapshot = await firebaseFirestore
        .collection(FirestoreConstants.pathCartCollection)
        .doc(authProvider.loggedInUserId)
        .get();

    _cartTotalPrice = snapshot.exists ? snapshot.data()![FirestoreConstants.cartTotalPrice] : 0.0;
    // _isLoading = false;
    notifyListeners();
    return _cartTotalPrice;
  }

  Future<void> setCartTotalPrice(double productPrice) async {
    _cartTotalPrice += productPrice;

    // print("total price: ${_cartTotalPrice}added priice$productPrice");

    await prefs.setDouble(FirestoreConstants.cartTotalPrice, double.parse(_cartTotalPrice.toStringAsFixed(2)));
    notifyListeners();

    await firebaseFirestore.collection(FirestoreConstants.pathCartCollection).doc(firebaseAuth.currentUser!.uid).set(
        {FirestoreConstants.cartTotalPrice: double.parse(_cartTotalPrice.toStringAsFixed(2))}, SetOptions(merge: true));
  }

  Future<void> addProductToCart(
      String userId, int productId, String productTitle, String productImageURL, double productPrice) async {
    CartModel product = CartModel(
      userId: userId,
      productId: productId,
      count: 1,
      productImageURL: productImageURL,
      productPrice: double.parse(productPrice.toStringAsFixed(2)),
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
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
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
          .update({
        FirestoreConstants.count: count,
        FirestoreConstants.productPrice: double.parse(price.toStringAsFixed(2))
      });
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      // print("pado");
      _isLoading = false;
      notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
  }
}
