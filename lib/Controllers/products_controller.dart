import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Models/products_model.dart';
import 'package:http/http.dart' as http;

class ProductsController extends ChangeNotifier {
  bool _isLoading = false;
  List<ProductsModel> mensProductsList = [];
  List<ProductsModel> womensProductsList = [];
  List<ProductsModel> electronicsProductsList = [];
  List<ProductsModel> jeweleryProductsList = [];
  List<ProductsModel> _allProducts = [];
  List<ProductsModel> _productsInCategory = [];

  bool get isLoading => _isLoading;

  List<ProductsModel> get productsInCategory => _productsInCategory;

  Future<List<ProductsModel>> fetchAllProducts() async {
    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse("https://fakestoreapi.com/products"));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map i in data) {
        _allProducts.add(ProductsModel.fromJson(i));
      }
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: "Error Code: ${response.statusCode}");
      return [];
    }
    return _allProducts;
  }

  Future<List<ProductsModel>> getProductsInCategory(String category) async {


    final response = await http.get(Uri.parse("https://fakestoreapi.com/products/category/$category"));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      for (Map i in data) {
        _productsInCategory.add(ProductsModel.fromJson(i));
      }

    } else {

      return [];
      Fluttertoast.showToast(msg: "Error Code: ${response.statusCode}");
    }
    return _productsInCategory;
  }

  List<ProductsModel> productsInCart = [];

  void addProductToCart(ProductsModel product) {
    print(productsInCart);

    productsInCart.add(product);
  }

  List<ProductsModel> getProductsInCart() {
    print(productsInCart);
    return productsInCart;
  }

  Future<ProductsModel> getSingleProductData(int productId) async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/$productId'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      return ProductsModel.fromJson(data);
    }

    return ProductsModel.fromJson(data);
  }
}
