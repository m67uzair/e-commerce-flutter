import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../Models/products_model.dart';
import '../Controllers/products_controller.dart';

final productsApi = ProductsController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                ItemCarousel(title: "Women's Clothing", imagePath: "assets/images/women1.png"),
                // ItemCarousel(title: "Electronics", imagePath: "assets/images/electronics.jpeg"),
                // ItemCarousel(title: "Jewellery", imagePath: "assets/images/jewellery.jpeg"),
              ], options: CarouselOptions(autoPlay: false, viewportFraction: 1, height: 400)),
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
              productsListTitle: "Jewellery",
              onViewAllPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final String productsListTitle;
  final Function onViewAllPressed;

  ProductList({required this.productsListTitle, required this.onViewAllPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(productsListTitle,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 30)),
            TextButton(
                onPressed: onViewAllPressed(),
                child: const Text(
                  "View All",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ))
          ],
        ),
        SizedBox(
          height: 280,
          child: FutureBuilder(
            future: productsApi.getProductsData(productsListTitle.toLowerCase()),
            builder: (context, AsyncSnapshot<List<ProductsModel>> snapshot) {
              return ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return snapshot.data!.isNotEmpty
                        ? ProductCard(
                            productsImageURL: snapshot.data![index].image.toString(),
                            productsTitleURL: snapshot.data![index].title.toString(),
                          )
                        : Container();
                  }
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String productsTitleURL;
  final String productsImageURL;

  const ProductCard({Key? key, required this.productsTitleURL, required this.productsImageURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Stack(
        children: [
          Card(
            elevation: 0,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(productsImageURL),
                  ),
                ),
                RatingBar.builder(
                    itemCount: 5,
                    initialRating: 0,
                    maxRating: 5,
                    minRating: 0,
                    allowHalfRating: true,
                    itemSize: 22,
                    itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    }),
                Text(
                  productsTitleURL,
                  maxLines: 2,
                  style: const TextStyle(
                      color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            right: 0,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.white, boxShadow: const [
                BoxShadow(color: Colors.black45, spreadRadius: 1, blurRadius: 3, offset: Offset.zero)
              ]),
              child: const Icon(Icons.favorite_border),
            ),
          )
        ],
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
