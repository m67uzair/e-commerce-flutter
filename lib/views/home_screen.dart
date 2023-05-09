import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

import '../Models/products_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductsModel> productsList = [];

  Future<List<ProductsModel>> getProductsData() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map i in data) {
        productsList.add(ProductsModel.fromJson(i));
      }
      return productsList;
    } else {
      return productsList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu_sharp),
        title: const Text("Hello Wordl!", style: TextStyle(color: Colors.black
        ),),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined))],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getProductsData(),
              builder: (context, AsyncSnapshot<List<ProductsModel>> snapshot) {
                print(productsList.length);
                return ListView.builder(
                  itemCount: productsList.length,
                  itemBuilder: (context, index) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ListTile(
                        title: Text(snapshot.data![index].title.toString(), style: TextStyle(color: Colors.black)),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
