import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Models/products_model.dart';
import 'package:http/http.dart' as http;

class ProductsController extends ChangeNotifier {
  bool _isLoading = true;

  final List<ProductsModel> _allProducts = [];
  List<ProductsModel> _productsInCategory = [];
  List _categories = [];

  bool get isLoading => _isLoading;

  List get categories => _categories;

  List<ProductsModel> get productsInCategory => _productsInCategory;

  List<ProductsModel> get allProducts => _allProducts;

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse("https://fakestoreapi.com/products/categories"));
    List data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      _categories = data.toList();
    } else {
      Fluttertoast.showToast(msg: "Error Code: ${response.statusCode}");
    }
  }

  // String selectedCategory(){
  //
  // }

  List<ProductsModel> fetchProductsInCategory({String? category}) {
    if (category != null) {
      _productsInCategory =
          _allProducts.where((element) => element.category!.toLowerCase() == category.toLowerCase()).toList();
      print("categories: ${_productsInCategory.length}");

      return _productsInCategory;
    } else {
      return _allProducts;
    }
  }

  Future<void> fetchAllProducts() async {
    final response = await http.get(Uri.parse("https://fakestoreapi.com/products"));
    await fetchCategories();
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
    }
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

// final response = await http.get(Uri.parse("https://fakestoreapi.com/products/category/$category"));
// var data = jsonDecode(response.body.toString());
//
// if (response.statusCode == 200) {
//   switch (category) {
//     case "men's clothing":
//       {
//         mensProductsList.clear();
//         for (Map i in data) {
//           mensProductsList.add(ProductsModel.fromJson(i));
//         }
//         return mensProductsList;
//       }
//
//     case "women's clothing":
//       {
//         womensProductsList.clear();
//         for (Map i in data) {
//           womensProductsList.add(ProductsModel.fromJson(i));
//         }
//         return womensProductsList;
//       }
//
//     case "electronics":
//       {
//         electronicsProductsList.clear();
//         for (Map i in data) {
//           electronicsProductsList.add(ProductsModel.fromJson(i));
//         }
//         return electronicsProductsList;
//       }
//
//     case "jewelery":
//       {
//         jeweleryProductsList.clear();
//         for (Map i in data) {
//           jeweleryProductsList.add(ProductsModel.fromJson(i));
//         }
//         return jeweleryProductsList;
//       }
//   }
// } else {
//   Fluttertoast.showToast(msg: "Error Code: ${response.statusCode}");
//   return [];
// }
// return [];
