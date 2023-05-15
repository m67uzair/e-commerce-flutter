import 'dart:convert';
import '../Models/products_model.dart';
import 'package:http/http.dart' as http;

class ProductsController {
  List<ProductsModel> mensProductsList = [];
  List<ProductsModel> womensProductsList = [];
  List<ProductsModel> electronicsProductsList = [];
  List<ProductsModel> jeweleryProductsList = [];

  Future<List<ProductsModel>> getProductsData(String category) async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/category/$category'));
    var data = jsonDecode(response.body.toString());
    print("data getooo: " + data.toString());
    if (response.statusCode == 200) {
      switch (category) {
        case "men's clothing":
          {
            mensProductsList.clear();
            for (Map i in data) {
              mensProductsList.add(ProductsModel.fromJson(i));
            }
            return mensProductsList;
          }
        case "women's clothing":
          {
            womensProductsList.clear();
            for (Map i in data) {
              womensProductsList.add(ProductsModel.fromJson(i));
            }
            return womensProductsList;
          }
        case "jewelery":
          {
            jeweleryProductsList.clear();
            for (Map i in data) {
              jeweleryProductsList.add(ProductsModel.fromJson(i));
            }
            return jeweleryProductsList;
          }
        case "electronics":
          {
            electronicsProductsList.clear();
            for (Map i in data) {
              electronicsProductsList.add(ProductsModel.fromJson(i));
            }
            return electronicsProductsList;
          }
      }
      return [];
    } else {
      return [];
    }
  }
List<ProductsModel> productsInCart = [];
  void addProductToCart( ProductsModel product ){
    productsInCart.add(product);
    print(productsInCart);
  }

  List<ProductsModel> getProductsInCart(){
    return productsInCart;
  }

  Future<ProductsModel> getSingleProductData(int productId) async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/$productId'));
    var data = jsonDecode(response.body.toString());
    print("single product data getoooo : $data");

    if (response.statusCode == 200) {
      return ProductsModel.fromJson(data);
    }

    return ProductsModel.fromJson(data);
  }
}
