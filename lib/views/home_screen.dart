import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app_flutter/Widgets/product_card_widget.dart';
import 'package:ecommerce_app_flutter/views/product_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/products_model.dart';
import '../Controllers/products_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProductsController productsApi;

  @override
  void initState() {
    productsApi = Provider.of<ProductsController>(context, listen: false);
    productsApi.fetchAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("home screen rebuilt");
    return Scaffold(
        // appBar: AppBar(
        //   leading: const Icon(Icons.menu_sharp),
        //   title: const Text(
        //     "Hello Word!",
        //     style: TextStyle(color: Colors.black),
        //   ),
        //   actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined))],
        // ),

        body: Consumer<ProductsController>(
      builder: (context, productsController, child) => productsController.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 220,
                    child: CarouselSlider(items: const [
                      ItemCarousel(title: "Men's Clothing", imagePath: "assets/images/men's clothing model.PNG"),
                      ItemCarousel(title: "Women's Clothing", imagePath: "assets/images/women1.png"),
                      ItemCarousel(title: "Electronics", imagePath: "assets/images/electronics.jpeg"),
                      ItemCarousel(title: "jewelery", imagePath: "assets/images/jewelery.jpeg"),
                    ], options: CarouselOptions(autoPlay: true, viewportFraction: 1, height: 400)),
                  ),
                  const SizedBox(height: 30),
                  ProductList(
                    productsListTitle: "Men's Clothing",
                    onViewAllPressed: () {},
                  ),
                  const SizedBox(height: 50),
                  ProductList(
                    productsListTitle: "Women's Clothing",
                    onViewAllPressed: () {},
                  ),
                  const SizedBox(height: 50),
                  ProductList(
                    productsListTitle: "Electronics",
                    onViewAllPressed: () {},
                  ),
                  const SizedBox(height: 50),
                  ProductList(
                    productsListTitle: "jewelery",
                    onViewAllPressed: () {},
                  ),
                ],
              ),
            ),
    ));
  }
}

class ProductList extends StatefulWidget {
  final String productsListTitle;
  final Function onViewAllPressed;

  const ProductList({super.key, required this.productsListTitle, required this.onViewAllPressed});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<ProductsModel> productsList = [];
  late final ProductsController productsApi;

  @override
  void initState() {
    print("init called");
    productsApi = Provider.of(context, listen: false);
    productsList = productsApi.fetchProductsInCategory(category: widget.productsListTitle.toLowerCase());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.productsListTitle,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 30)),
            TextButton(
                onPressed: widget.onViewAllPressed(),
                child: const Text(
                  "View All",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ))
          ],
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            itemCount: productsList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (productsList.isNotEmpty) {
                ProductsModel product = productsList[index];
                print("pado built ${productsList.length}");
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductViewScreen(
                                  productId: product.id!.toInt(),
                                  productImageURL: product.image.toString(),
                                  productTitle: product.title.toString(),
                                  productPrice: product.price!.toDouble(),
                                  productDescription: product.description.toString(),
                                  productRating: product.rating!,
                                )));
                  },
                  child: ProductCard(
                    productImageURL: product.image.toString(),
                    productTitle: product.title.toString(),
                    productRating: product.rating!.rate!.toDouble(),
                    productRatingCount: product.rating!.count!.toInt(),
                    productPrice: product.price!.toDouble(),
                    productId: product.id!.toInt(),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ]),
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
