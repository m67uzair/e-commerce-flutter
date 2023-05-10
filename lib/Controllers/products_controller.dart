import 'dart:convert';
import '../Models/products_model.dart';
import 'package:http/http.dart' as http;

class ProductsController {
  List<ProductsModel> mensProductsList = [];
  List<ProductsModel> womensProductsList = [];
  List<ProductsModel> electronicsProductsList = [];
  List<ProductsModel> jewelleryProductsList = [];

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
        case "jewellery":
          {
            jewelleryProductsList.clear();
            for (Map i in data) {
              jewelleryProductsList.add(ProductsModel.fromJson(i));
            }
            return jewelleryProductsList;
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
}
