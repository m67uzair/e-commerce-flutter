import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      productsList.clear();
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
      // appBar: AppBar(
      //   leading: const Icon(Icons.menu_sharp),
      //   title: const Text(
      //     "Hello Word!",
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined))],
      // ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 220,
              child: CarouselSlider(items: const [
                ItemCarousel(
                  title: "Men's Clothing",
                  imagePath: "assets/images/men's clothing model.PNG",
                ),
                ItemCarousel(title: "Women's Clothing", imagePath: "assets/images/women1.png")
              ], options: CarouselOptions(autoPlay: false, viewportFraction: 1, height: 400)),
            ),
            const SizedBox(height: 150),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Men's Clothing",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 30)),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "View All",
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 280,
              child: FutureBuilder(
                future: getProductsData(),
                builder: (context, AsyncSnapshot<List<ProductsModel>> snapshot) {
                  return ListView.builder(
                    itemCount: productsList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return SizedBox(
                          width: 160,
                          child: Stack(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Stack(
                                      children: [
                                        Image.network(snapshot.data![index].image.toString()),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 30,
                                right: -2,
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black45, spreadRadius: 1, blurRadius: 3, offset: Offset.zero)
                                      ]),
                                  child: const Icon(Icons.favorite_border),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemCarousel extends StatelessWidget {
  final String title;
  final String imagePath;

  const ItemCarousel({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          bottom: 10,
          left: 5,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Colors.white),
          ),
        )
      ],
    );
  }
}
